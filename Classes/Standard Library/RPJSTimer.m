//
//  RPJSTimer.m
//  RPJSContext
//
//  Created by Brandon Evans on 2014-04-24.
//  Copyright (c) 2014 Robots and Pencils. All rights reserved.
//

#import "RPJSTimer.h"

static NSString *const RPJSContextSetTimeoutBlockKey = @"RPJSContextSetTimeoutBlockKey";
static NSString *const RPJSContextSetTimeoutArgumentsKey = @"RPJSContextSetTimeoutArgumentsKey";

@interface RPJSTimer ()

@property (strong, nonatomic) NSMutableArray *timers;

@end

@implementation RPJSTimer

- (instancetype)init {
    self = [super init];
    if (self) {
        self.timers = [NSMutableArray array];
    }
    return self;
}

- (void)evaluateFunction:(JSValue *)function delay:(NSTimeInterval)delay repeats:(BOOL)repeats arguments:(NSArray *)arguments {
    if (!arguments) arguments = @[];
    
    // Create a garbage collected reference that the VM knows about
    JSManagedValue *managedFunctionReference = [JSManagedValue managedValueWithValue:function];
    [function.context.virtualMachine addManagedReference:managedFunctionReference withOwner:self];
    
    NSDictionary *userInfo = @{ RPJSContextSetTimeoutBlockKey : managedFunctionReference, RPJSContextSetTimeoutArgumentsKey : arguments };
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(executeBlockFromTimer:) userInfo:userInfo repeats:repeats];
    [self.timers addObject:timer];
}

- (void)invalidateAllTimers {
    [self.timers makeObjectsPerformSelector:@selector(invalidate)];
    [self.timers removeAllObjects];
}

- (void)executeBlockFromTimer:(NSTimer *)aTimer {
	JSManagedValue *function = aTimer.userInfo[RPJSContextSetTimeoutBlockKey];
    NSArray *arguments = aTimer.userInfo[RPJSContextSetTimeoutArgumentsKey];
    [[function value] callWithArguments:arguments];
}

@end

