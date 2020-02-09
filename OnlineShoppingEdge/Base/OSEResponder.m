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
    OSEHomeViewController * rootViewController  = [[OSEHomeViewController alloc]init];
    [rootViewController setTitle:@"首页"];
    UIViewController * navigationController = [[UINavigationController alloc]initWithRootViewController:rootViewController];
    self.window.rootViewController = navigationController ;
    [self.window makeKeyAndVisible];
    
    [UINavigationBar appearance].titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],
                                                         NSForegroundColorAttributeName:UIColor.blackColor};
    [UITableViewCell appearance].backgroundColor     = UIColor.whiteColor ;
    //    [UINavigationBar appearance].translucent     = false ;
    //    [UINavigationBar appearance].barStyle        = UIBarStyleDefault  ;
    //    [UINavigationBar appearance].barTintColor    = UIColor.whiteColor ;
}

@end
