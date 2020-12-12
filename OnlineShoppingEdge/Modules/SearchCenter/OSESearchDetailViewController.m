//
//  OSESearchDetailViewController.m
//  OnlineShoppingEdge
//
//  Created by luting on 20/3/27.
//  Copyright © 2020 luting. All rights reserved.
//

#import "OSESearchDetailViewController.h"
#import "UIView+HUD.h"
@import WebKit;

@interface OSESearchDetailViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (strong,nonatomic)WKWebView * webView ;
@property (strong,nonatomic)NSURL  * url ;

@end

@implementation OSESearchDetailViewController

- (instancetype)initWithUrl:(NSURL *)url {
    if (self = [super init]) {
        _url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self openWebWithUrl:_url];
}

- (void)refresh{
    [self.view showHUDAnimated:YES];
    [self.webView reload];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _webView.frame = self.view.frame;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!_webView) {
        _webView = [[WKWebView alloc]initWithFrame:self.view.bounds
                                     configuration:[[WKWebViewConfiguration alloc]init]];
        _webView.navigationDelegate = self;
        _webView.UIDelegate         = self;
        [self.view addSubview:_webView];
    }
}

- (void)openWebWithUrl:(NSURL *)url {
    [self.view showHUDAnimated:YES];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [self.view hideHUDAnimated:YES];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation
      withError:(NSError *)error {
    [self.view hideHUDAnimated:YES];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    [self.view hideHUDAnimated:YES];
    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
