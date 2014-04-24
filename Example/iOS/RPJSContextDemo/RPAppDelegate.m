//
//  RPAppDelegate.m
//  RPJSContextDemo
//
//  Created by Brandon Evans on 2014-04-24.
//  Copyright (c) 2014 Robots and Pencils. All rights reserved.
//

#import "RPAppDelegate.h"

#import "RPJSContext.h"

@interface RPAppDelegate ()

@property (nonatomic, strong) RPJSContext *context;

@end

@implementation RPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.context = [[RPJSContext alloc] init];
    
    return YES;
}

@end
