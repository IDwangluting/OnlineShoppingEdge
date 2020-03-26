//
//  NSObject+Tool.m
//  OnlineShoppingEdge
//
//  Created by luting on 20/3/27.
//  Copyright © 2020 luting. All rights reserved.
//

#import "NSObject+Tool.h"
#import "CommonDefine.h"
#import "AppInfoMananger.h"
#import <StoreKit/StoreKit.h>
@import UIKit;

@implementation NSObject (Tool)

- (void)openURL:(NSString *)urlStr {
    NSURL * url = [NSURL URLWithString:urlStr];
    if(![[UIApplication sharedApplication] canOpenURL:url]) return ;
        
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        return ;
    }
    [[UIApplication sharedApplication] openURL:url];
}

@end

@implementation UIViewController (Tool)

- (void)checkUpdate {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self ;
    void (^UpdataTip)(NSString *tips) = ^(NSString * tips){
        [weakSelf.view makeToast:tips
                        duration:2.0
                        position:CSToastPositionTop];
    };
    NSError *error;
    NSDictionary *appInfo = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:AppInfoUrl]]
                                                            options:NSJSONReadingAllowFragments
                                                              error:&error];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (error){
        UpdataTip(@"更新出错");
        return ;
    }

    NSArray *infoContent = [appInfo objectForKey:@"results"];
    NSString * version   = [[infoContent objectAtIndex:0]objectForKey:@"version"];
    if (version && [version isEqualToString:[AppInfoMananger manager].version]) {
        UpdataTip(@"不需要更新");
        return ;
    }
    [self openURL:AppInstallUrl];
}


- (void)recommandInstallAppWithId:(NSString *)appId {
    if (@available(iOS 10.3, *)) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        __block SKStoreProductViewController *productViewController = [[SKStoreProductViewController alloc] init];
        id<SKStoreProductViewControllerDelegate> delegate = (id)self;
        productViewController.delegate = delegate;
        __weak typeof(self) weakSelf = self ;
        [productViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:appId}
                                         completionBlock:^(BOOL result, NSError *error) {
            [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
            if (result == false || error) return ;
            
            [weakSelf presentViewController:productViewController animated:YES completion:nil];
        }];
    }
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
