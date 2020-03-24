//
//  OSEBaseViewController.m
//  OnlineShoppingEdge
//
//  Created by luting on 20/2/4.
//  Copyright © 2020 luting. All rights reserved.
//

#import "OSEBaseViewController.h"

@implementation OSEBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = UIColor.whiteColor;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForegroundNotification)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackgroundNotification)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [self layoutSubviews];
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem {
    self.navigationController.navigationBar.topItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem {
    self.navigationController.navigationBar.topItem.leftBarButtonItem  = leftBarButtonItem;
}

- (void)layoutSubviews {}

- (void)appWillEnterForegroundNotification {}

- (void)appDidEnterBackgroundNotification {
    [self.view endEditing:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return false;
}

@end
