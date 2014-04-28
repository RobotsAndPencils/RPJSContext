//
//  RPJSRequests.m
//  RPJSContext
//
//  Created by Brandon Evans on 2014-04-24.
//  Copyright (c) 2014 Robots and Pencils. All rights reserved.
//

#import "RPJSRequests.h"
#import "AFHTTPRequestOperationManager.h"

static NSString *const RPJSContextRequestGET = @"GET";
static NSString *const RPJSContextRequestPOST = @"POST";

static NSString *const RPJSContextRequestsJSON = @"json";
static NSString *const RPJSContextRequestsHTML = @"html";

@implementation RPJSRequests

#pragma mark - Public

+ (void)GETfromURL:(NSString *)urlString settings:(NSDictionary *)settings success:(JSValue *)success error:(JSValue *)error {
    [self requestToURL:[NSURL URLWithString:urlString] method:RPJSContextRequestGET settings:settings success:success error:error];
}

+ (void)POSTtoURL:(NSString *)urlString settings:(NSDictionary *)settings success:(JSValue *)success error:(JSValue *)error {
    [self requestToURL:[NSURL URLWithString:urlString] method:RPJSContextRequestPOST settings:settings success:success error:error];
}

#pragma mark - Private

+ (AFHTTPRequestOperationManager *)sharedManager {
    static dispatch_once_t once;
    static AFHTTPRequestOperationManager *requestManager;
    dispatch_once(&once, ^{
        requestManager = [AFHTTPRequestOperationManager manager];
    });
    return requestManager;
}

+ (void)requestToURL:(NSURL *)url method:(NSString *)method settings:(NSDictionary *)settings success:(JSValue *)successCallback error:(JSValue *)errorCallback {
    if (!url) {
        if (errorCallback) {
            [errorCallback callWithArguments:@[ ]];
        }
    }
    
    NSMutableDictionary *mutableSettings = settings ? [settings mutableCopy] : [NSMutableDictionary dictionary];
    
    if (!mutableSettings[@"data"]) {
        mutableSettings[@"data"] = @{ };
    }
    id data = mutableSettings[@"data"];
    
    // defaults to JSON response data type
    NSString *dataType = mutableSettings[@"dataType"];
    if (!dataType) {
        dataType = RPJSContextRequestsJSON;
    }
    
    [RPJSRequests sharedManager].requestSerializer = [AFJSONRequestSerializer serializer];
    
    if ([dataType isEqualToString:RPJSContextRequestsJSON]) {
        [RPJSRequests sharedManager].responseSerializer = [AFJSONResponseSerializer serializer];
    }
    else if ([dataType isEqualToString:RPJSContextRequestsHTML]) {
        [RPJSRequests sharedManager].responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    
    if ([method isEqualToString:RPJSContextRequestGET]) {
        [[RPJSRequests sharedManager] GET:[url absoluteString] parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self callFunction:successCallback withResponseObject:responseObject dataType:dataType];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [errorCallback callWithArguments:@[ [[error userInfo] description] ]];
        }];
    }
    else if ([method isEqualToString:RPJSContextRequestPOST]) {
        [[RPJSRequests sharedManager] POST:[url absoluteString] parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self callFunction:successCallback withResponseObject:responseObject dataType:dataType];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [errorCallback callWithArguments:@[ [[error userInfo] description] ]];
        }];
    }
};

+ (void)callFunction:(JSValue *)callback withResponseObject:(id)responseObject dataType:(NSString *)dataType {
    if ([dataType isEqualToString:RPJSContextRequestsJSON]) {
        [callback callWithArguments:@[ responseObject ]];
    }
    else if ([dataType isEqualToString:RPJSContextRequestsHTML]) {
        NSString *htmlString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (!htmlString) {
            htmlString = @"";
        }
        [callback callWithArguments:@[ htmlString ]];
    }
    else {
        [callback callWithArguments:@[ responseObject ]];
    }
}

@end
