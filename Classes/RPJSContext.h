//
//  RPJSContext.h
//  RPJSContext
//
//  Created by Brandon Evans on 2014-04-24.
//  Copyright (c) 2014 Robots and Pencils. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

typedef void(^RPJSContextExceptionHandler)(JSContext *, JSValue *);
typedef void(^RPJSContextLogHandler)(NSString *);

@interface RPJSContext : JSContext

@property (nonatomic, copy) RPJSContextExceptionHandler customExceptionHandler;
@property (nonatomic, copy) RPJSContextLogHandler logHandler;

- (void)evaluateScript:(NSString *)script withInstanceName:(NSString *)instanceName;
- (void)evaluateScriptFileWithName:(NSString *)name;

- (void)requireModules:(NSArray *)modules;

- (void)triggerEventWithName:(NSString* )eventName;
- (void)triggerEventWithName:(NSString *)eventName arguments:(NSArray *)arguments;

@end
