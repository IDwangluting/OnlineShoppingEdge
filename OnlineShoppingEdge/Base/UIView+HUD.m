//
//  UIView+HUD.m
//  OnlineShoppingEdge
//
//  Created by luting on 20/12/12.
//  Copyright © 2020 luting. All rights reserved.
//

#import "UIView+Toast.h"
#import "MBProgressHUD.h"

@implementation UIView (HUD)

- (void)showHUDAnimated:(BOOL)animated {
    [MBProgressHUD showHUDAddedTo:self animated:YES];
}

- (void)hideHUDAnimated:(BOOL)animated {
    [MBProgressHUD hideHUDForView:self animated:YES];
}

@end
