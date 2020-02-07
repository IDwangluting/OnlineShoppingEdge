//
//  OSEBaseViewController.h
//  OnlineShoppingEdge
//
//  Created by luting on 20/2/4.
//  Copyright © 2020 luting. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OSEBaseViewController : UIViewController

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem ;

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem ;

- (void)layoutSubviews;

- (void)appWillEnterForeground ;

- (void)appDidEnterBackground ;

@end

NS_ASSUME_NONNULL_END
