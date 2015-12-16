//
//  nbody.cpp
//  CTest
//
//  Created by Joshua Delman on 12/11/15.
//  Copyright © 2015 Pemdas. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "nbody.hpp"

#include  <iostream>
#include  <cmath>                          // to include sqrt(), etc.
#include  <cstdlib>                        // for atoi() and atof()
#include  <unistd.h>                       // for getopt()
using namespace std;

NBody::NBody () {
    /* initialize */
    dt_param = 0.03;     // control parameter to determine time step size
    n = 100;                      // N, number of particles in the N-body system
    t = 0.0;                      // time
    nsteps = 0;               // number of integration time steps completed

    acc = new double[n][NDIM];          // accelerations and jerks
    jerk = new double[n][NDIM];         // for all particles
    
    mass = new double[n];                  // masses for all particles
    pos = new double[n][NDIM];     // positions for all particles
    vel = new double[n][NDIM];     // velocities for all particles
    
    srand48(time(0));
    double R = sqrt(n);
    for (int i = 0; i < n; i++) {
        mass[i] = 1000.0;
        for (int j = 0; j < NDIM; j++) {
            pos[i][j] = (R * drand48());
            vel[i][j] = (0.1 * drand48());
        }
    }
    
    get_acc_jerk_pot_coll();
}

NBody::NBody (int _n, double _dt_param, double _mass[], double _pos[][NDIM], double _vel[][NDIM]) {
    /* TODO: this constructor doesn't work (passing array is f*cked) */
    /* initial values, can be generated by starter.c */
    n = _n;
    dt_param = _dt_param;
    mass = _mass;
    pos = _pos;
    vel = _vel;
    
    t = 0.0;
    acc = new double[n][NDIM];          // accelerations and jerks
    jerk = new double[n][NDIM];         // for all particles
    nsteps = 0;               // number of integration time steps completed
    
    get_acc_jerk_pot_coll();
}

void NBody::get_acc_jerk_pot_coll()
{
    for (int i = 0; i < n ; i++)
        for (int k = 0; k < NDIM ; k++)
            acc[i][k] = jerk[i][k] = 0;
    epot = 0;
    const double VERY_LARGE_NUMBER = 1e300;
    double coll_time_q = VERY_LARGE_NUMBER;      // collision time to 4th power
    double coll_est_q;                           // collision time scale estimate
    // to 4th power (quartic)
    for (int i = 0; i < n ; i++){
        for (int j = i+1; j < n ; j++){            // rji[] is the vector from
            double rji[NDIM];                        // particle i to particle j
            double vji[NDIM];                        // vji[] = d rji[] / d t
            for (int k = 0; k < NDIM ; k++){
                rji[k] = pos[j][k] - pos[i][k];
                vji[k] = vel[j][k] - vel[i][k];
            }
            double r2 = 0;                           // | rji |^2
            double v2 = 0;                           // | vji |^2
            double rv_r2 = 0;                        // ( rij . vij ) / | rji |^2
            for (int k = 0; k < NDIM ; k++){
                r2 += rji[k] * rji[k];
                v2 += vji[k] * vji[k];
                rv_r2 += rji[k] * vji[k];
            }
            rv_r2 /= r2;
            double r = sqrt(r2);                     // | rji |
            double r3 = r * r2;                      // | rji |^3
            
            // add the {i,j} contribution to the total potential energy for the system:
            
            epot -= mass[i] * mass[j] / r;
//            NSLog(@"epot: %@", [NSNumber numberWithDouble:epot]);
            
            // add the {j (i)} contribution to the {i (j)} values of acceleration and jerk:
            
            double da[3];                            // main terms in pairwise
            double dj[3];                            // acceleration and jerk
            for (int k = 0; k < NDIM ; k++){
                da[k] = rji[k] / r3;                           // see equations
                dj[k] = (vji[k] - 3 * rv_r2 * rji[k]) / r3;    // in the header
            }
            for (int k = 0; k < NDIM ; k++){
                acc[i][k] += mass[j] * da[k];                 // using symmetry
                acc[j][k] -= mass[i] * da[k];                 // find pairwise
                jerk[i][k] += mass[j] * dj[k];                // acceleration
                jerk[j][k] -= mass[i] * dj[k];                // and jerk
            }
            
            // first collision time estimate, based on unaccelerated linear motion:
            
            coll_est_q = (r2*r2) / (v2*v2);
            if (coll_time_q > coll_est_q)
                coll_time_q = coll_est_q;
            
            // second collision time estimate, based on free fall:
            
            double da2 = 0;                                  // da2 becomes the
            for (int k = 0; k < NDIM ; k++)                // square of the
                da2 += da[k] * da[k];                      // pair-wise accel-
            double mij = mass[i] + mass[j];                // eration between
            da2 *= mij * mij;                              // particles i and j
            
            coll_est_q = r2/da2;
            if (coll_time_q > coll_est_q)
                coll_time_q = coll_est_q;
        }
    }                                               // from q for quartic back
    coll_time = sqrt(sqrt(coll_time_q));            // to linear collision time
}

void NBody::evolve_step(double dt)
{
    double (* old_pos)[NDIM] = new double[n][NDIM];
    double (* old_vel)[NDIM] = new double[n][NDIM];
    double (* old_acc)[NDIM] = new double[n][NDIM];
    double (* old_jerk)[NDIM] = new double[n][NDIM];
    
    for (int i = 0; i < n ; i++)
        for (int k = 0; k < NDIM ; k++){
            old_pos[i][k] = pos[i][k];
            old_vel[i][k] = vel[i][k];
            old_acc[i][k] = acc[i][k];
            old_jerk[i][k] = jerk[i][k];
        }
    
    predict_step(dt);
    get_acc_jerk_pot_coll();
    correct_step(old_pos, old_vel, old_acc, old_jerk, dt);
    
    t += dt;
    
    delete[] old_pos;
    delete[] old_vel;
    delete[] old_acc;
    delete[] old_jerk;
}

void NBody::correct_step(const double old_pos[][NDIM], const double old_vel[][NDIM], const double old_acc[][NDIM], const double old_jerk[][NDIM], double dt)
{
    for (int i = 0; i < n ; i++)
        for (int k = 0; k < NDIM ; k++){
            vel[i][k] = old_vel[i][k] + (old_acc[i][k] + acc[i][k])*dt/2
            + (old_jerk[i][k] - jerk[i][k])*dt*dt/12;
            pos[i][k] = old_pos[i][k] + (old_vel[i][k] + vel[i][k])*dt/2
            + (old_acc[i][k] - acc[i][k])*dt*dt/12;
        }
}

void NBody::predict_step(double dt)
{
    for (int i = 0; i < n ; i++)
        for (int k = 0; k < NDIM ; k++){
            pos[i][k] += vel[i][k]*dt + acc[i][k]*dt*dt/2
            + jerk[i][k]*dt*dt*dt/6;
            vel[i][k] += acc[i][k]*dt + jerk[i][k]*dt*dt/2;
        }
}

void NBody::evolve()
{

    NSLog(@"coll_time: %@", [NSNumber numberWithDouble:coll_time]);
    double dt = dt_param * coll_time;
    evolve_step(dt);
    nsteps++;
    
}
