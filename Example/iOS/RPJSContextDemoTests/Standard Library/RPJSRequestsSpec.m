//
//  RPJSRequestsSpec.m
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

SpecBegin(RPJSRequests)

describe(@"RPJSRequests", ^{
    __block RPJSContext *context;
    
    beforeEach(^{
        context = [[RPJSContext alloc] init];
    });
    
    it(@"should GET JSON", ^AsyncBlock{
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
        
        NSString *downloadScript = @"var result; var error; Request.get('http://api.openweathermap.org/data/2.5/weather?q=Calgary,AB', {}, function(response) { result = response; test(result); }, function(error) { error = error; fail(error); });";
        [context evaluateScript:downloadScript];
    });
    
    it(@"should GET HTML", ^AsyncBlock{
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
        
        NSString *downloadScript = @"var result; var error; Request.get('http://www.apple.com', { dataType: 'html' }, function(response) { result = response; test(result); }, function(error) { error = error; fail(error); });";
        [context evaluateScript:downloadScript];
    });
    
    it(@"should POST JSON", ^AsyncBlock{
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
        
        NSString *downloadScript = @"var result; var error; Request.post('http://httpbin.org/post', { data: { 'text': 'example text' } }, function(response) { result = response; test(result); }, function(error) { fail(error); });";
        [context evaluateScript:downloadScript];
    });
});

SpecEnd