//
//  plusplus.cpp
//  CTest
//
//  Created by Joshua Delman on 12/11/15.
//  Copyright © 2015 Pemdas. All rights reserved.
//

#include "plusplus.hpp"

PlusPlus::PlusPlus (int a, int b) {
    x = a;
    y = b;
}

int PlusPlus::add() {
    return x + y;
}
