//
//  ParticleView.m
//  CTest
//
//  Created by Joshua Delman on 12/12/15.
//  Copyright © 2015 Pemdas. All rights reserved.
//

#import "ParticleView.h"

@implementation ParticleView

- (void)awakeFromNib {
    self.nbody = [[NBodyObj alloc] initWithDefaults];
    self.backgroundColor = [UIColor whiteColor];
}

- (void)step {
    [self.nbody evolve];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    NSLog(@"drawRect!");
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] set];
    CGContextFillRect(context, rect);
    [[UIColor blackColor] set];
    
    double (*pos)[2] = [self.nbody getPosition];
    for (int i = 0; i < self.nbody.numberOfParticles; i++) {
        double posX = pos[i][0];
        double posY = pos[i][1];
        
        // factorz
        posX = (posX + 1) * 30;
        posY = (posY + 1) * 30;
        
        CGRect pRect = CGRectMake(posX, posY, 2, 2);
        
        CGContextFillRect(context, pRect);
    }
    
    [super drawRect:rect];
}

@end
