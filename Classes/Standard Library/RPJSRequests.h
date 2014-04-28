//
//  RPJSRequests.h
//  RPJSContext
//
//  Created by Brandon Evans on 2014-04-24.
//  Copyright (c) 2014 Robots and Pencils. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

@protocol PCContextRequestsExport <JSExport>

JSExportAs(get,
+ (void)GETfromURL:(NSString *)urlString settings:(NSDictionary *)settings success:(JSValue *)success error:(JSValue *)error
);

JSExportAs(post,
+ (void)POSTtoURL:(NSString *)urlString settings:(NSDictionary *)settings success:(JSValue *)success error:(JSValue *)error
);

@end

@interface RPJSRequests : NSObject <PCContextRequestsExport>

/**
 *  Performs a GET request
 *
 *  @param urlString   The URL to make the request to
 *  @param settings A dictionary of settings, with possible keys of data (a valid JSON type) and dataType (response type, "json" or "html")
 *  @param success  A JS function for success callback
 *  @param error    A JS function for error callback
 */
+ (void)GETfromURL:(NSString *)urlString settings:(NSDictionary *)settings success:(JSValue *)success error:(JSValue *)error;

/**
 *  Performs a POST request
 *
 *  @param urlString   The URL to make the request to
 *  @param settings A dictionary of settings, with possible keys of data (a valid JSON type) and dataType (response type, "json" or "html")
 *  @param success  A JS function for success callback
 *  @param error    A JS function for error callback
 */
+ (void)POSTtoURL:(NSString *)urlString settings:(NSDictionary *)settings success:(JSValue *)success error:(JSValue *)error;

@end
