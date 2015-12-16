//
//  PlusPlusObj.mm
//  CTest
//
//  Created by Joshua Delman on 12/11/15.
//  Copyright © 2015 Pemdas. All rights reserved.
//

#import "PlusPlusObj.h"
#import "plusplus.hpp"

@implementation PlusPlusObj {
    PlusPlus *wrapped;
}

- (id)initWithA:(int)a B:(int)b {
    if (self = [super init]) {
        wrapped = new PlusPlus(a, b);
        if (!wrapped) self = nil;
    }
    
    return self;
}

- (int)wrappedAdd {
    return wrapped->add();
}

@end
