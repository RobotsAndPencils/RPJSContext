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
#import "RPJSRequest.h"

@interface RPJSRequest (Tests)
+ (NSDictionary *)headersFromURLValue:(JSValue *)urlValue;
@end

SPEC_BEGIN(RPJSRequestSpec)

describe(@"RPJSRequest", ^{
    let(jsContext, ^id{
        return [[RPJSContext alloc] init];
    });
    let(requestObject, ^id{
        [jsContext evaluateScript:@"var request = require('request');"];
        return jsContext[@"request"];
    });
    let(jsonObject, ^id{
        return jsContext[@"JSON"];
    });

    describe(@"GET", ^{
        let(url, ^id{
            return @"http://httpbin.org/get";
        });

        describe(@"JSON", ^{
            describe(@"default headers", ^{
                it(@"should set the correct Accept header", ^{
                    __block NSDictionary *responseJSON;
                    void (^successBlock)(NSString *) = ^(NSString *response){
                        responseJSON = [[jsonObject invokeMethod:@"parse" withArguments:@[ response ]] toDictionary];
                    };

                    JSValue *postPromise = [requestObject invokeMethod:@"get" withArguments:@[ url ]];
                    [postPromise invokeMethod:@"then" withArguments:@[ successBlock ]];

                    [[expectFutureValue(responseJSON[@"headers"][@"Accept"]) shouldEventually] equal:@"application/json"];
                });
            });

            describe(@"custom Accept header", ^{
                let(customAcceptHeader, ^id{
                    return @"text/html";
                });
                let(options, ^id{
                    return @{ @"url": url, @"headers": @{ @"Accept": customAcceptHeader } };
                });

                it(@"should set the correct Accept header", ^{
                    __block NSDictionary *responseJSON;
                    void (^successBlock)(NSString *) = ^(NSString *response){
                        responseJSON = [[jsonObject invokeMethod:@"parse" withArguments:@[ response ]] toDictionary];
                    };

                    JSValue *postPromise = [requestObject invokeMethod:@"get" withArguments:@[ options ]];
                    [postPromise invokeMethod:@"then" withArguments:@[ successBlock ]];

                    [[expectFutureValue(responseJSON[@"headers"][@"Accept"]) shouldEventually] equal:customAcceptHeader];
                });
            });
        });

        describe(@"HTML", ^{
            let(url, ^id{
                return @"http://httpbin.org/html";
            });

            it(@"should fetch an HTML string", ^{
                __block NSString *responseString;
                void (^successBlock)(NSString *) = ^(NSString *response){
                    responseString = response;
                };

                JSValue *postPromise = [requestObject invokeMethod:@"get" withArguments:@[ url ]];
                [postPromise invokeMethod:@"then" withArguments:@[ successBlock ]];

                [[expectFutureValue(responseString) shouldEventually] containString:@"<html"];
            });
        });
    });
    
    describe(@"POST", ^{
        let(url, ^id{
            return @"http://httpbin.org/post";
        });

        describe(@"JSON", ^{
            let(someJSON, ^id{
                return @{ @"text": @"example text" };
            });

            describe(@"default headers", ^{
                let(defaultAcceptHeader, ^id{
                    return @"application/json";
                });

                it(@"should have the correct Accept header", ^{
                    __block NSDictionary *responseJSON;
                    void (^successBlock)(NSString *) = ^(NSString *response){
                        responseJSON = [[jsContext[@"JSON"] invokeMethod:@"parse" withArguments:@[ response ]] toDictionary];
                    };

                    JSValue *postPromise = [requestObject invokeMethod:@"post" withArguments:@[ url, someJSON ]];
                    [postPromise invokeMethod:@"then" withArguments:@[ successBlock ]];

                    [[expectFutureValue(responseJSON[@"headers"][@"Accept"]) shouldEventually] equal:defaultAcceptHeader];
                });
            });

            describe(@"custom Accept header", ^{
                let(customAcceptHeader, ^id{
                    return @"text/html";
                });
                let(options, ^id{
                    return @{ @"url": url, @"headers": @{ @"Accept": customAcceptHeader } };
                });

                it(@"should have the correct Accept header", ^{
                    __block NSDictionary *responseJSON;
                    void (^successBlock)(NSString *) = ^(NSString *response){
                        responseJSON = [[jsContext[@"JSON"] invokeMethod:@"parse" withArguments:@[ response ]] toDictionary];
                    };

                    JSValue *postPromise = [requestObject invokeMethod:@"post" withArguments:@[ options, someJSON ]];
                    [postPromise invokeMethod:@"then" withArguments:@[ successBlock ]];

                    [[expectFutureValue(responseJSON[@"headers"][@"Accept"]) shouldEventually] equal:customAcceptHeader];
                });
                it(@"should submit the correct parameters", ^{
                    __block NSDictionary *responseJSON;
                    void (^successBlock)(NSString *) = ^(NSString *response){
                        responseJSON = [[jsContext[@"JSON"] invokeMethod:@"parse" withArguments:@[ response ]] toDictionary];
                    };

                    JSValue *postPromise = [requestObject invokeMethod:@"post" withArguments:@[ options, someJSON ]];
                    [postPromise invokeMethod:@"then" withArguments:@[ successBlock ]];

                    [[expectFutureValue(responseJSON[@"json"]) shouldEventually] equal:someJSON];
                });
            });
        });
    });
});

describe(@"headersFromURLValue:", ^{
    let(context, ^id{
        return [RPJSContext new];
    });

    describe(@"nil argument", ^{
        let(urlValue, ^id{
            return nil;
        });

        specify(^{
            [[[RPJSRequest headersFromURLValue:urlValue] should] equal:@{}];
        });
    });

    describe(@"String argument", ^{
        let(urlValue, ^id{
            return [JSValue valueWithObject:@"http://httpbin.org" inContext:context];
        });

        specify(^{
            [[[RPJSRequest headersFromURLValue:urlValue] should] equal:@{}];
        });
    });

    describe(@"Object argument", ^{
        describe(@"with valid headers property", ^{
            let(acceptHeader, ^id{
                return @{ @"Accept": @"text/html" };
            });
            let(urlValue, ^id{
                return [JSValue valueWithObject:@{ @"url": @"http://httpbin.org", @"headers": acceptHeader } inContext:context];
            });

            specify(^{
                [[[RPJSRequest headersFromURLValue:urlValue] should] equal:acceptHeader];
            });
        });

        describe(@"without headers property", ^{
            let(urlValue, ^id{
                return [JSValue valueWithObject:@{ @"url": @"http://httpbin.org" } inContext:context];
            });

            specify(^{
                [[[RPJSRequest headersFromURLValue:urlValue] should] equal:@{}];
            });
        });

        describe(@"with null headers property", ^{
            let(urlValue, ^id{
                return [JSValue valueWithObject:@{ @"headers": [NSNull null] } inContext:context];
            });

            specify(^{
                [[[RPJSRequest headersFromURLValue:urlValue] should] equal:@{}];
            });
        });
    });
});

SPEC_END
