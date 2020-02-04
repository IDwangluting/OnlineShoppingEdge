//
//  OSEResponder.m
//  OnlineShoppingEdge
//
//  Created by luting on 20/2/4.
//  Copyright © 2020 luting. All rights reserved.
//

#import "OSEResponder.h"
#import "OSEHomeViewController.h"

@implementation OSEResponder

- (void)baseSetting {
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.bounds = [UIScreen mainScreen].bounds;
    self.window.rootViewController = [[OSEHomeViewController alloc]init];
    [self.window makeKeyAndVisible];
}

@end
