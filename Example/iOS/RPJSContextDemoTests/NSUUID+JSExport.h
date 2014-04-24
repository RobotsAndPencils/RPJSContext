//
//  NSUUID+JSExport.h
//  RPJSContextDemo
//
//  Created by Brandon Evans on 2014-04-24.
//  Copyright (c) 2014 Robots and Pencils. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

@protocol NSUUIDExport <JSExport>

+ (NSUUID *)UUID;
- (NSString *)UUIDString;

@end

@interface NSUUID (JSExport) <NSUUIDExport>

@end
