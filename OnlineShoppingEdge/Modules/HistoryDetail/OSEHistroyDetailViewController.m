//
//  OSEHistroyDetailViewController.m
//  OnlineShoppingEdge
//
//  Created by luting on 20/1/11.
//  Copyright © 2020 luting. All rights reserved.
//

#import "OSEHistroyDetailViewController.h"
#import "MBProgressHUD.h"
@import WebKit;

@interface OSEHistroyDetailViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonnull,strong,nonatomic)WKWebView * webView ;

@end

@implementation OSEHistroyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _webView.frame = self.view.frame;
}

- (void)setUrl:(NSString *)url {
    _url = url;
    [self openWebWithUrl:_url];
}

- (void)layoutSubviews {
    [self.view addSubview:self.webView];
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc]initWithFrame:self.view.bounds
                                     configuration:[[WKWebViewConfiguration alloc]init]];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
    }
    return _webView;
}

- (void)openWebWithUrl:(NSString *)url {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
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
