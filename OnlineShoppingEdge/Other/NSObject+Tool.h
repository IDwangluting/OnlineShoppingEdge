//
//  NSObject+Tool.h
//  OnlineShoppingEdge
//
//  Created by luting on 20/3/27.
//  Copyright © 2020 luting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <Toast/Toast.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Tool)

- (void)openURL:(NSString *)urlStr;

@end

@interface UIViewController (Tool)

- (void)checkUpdate;

@end

NS_ASSUME_NONNULL_END
