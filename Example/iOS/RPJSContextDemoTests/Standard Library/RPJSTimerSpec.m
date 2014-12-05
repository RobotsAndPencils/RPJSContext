//
//  RPJSTimerSpec.m
//  RPJSContextDemo
//
//  Created by Brandon Evans on 2014-04-25.
//  Copyright (c) 2014 Robots and Pencils. All rights reserved.
//

@import JavaScriptCore;

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

#import "RPJSContext.h"

SpecBegin(RPJSTimer)

spt_describe(@"RPJSTimers", ^{
    __block RPJSContext *context;
    
    spt_beforeEach(^{
        context = [[RPJSContext alloc] init];
    });
    
    spt_it(@"should call a function after 1.0s", ^{
        spt_waitUntil(^(DoneCallback done) {
            context[@"test"] = ^{
                done();
            };
            [context evaluateScript:@"setTimeout(function() { test(); }, 1000);"];
        });
    });

    spt_it(@"should pass arguments", ^{
        spt_waitUntil(^(DoneCallback done) {
            context[@"test"] = ^(JSValue *message){
                expect([message toString]).to.equal(@"passed");
                done();
            };
            [context evaluateScript:@"setTimeout(function(message) { test(message); }, 1000, 'passed', 'second');"];
        });
    });

    spt_pending(@"should repeat", ^{
        spt_waitUntil(^(DoneCallback done) {
            __block NSInteger repeatCount = 0;
            context[@"test"] = ^{
                repeatCount += 1;

                // Can't go on forever...
                if (repeatCount == 5) done();
            };
            [context evaluateScript:@"setInterval(function() { test(); }, 1000);"];
        });
    });
});

SpecEnd