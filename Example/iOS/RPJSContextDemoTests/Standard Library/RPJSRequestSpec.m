//
//  RPJSRequestSpec.m
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

SpecBegin(RPJSRequest)

spt_describe(@"RPJSRequest", ^{
    __block RPJSContext *context;
    
    spt_beforeEach(^{
        context = [[RPJSContext alloc] init];
        [context evaluateScript:@"var request = require('request');"];
    });
    
    spt_it(@"should GET JSON", ^{
        spt_waitUntil(^(DoneCallback done) {
            context[@"test"] = ^(JSValue *result){
                expect(result).toNot.beNil();
                expect([result isUndefined]).to.equal(NO);
                expect([[[result toDictionary] allKeys] count]).to.beGreaterThan(0);
                done();
            };

            context[@"fail"] = ^(JSValue *error){
                XCTFail(@"Error: %@", [error toString]);
                done();
            };

            NSString *downloadScript = @"request.get('http://api.openweathermap.org/data/2.5/weather?q=Calgary,AB').then(function(response) { var json = JSON.parse(response); console.log(json); test(json); }, function(error) { fail(error); });";
            [context evaluateScript:downloadScript];
        });
    });
    
    spt_it(@"should GET HTML", ^{
        spt_waitUntil(^(DoneCallback done) {
            context[@"test"] = ^(JSValue *result){
                expect(result).toNot.beNil();
                expect([result isUndefined]).to.equal(NO);
                expect([[result toString] length]).to.beGreaterThan(0);
                done();
            };

            context[@"fail"] = ^(JSValue *error){
                XCTFail(@"Error: %@", [error toString]);
                done();
            };

            NSString *downloadScript = @"request.get('http://www.apple.com').then(function(response) { test(response); }, function(error) { fail(error); });";
            [context evaluateScript:downloadScript];
        });
    });
    
    spt_it(@"should POST JSON", ^{
        spt_waitUntil(^(DoneCallback done) {
            context[@"test"] = ^(JSValue *result){
                expect(result).toNot.beNil();
                expect([result isUndefined]).to.equal(NO);
                expect([[result toString] length]).to.beGreaterThan(0);
                done();
            };

            context[@"fail"] = ^(JSValue *error){
                XCTFail(@"Error: %@", [error toString]);
                done();
            };

            NSString *downloadScript = @"request.post('http://httpbin.org/post', { 'text': 'example text' }).then(function(response) { test(response); }, function(error) { fail(error); });";
            [context evaluateScript:downloadScript];
        });
    });
});

SpecEnd