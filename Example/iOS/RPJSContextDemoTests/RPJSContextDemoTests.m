//
//  RPJSContextDemoTests.m
//  RPJSContextDemoTests
//
//  Created by Brandon Evans on 2014-04-24.
//  Copyright (c) 2014 Robots and Pencils. All rights reserved.
//

#import <Kiwi/Kiwi.h>

#import <JavaScriptCore/JavaScriptCore.h>

#import "RPJSContext.h"

SPEC_BEGIN(RPJSContextDemoTests)

describe(@"RPJSContext", ^{
    __block RPJSContext *context;
    
    beforeEach(^{
        context = [[RPJSContext alloc] init];
    });
    
    specify(^{
        [[context shouldNot] beNil];
    });
    
    it(@"should evaluate a JS script file", ^{
        JSValue *result = [context evaluateScriptFileWithName:@"BasicJavaScript"];
        
        [[result shouldNot] beNil];
        [[theValue([result isUndefined]) should] equal:@NO];
        [[[result[@"testString"] toString] should] equal:@"Some text."];
        [[[result[@"sum"] toNumber] should] equal:@8];
    });
    
    it(@"should require a JS module", ^{
        [context requireModules:@[ @"TestModule" ]];
        JSValue *testModule = context[@"TestModule"];
        
        JSValue *sum = [testModule[@"add"] callWithArguments:@[ @1, @2 ]];
        [[[sum toNumber] should] equal:@3];

        JSValue *one = testModule[@"one"];
        [[[one toNumber] should] equal:@1];
    });
    
    it(@"should require an exported native class as a module", ^{
        [context requireModules:@[ @"NSUUID" ]];
        
        JSValue *UUIDStringValue = [context evaluateScript:@"NSUUID.UUID().UUIDString();"];
        [[UUIDStringValue shouldNot] beNil];
        [[theValue([UUIDStringValue isUndefined]) should] equal:@NO];
        [[theValue([[UUIDStringValue toString] length]) shouldNot] equal:@0];
    });
});

SPEC_END
