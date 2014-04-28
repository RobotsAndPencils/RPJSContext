//
//  RPJSTimer.h
//  RPJSContext
//
//  Created by Brandon Evans on 2014-04-24.
//  Copyright (c) 2014 Robots and Pencils. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

@protocol PCContextSetTimeoutExport <JSExport>

JSExportAs(evaluateFunctionWithDelay,
- (void)evaluateFunction:(JSValue *)function delay:(NSTimeInterval)delay repeats:(BOOL)repeats arguments:(NSArray *)arguments
);

@end

@interface RPJSTimer : NSObject <PCContextSetTimeoutExport>

/**
 *  Calls a JS function after a delay
 *
 *  @param function  The JS function to call
 *  @param delay     The delay in seconds before calling the function
 *  @param repeats   Whether the function should be called repeatedly
 *  @param arguments An array of arguments to be passed to the function when it's called
 */
- (void)evaluateFunction:(JSValue *)function delay:(NSTimeInterval)delay repeats:(BOOL)repeats arguments:(NSArray *)arguments;

/**
 *  Invalidates all timers that have been called.
 */
- (void)invalidateAllTimers;

@end
