//
//  ViewController.m
//  CTest
//
//  Created by Joshua Delman on 12/11/15.
//  Copyright © 2015 Pemdas. All rights reserved.
//

#import "ViewController.h"
#import "PlusPlusObj.h"
#import "NBodyObj.h"

@interface ViewController ()

@property (strong, nonatomic) NBodyObj *nbody;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    
//    [self createDefaultNBody];
}

- (double)randomPositionForNParticles:(int)n {
    double R = sqrt(n);
    double num = (R * rand()) / RAND_MAX;
    NSLog(@"random position: %f", num);
    return num;
}

- (double)randomVelocity {
    double num = (.1 * rand()) / RAND_MAX;
    NSLog(@"random velocity: %f", num);
    return num;
}

- (void)createDefaultNBody {
    self.nbody = [[NBodyObj alloc] initWithDefaults];
}

- (void)createNbodyObjWithParticles:(int)n {
    // first, use starter.c's code to generate the variables.
    
    double mass_ = 1.0;

    double mass[n];
    for (int i = 0; i < n; i++) {
        mass[i] = mass_;
    }
    
    double pos[n][2];
    double vel[n][2];
    for (int i = 0; i < n; i++) {
        pos[n][0] = [self randomPositionForNParticles:n];
        pos[n][1] = [self randomPositionForNParticles:n];
        vel[n][0] = [self randomVelocity];
        vel[n][1] = [self randomVelocity];
    }
    
    self.nbody = [[NBodyObj alloc] initWithParticles:n dt:1 mass:mass pos:pos vel:vel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonTapped:(id)sender {
        [NSTimer scheduledTimerWithTimeInterval:1/30.f target:self.pView selector:@selector(step) userInfo:nil repeats:YES];
//        [self.pView step];
    
    
//    double (* pos)[2] = [self.pView.nbody getPosition];
//    NSLog(@"Particle 50: %f, %f", pos[50][0], pos[50][1]);
    
//    double (* pos)[2] = [self.pView.nbody getPosition];
//    for (int i = 0; i < self.pView.nbody.numberOfParticles; i++) {
//        NSLog(@"Particle %i: %f, %f", i, pos[i][0], pos[i][1]);
//    }
//    NSLog(@"time: %f", [self.pView.nbody getTime]);
//    NSLog(@"coll time: %f", [self.pView.nbody getCollTime]);
//    NSLog(@"number of steps: %i", [self.pView.nbody getStepCount]);
}

@end
