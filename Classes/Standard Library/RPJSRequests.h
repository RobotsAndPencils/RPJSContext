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
+ (void)GETfromURL:(NSString *)string settings:(NSDictionary *)settings success:(JSValue *)success error:(JSValue *)error
);

JSExportAs(post,
+ (void)POSTtoURL:(NSString *)string settings:(NSDictionary *)settings success:(JSValue *)success error:(JSValue *)error
);

@end

@interface RPJSRequests : NSObject <PCContextRequestsExport>

+ (void)GETfromURL:(NSString *)string settings:(NSDictionary *)settings success:(JSValue *)success error:(JSValue *)error;
+ (void)POSTtoURL:(NSString *)string settings:(NSDictionary *)settings success:(JSValue *)success error:(JSValue *)error;

@end
