//
//  RPJSContextDemoTests.m
//  RPJSContextDemoTests
//
//  Created by Brandon Evans on 2014-04-24.
//  Copyright (c) 2014 Robots and Pencils. All rights reserved.
//

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

#import <JavaScriptCore/JavaScriptCore.h>

#import "RPJSContext.h"

SpecBegin(RPJSContext)

spt_describe(@"RPJSContext", ^{
    __block RPJSContext *context;
    
    spt_beforeEach(^{
        context = [[RPJSContext alloc] init];
    });
    
    spt_it(@"should initialize", ^{
        expect(context).notTo.beNil();
    });
    
    spt_it(@"should evaluate a JS script string bound to a variable", ^{
        // Workaround for JSC date bug where seconds aren't converted to milliseconds
        NSDate *testDate = [NSDate date];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        NSString *year = [NSString stringWithFormat:@"%ld", (long)[components year]];
        
        [context evaluateScript:@"var year;"];
        NSString *script = @"year = this.getFullYear();";

        context[@"testDate"] = testDate;
        [context evaluateScript:script withInstanceName:@"testDate"];
        JSValue *yearValue = context[@"year"];
        
        expect(yearValue).notTo.beNil();
        expect([yearValue isUndefined]).notTo.equal(YES);
        expect([yearValue toString]).to.equal(year);
    });
    
    spt_it(@"should evaluate a JS script file", ^{
        JSValue *result = [context evaluateScriptFileWithName:@"BasicJavaScript"];
        
        expect(result).notTo.beNil();
        expect([result isUndefined]).notTo.equal(YES);
        expect([result[@"testString"] toString]).to.equal(@"Some text.");
        expect([result[@"sum"] toNumber]).to.equal(@8);
    });
    
    spt_it(@"should trigger an event", ^{
        NSString *eventHandler = @"var result; Event.on('GotchaEvent', function() { result = 'gotcha!'; });";
        [context evaluateScript:eventHandler];
        
        [context triggerEventWithName:@"GotchaEvent"];

        JSValue *result = context[@"result"];
        expect(result).notTo.beNil();
        expect([result isUndefined]).notTo.equal(YES);
        expect([result toString]).to.equal(@"gotcha!");
    });
    
    spt_it(@"should trigger an event with arguments", ^{
        NSString *eventHandler = @"var result; Event.on('GotchaEvent', function(message) { result = message; });";
        [context evaluateScript:eventHandler];
        
        [context triggerEventWithName:@"GotchaEvent" arguments:@[ @"'gotcha!'" ]];
        
        JSValue *result = context[@"result"];
        expect(result).notTo.beNil();
        expect([result isUndefined]).notTo.equal(YES);
        expect([result toString]).to.equal(@"gotcha!");
    });
    
    spt_it(@"should require a JS module", ^{
        [context requireModules:@[ @"TestModule" ]];
        JSValue *testModule = context[@"TestModule"];
        
        JSValue *sum = [testModule[@"add"] callWithArguments:@[ @1, @2 ]];
        expect([sum toNumber]).to.equal(@3);
        
        JSValue *one = testModule[@"one"];
        expect([one toNumber]).to.equal(@1);
    });
    
    spt_it(@"should require an exported native class as a module", ^{
        [context requireModules:@[ @"NSUUID" ]];
        
        JSValue *UUIDStringValue = [context evaluateScript:@"NSUUID.UUID().UUIDString();"];
        expect(UUIDStringValue).notTo.beNil();
        expect([UUIDStringValue isUndefined]).notTo.equal(YES);
        expect([[UUIDStringValue toString] length]).notTo.equal(0);
    });
});

SpecEnd
