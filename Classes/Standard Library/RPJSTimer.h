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

- (void)evaluateFunction:(JSValue *)function delay:(NSTimeInterval)delay repeats:(BOOL)repeats arguments:(NSArray *)arguments;
- (void)invalidateAllTimers;

@end
