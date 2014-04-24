//
//  RPJSMath.h
//  RPJSContext
//
//  Created by Brandon Evans on 2014-04-24.
//  Copyright (c) 2014 Robots and Pencils. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

@protocol PCContextMathExport <JSExport>

+ (CGFloat)random;

@end

@interface RPJSMath : NSObject <PCContextMathExport>

+ (CGFloat)random;

@end
