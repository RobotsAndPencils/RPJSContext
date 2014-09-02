//
//  RPJSTimerSpec.m
//  RPJSContextDemo
//
//  Created by Brandon Evans on 2014-04-25.
//  Copyright (c) 2014 Robots and Pencils. All rights reserved.
//

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

#import <JavaScriptCore/JavaScriptCore.h>

#import "RPJSContext.h"

SpecBegin(RPJSTimer)

spt_describe(@"RPJSTimer", ^{
    __block RPJSContext *context;
    
    spt_beforeEach(^{
        context = [[RPJSContext alloc] init];
    });
    
    spt_it(@"should call a function after 1.0s", ^{
        spt_waitUntil(^(DoneCallback done) {
            context[@"test"] = ^{
                done();
            };
            [context evaluateScript:@"Timer.evaluateFunctionWithDelay(function() { test(); }, 1.0);"];
        });
    });
    
    spt_it(@"should repeat", ^{
        spt_waitUntil(^(DoneCallback done) {
            __block NSInteger repeatCount = 0;
            context[@"test"] = ^{
                repeatCount += 1;

                // Can't go on forever...
                if (repeatCount == 5) done();
            };
            [context evaluateScript:@"Timer.evaluateFunctionWithDelay(function() { test(); }, 1.0, true);"];
        });
    });
    
    spt_it(@"should pass arguments", ^{
        spt_waitUntil(^(DoneCallback done) {
            context[@"test"] = ^(JSValue *message){
                expect([message toString]).to.equal(@"passed");
                done();
            };
            [context evaluateScript:@"Timer.evaluateFunctionWithDelay(function(message) { test(message); }, 1.0, false, ['passed']);"];
        });
    });
});

SpecEnd