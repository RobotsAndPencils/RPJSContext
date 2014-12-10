//
//  RPJSRequest.m
//  RPJSContext
//
//  Created by Brandon Evans on 2014-04-24.
//  Copyright (c) 2014 Robots and Pencils. All rights reserved.
//

#import "RPJSRequest.h"
#import "AFHTTPRequestOperationManager.h"

@implementation RPJSRequest

+ (void)setupInContext:(JSContext *)context {
    context[@"__request_get"] = ^(NSString *url, JSValue *successCallback, JSValue *errorCallback) {
        [[RPJSRequest sharedManager] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            [successCallback callWithArguments:@[ responseString ]];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [errorCallback callWithArguments:@[ [[error userInfo] description] ]];
        }];
    };
    context[@"__request_post"] = ^(NSString *url, NSDictionary *parameters, JSValue *successCallback, JSValue *errorCallback) {
        [[RPJSRequest sharedManager] POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            [successCallback callWithArguments:@[ responseString ]];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [errorCallback callWithArguments:@[ [[error userInfo] description] ]];
        }];
    };
}

#pragma mark - Private

+ (AFHTTPRequestOperationManager *)sharedManager {
    static dispatch_once_t once;
    static AFHTTPRequestOperationManager *requestManager;
    dispatch_once(&once, ^{
        requestManager = [AFHTTPRequestOperationManager manager];
        requestManager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    });
    return requestManager;
}

@end
