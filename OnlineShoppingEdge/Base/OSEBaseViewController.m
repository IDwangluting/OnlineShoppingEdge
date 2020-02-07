//
//  OSEBaseViewController.m
//  OnlineShoppingEdge
//
//  Created by luting on 20/2/4.
//  Copyright © 2020 luting. All rights reserved.
//

#import "OSEBaseViewController.h"

@implementation OSEBaseViewController

- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [self layoutSubviews];
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem {
    self.navigationController.navigationBar.topItem.rightBarButtonItem  = rightBarButtonItem;
}

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem {
    self.navigationController.navigationBar.topItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)layoutSubviews {}

- (void)appWillEnterForeground {}

- (void)appDidEnterBackground {
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
