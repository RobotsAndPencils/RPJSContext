//
//  RPJSJSON.h
//  RPJSContext
//
//  Created by Brandon Evans on 2014-04-24.
//  Copyright (c) 2014 Robots and Pencils. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

@protocol PCContextJSON <JSExport>

+ (NSString *)stringify:(id)object;
+ (id)parse:(NSString *)jsonString;

@end

@interface RPJSJSON : NSObject <PCContextJSON>

+ (NSString *)stringify:(id)object;
+ (id)parse:(NSString *)jsonString;

@end
