//
//  AppDelegate.m
//  Sample
//
//  Created by Ignacio Romero Z. on 1/26/15.
//  Copyright (c) 2015 DZN Labs. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"%s",__FUNCTION__);
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    return YES;
}

@end
