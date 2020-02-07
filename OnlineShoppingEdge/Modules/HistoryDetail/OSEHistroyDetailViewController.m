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

@implementation OSEHistroyDetailViewController

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

- (void)openWebWithUrl:(NSString *)urlstr {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *url = [NSURL URLWithString:urlstr];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation
      withError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
