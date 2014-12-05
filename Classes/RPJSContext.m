//
//  RPJSContext.m
//  RPJSContext
//
//  Created by Brandon Evans on 2014-04-24.
//  Copyright (c) 2014 Robots and Pencils. All rights reserved.
//

#import "RPJSContext.h"

// Standard Library
#import "RPJSRequests.h"
#import "RPJSTimer.h"

@interface RPJSContext ()

@property (strong, nonatomic) RPJSTimer *timer;

@end

@implementation RPJSContext

- (id)init {
    self = [super init];
    if (self) {

        __weak __typeof(self) weakSelf = self;
        self.exceptionHandler = ^(JSContext *context, JSValue *exception) {
            if (weakSelf.customExceptionHandler) {
                weakSelf.customExceptionHandler(context, exception);
                return;
            }

            NSLog(@"[%@:%@:%@] %@\n%@", exception[@"sourceURL"], exception[@"line"], exception[@"column"], exception, [exception[@"stack"] toObject]);
        };

        // Replicate some browser/Node APIs
        void(^log)(NSString *) = ^(NSString *message) {
            if (weakSelf.logHandler) {
                weakSelf.logHandler(message);
                return;
            }
            
            NSLog(@"JS: %@", message);
        };
        self[@"console"] = @{
                                @"log": log,
                                @"warn": log,
                                @"info": log
                            };

        // For scripts that reference globals through the window object
        self[@"window"] = self.globalObject;
        
        // Basic CommonJS module require implementation (http://wiki.commonjs.org/wiki/Modules/1.1)
        self[@"require"] = ^JSValue *(NSString *moduleName) {
            NSLog(@"require: %@", moduleName);

            // Avoid a retain cycle
            JSContext *context = [RPJSContext currentContext];

            NSString *modulePath = [[NSBundle bundleForClass:[context class]] pathForResource:moduleName ofType:@"js"];
            NSData *moduleFileData = [NSData dataWithContentsOfFile:modulePath];
            NSString *moduleStringContents = [[NSString alloc] initWithData:moduleFileData encoding:NSUTF8StringEncoding];

            // Analagous to Node's require.resolve loading a core module (http://nodejs.org/api/modules.html#modules_the_module_object)
            if (!moduleStringContents || [moduleStringContents length] == 0) {
                moduleStringContents = [NSString stringWithFormat:@"module.exports = nativeClassWithName('%@');", moduleName];
            }

            NSString *exportScript = [NSString stringWithFormat:@"(function() { var module = { exports: {}}; var exports = module.exports; %@; return module.exports; })();", moduleStringContents];
            return [context evaluateScript:exportScript];
        };
        
        self[@"nativeClassWithName"] = ^JSValue *(NSString *className) {
            return [JSValue valueWithObject:NSClassFromString(className) inContext:[JSContext currentContext]];
        };
        
        // Workaround for the JSC bug where constructors aren't properly exported yet in 7.0.x
        self[@"createInstanceOfClass"] = ^id(NSString *className){
            return [[NSClassFromString(className) alloc] init];
        };
        
        // Standard library
        [self evaluateScriptFileWithName:@"lodash"];
        [self evaluateScriptFileWithName:@"EventEmitter"];
        [self evaluateScript:@"var Event = new EventEmitter();"];
        [self evaluateScript:@"_.extendNonEnumerable(Object.prototype, EventEmitter.prototype)"];

        self[@"Request"] = [RPJSRequests class];
        self.timer = [[RPJSTimer alloc] init];
        self[@"Timer"] = self.timer;
    }
    return self;
}

- (void)dealloc {
    [(RPJSTimer *)self.timer invalidateAllTimers];
    self.timer = nil;
}

#pragma mark - Public

- (JSValue *)evaluateScript:(NSString *)script withInstanceName:(NSString *)instanceName {
    NSString *wrappedScript = [NSString stringWithFormat:@"(function() { %@ }).call(%@);", script, instanceName];
    return [self evaluateScript:wrappedScript];
}

- (JSValue *)evaluateScriptFileAtPath:(NSString *)path {
    NSString *scriptContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    if (scriptContents) {
        return [self evaluateScript:scriptContents withSourceURL:[NSURL URLWithString:path]];
    }
    return nil;
}

- (JSValue *)evaluateScriptFileWithName:(NSString *)name {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:name ofType:@"js"];
    return [self evaluateScriptFileAtPath:path];
}

- (void)requireModules:(NSArray *)modules {
    for (NSString *moduleName in modules) {
        [self evaluateScript:[NSString stringWithFormat:@"var %@ = require('%@');", moduleName, moduleName]];
    }
}

- (void)triggerEventWithName:(NSString* )eventName {
    [self triggerEventWithName:eventName arguments:@[]];
}

- (void)triggerEventWithName:(NSString *)eventName arguments:(NSArray *)arguments {
    NSLog(@"Triggering '%@'", eventName);
    if (!arguments) {
        arguments = @[];
    }
    
    NSMutableString *argumentsString = [@"[" mutableCopy];
    for (NSString *argument in arguments) {
        [argumentsString appendString:argument];
        [argumentsString appendString:@","];
    }
    [argumentsString appendString:@"]"];
    
    [self evaluateScript:[NSString stringWithFormat:@"Event.trigger('%@', %@);", eventName, argumentsString]];
}

@end

