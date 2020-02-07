//
//  OSETutorialViewController.m
//  OnlineShoppingEdge
//
//  Created by luting on 20/2/7.
//  Copyright © 2020 luting. All rights reserved.
//

#import "OSETutorialViewController.h"

@interface OSETutorialViewController ()

@end

@implementation OSETutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:false animated:false];
    self.title = @"使用教程";
    self.view.backgroundColor = UIColor.redColor;
}

- (void)appWillEnterForeground {
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    if (![pastboard hasURLs]) return ;
    
    [self.navigationController popViewControllerAnimated:false];
    dispatch_block_t action = ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationWillEnterForegroundNotification object:nil];
    };
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(),
                   action);
}

@end
