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
#import "RPJSJSON.h"
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
            
            NSLog(@"JS Exception: %@", exception);
        };
        
        self[@"log"] = ^(NSString *message) {
            if (weakSelf.logHandler) {
                weakSelf.logHandler(message);
                return;
            }
            
            NSLog(@"JS: %@", message);
        };
        
        // Basic CommonJS module require implementation ( http://wiki.commonjs.org/wiki/Modules/1.1 )
        self[@"require"] = ^JSValue *(NSString *moduleName) {
            NSLog(@"require: %@", moduleName);
            JSContext *context = [RPJSContext currentContext];
            NSString *modulePath = [[NSBundle bundleForClass:[context class]] pathForResource:moduleName ofType:@"js"];
            NSData *moduleFileData = [NSData dataWithContentsOfFile:modulePath];
            NSString *moduleStringContents = [[NSString alloc] initWithData:moduleFileData encoding:NSUTF8StringEncoding];
            if (!moduleStringContents || [moduleStringContents length] == 0) {
                moduleStringContents = [NSString stringWithFormat:@"exports = nativeClassWithName('%@');", moduleName];
            }
            NSString *exportScript = [NSString stringWithFormat:@"(function() { var module = { exports: {}}; var exports = module.exports; %@; return exports; })();", moduleStringContents];
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
        [self evaluateScript:@"_.extend(Object.prototype, EventEmitter.prototype)"];
        
        self[@"Request"] = [RPJSRequests class];
        self[@"JSON"] = [RPJSJSON class];
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

- (JSValue *)evaluateScriptFileWithName:(NSString *)name {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:name ofType:@"js"];
    NSString *scriptContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    if (scriptContents) {
        return [self evaluateScript:scriptContents];
    }
    return nil;
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

