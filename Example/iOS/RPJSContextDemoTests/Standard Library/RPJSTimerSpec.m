//
//  RPJSTimerSpec.m
//  RPJSContextDemo
//
//  Created by Brandon Evans on 2014-04-25.
//  Copyright (c) 2014 Robots and Pencils. All rights reserved.
//

@import JavaScriptCore;

#import <Kiwi/Kiwi.h>

#import "RPJSContext.h"

SPEC_BEGIN(RPJSTimerSpec)

describe(@"RPJSTimers", ^{
    __block RPJSContext *context;
    
    beforeEach(^{
        context = [[RPJSContext alloc] init];
    });
    
    it(@"should call a function after 1.0s", ^{
        [context evaluateScript:@"var test = false; setTimeout(function() { test = true; }, 1000);"];
        [[expectFutureValue(theValue([context[@"test"] toBool])) shouldEventuallyBeforeTimingOutAfter(1.1)] beYes];
    });

    it(@"should pass arguments", ^{
        __block NSString *firstArgument;
        context[@"test"] = ^(JSValue *message){
            firstArgument = [message toString];
        };

        [context evaluateScript:@"setTimeout(function(message) { test(message); }, 1000, 'passed', 'second');"];

        [[expectFutureValue(firstArgument) shouldEventuallyBeforeTimingOutAfter(1.1)] equal:@"passed"];
    });
});

SPEC_END