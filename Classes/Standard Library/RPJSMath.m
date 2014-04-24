//
//  RPJSMath.m
//  RPJSContext
//
//  Created by Brandon Evans on 2014-04-24.
//  Copyright (c) 2014 Robots and Pencils. All rights reserved.
//

#import "RPJSMath.h"

#define ARC4RANDOM_MAX 0x100000000

@implementation RPJSMath

+ (CGFloat)random {
    return (CGFloat)arc4random() / ARC4RANDOM_MAX;
}

@end
