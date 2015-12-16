//
//  ParticleView.h
//  CTest
//
//  Created by Joshua Delman on 12/12/15.
//  Copyright © 2015 Pemdas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBodyObj.h"

@interface ParticleView : UIView

@property (strong, nonatomic) NBodyObj *nbody;
- (void)step;

@end
