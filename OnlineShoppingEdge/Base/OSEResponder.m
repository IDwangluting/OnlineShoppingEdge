//
//  OSEResponder.m
//  OnlineShoppingEdge
//
//  Created by luting on 20/2/4.
//  Copyright © 2020 luting. All rights reserved.
//

#import "OSEResponder.h"
#import "OSEHomeViewController.h"
#import "OSESlideMenuController.h"
#import "OSELeftMenuController.h"

@implementation OSEResponder

- (void)baseSetting {
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.bounds = [UIScreen mainScreen].bounds;
    OSEHomeViewController * viewController = [[OSEHomeViewController alloc]init];
    [viewController setTitle:NSLocalizedString(@"首页", nil)];
    UIViewController * nav = [[UINavigationController alloc]initWithRootViewController:viewController];
    
    OSELeftMenuController  *slideMenuViewController = [[OSELeftMenuController alloc] init];
    OSESlideMenuController *sideMenuController = [[OSESlideMenuController alloc] initWithHomePage:nav
                                                                    slideMenuViewController:slideMenuViewController];
    sideMenuController.scaleContent = NO;
    self.window.rootViewController = sideMenuController;

    [self.window makeKeyAndVisible];
    
    [UINavigationBar appearance].titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],
                                                         NSForegroundColorAttributeName:UIColor.blackColor};
    [UITableViewCell appearance].backgroundColor     = UIColor.whiteColor ;
    //    [UINavigationBar appearance].translucent     = false ;
    //    [UINavigationBar appearance].barStyle        = UIBarStyleDefault  ;
    //    [UINavigationBar appearance].barTintColor    = UIColor.whiteColor ;
}

@end
