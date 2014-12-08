//
//  RPJSRequestSpec.m
//  RPJSContextDemo
//
//  Created by Brandon Evans on 2014-04-25.
//  Copyright (c) 2014 Robots and Pencils. All rights reserved.
//

@import JavaScriptCore;

#import <Kiwi/Kiwi.h>

#import "RPJSContext.h"

SPEC_BEGIN(RPJSRequestSpec)

describe(@"RPJSRequest", ^{
    __block RPJSContext *context;
    
    beforeEach(^{
        context = [[RPJSContext alloc] init];
        [context evaluateScript:@"var request = require('request');"];
    });
    
    it(@"should GET JSON", ^{
        NSString *downloadScript = @"var json; request.get('http://api.openweathermap.org/data/2.5/weather?q=Calgary,AB').then(function(response) { json = JSON.parse(response); }, null);";
        [context evaluateScript:downloadScript];

        [[expectFutureValue(context[@"json"]) shouldEventually] beNonNil];
        [[expectFutureValue(theValue([context[@"json"] isUndefined])) shouldEventuallyBeforeTimingOutAfter(5.0)] beNo];
        [[expectFutureValue([[context[@"json"] toDictionary] allKeys]) shouldEventually] haveCountOfAtLeast:1];
    });
    
    it(@"should GET HTML", ^{
        NSString *downloadScript = @"var responseString; request.get('http://www.apple.com').then(function(response) { responseString = response; }, null);";
        [context evaluateScript:downloadScript];

        [[expectFutureValue(context[@"responseString"]) shouldEventually] beNonNil];
        [[expectFutureValue(theValue([context[@"responseString"] isUndefined])) shouldEventuallyBeforeTimingOutAfter(5.0)] beNo];
        [[expectFutureValue([context[@"responseString"] toString]) shouldEventually] haveLengthOfAtLeast:1];
    });
    
    it(@"should POST JSON", ^{
        NSString *downloadScript = @"var json; request.post('http://httpbin.org/post', { 'text': 'example text' }).then(function(response) { json = response; }, null);";
        [context evaluateScript:downloadScript];

        [[expectFutureValue(context[@"json"]) shouldEventually] beNonNil];
        [[expectFutureValue(theValue([context[@"json"] isUndefined])) shouldEventuallyBeforeTimingOutAfter(5.0)] beNo];
        [[expectFutureValue([context[@"json"] toString]) shouldEventually] haveLengthOfAtLeast:1];
    });
});

SPEC_END
