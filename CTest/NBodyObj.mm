//
//  NBodyObj.mm
//  CTest
//
//  Created by Joshua Delman on 12/12/15.
//  Copyright © 2015 Pemdas. All rights reserved.
//

#import "NBodyObj.h"
#import "nbody.hpp"

@interface NBodyObj ()  {
    NBody *wrapped;
    int particleCount;
    int dt;
}

@end

@implementation NBodyObj

- (instancetype)initWithParticles:(int)n dt:(double)_dt mass:(double[])mass pos:(double[][NDIM])pos vel:(double[][NDIM])vel  {
    if (self = [super init]) {
        wrapped = new NBody(n, _dt, mass, pos, vel);
        particleCount = n;
        dt = _dt;
        if (!wrapped) self = nil;
    }
    return self;
}

- (instancetype)initWithDefaults {
    if (self = [super init]) {
        wrapped = new NBody();
        if (!wrapped) {
            self = nil;
        }
        else {
            particleCount = wrapped->n;
            dt = wrapped->dt_param;
        }
    }
    return self;
}

- (double (*)[NDIM])getPosition {
    return wrapped->pos;
}

- (double (*)[NDIM])getVelocity {
    return wrapped->vel;
}

- (double)getTime {
    return wrapped->t;
}

- (double)getCollTime {
    return wrapped->coll_time;
}

- (int)getStepCount {
    return wrapped->nsteps;
}

- (int)numberOfParticles {
    return particleCount;
}

- (double)delta {
    return dt;
}

- (void)evolve {
    wrapped->evolve();
}

- (void)dealloc
{
    delete wrapped;
}



@end
