//
//  UIView+HUD.h
//  OnlineShoppingEdge
//
//  Created by luting on 20/12/12.
//  Copyright © 2020 luting. All rights reserved.
//

@import UIKit;
#import <Toast/Toast.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (HUD)

- (void)showHUDAnimated:(BOOL)animated;

- (void)hideHUDAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
