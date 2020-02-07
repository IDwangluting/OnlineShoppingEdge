//
//  OSEHistroyDetailViewController.m
//  OnlineShoppingEdge
//
//  Created by luting on 20/1/11.
//  Copyright © 2020 luting. All rights reserved.
//

#import "OSEHistroyDetailViewController.h"
#import <YYCategories/UIView+YYAdd.h>
#import "MBProgressHUD.h"
@import WebKit;

@interface OSEHistroyDetailViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonnull,strong,nonatomic)WKWebView * webView ;

@end

@implementation OSEHistroyDetailViewController {
    NSString * _url;
}

- (instancetype)initWithUrl:(NSString *)urlString {
    if (self = [super init]) {
        _url = urlString;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubviews];
    [self openWebWithUrl:_url];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _webView.frame = self.view.frame;
}

- (void)layoutSubviews {
    _webView =[[WKWebView alloc]initWithFrame:self.view.bounds
                                      configuration:[[WKWebViewConfiguration alloc]init]];
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    [self.view addSubview:_webView];
}

- (void)appWillEnterForeground {
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    if (![pastboard hasURLs] && [pastboard.string isEqualToString:_url]) return ;
    
    [self dismissViewControllerAnimated:NO completion:nil];
    dispatch_block_t notificationBlock = ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationWillEnterForegroundNotification object:nil];
    };
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(),
                   notificationBlock);
}

- (void)openWebWithUrl:(NSString *)urlstr {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *url = [NSURL URLWithString:urlstr];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
