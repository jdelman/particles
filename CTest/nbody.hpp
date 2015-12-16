//
//  nbody.hpp
//  CTest
//
//  Created by Joshua Delman on 12/11/15.
//  Copyright © 2015 Pemdas. All rights reserved.
//

#ifndef nbody_hpp
#define nbody_hpp

#include <stdio.h>

const int NDIM = 2;

class NBody {
    void predict_step(double dt);
    void get_acc_jerk_pot_coll();
    void evolve_step(double dt);
    void correct_step(const double old_pos[][NDIM], const double old_vel[][NDIM], const double old_acc[][NDIM], const double old_jerk[][NDIM], double dt);

public:
    int n;
    double t;
    double * mass;
    double (* pos)[NDIM];
    double (* vel)[NDIM];
    double (* acc)[NDIM];          // accelerations and jerks
    double (* jerk)[NDIM];         // for all particles
    double dt_param; // time delta between steps
    double epot;                        // potential energy of the n-body system
    double coll_time;                   // collision (close encounter) time scale
    int nsteps;               // number of integration time steps completed
    double einit;                   // initial total energy of the system

    
    NBody ();
    NBody (int _n, double _dt_param, double _mass[], double _pos[][NDIM], double _vel[][NDIM]);
    void evolve();

};

#endif /* nbody_hpp */
