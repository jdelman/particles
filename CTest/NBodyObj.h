//
//  NBodyObj.h
//  CTest
//
//  Created by Joshua Delman on 12/12/15.
//  Copyright © 2015 Pemdas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBodyObj : NSObject

@property (readonly) int numberOfParticles;
@property (readonly) double delta;
- (double (*)[2])getPosition;
- (double (*)[2])getVelocity;
- (double)getTime;
- (double)getCollTime;
- (int)getStepCount;

- (void)evolve;
- (instancetype)initWithDefaults;
- (instancetype)initWithParticles:(int)n dt:(double)_dt mass:(double[])mass pos:(double[][2])pos vel:(double[][2])vel;

@end
