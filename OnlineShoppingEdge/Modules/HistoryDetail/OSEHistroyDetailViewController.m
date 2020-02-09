//
//  OSEHistroyDetailViewController.m
//  OnlineShoppingEdge
//
//  Created by luting on 20/1/11.
//  Copyright © 2020 luting. All rights reserved.
//

#import "OSEHistroyDetailViewController.h"
#import "MBProgressHUD.h"
#import "OSEMutableDictionary.h"
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
    if ([_url isEqualToString:url])  return ;
    if (_url) [self openWebWithUrl:@""];
    
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat navigationBarBottom = self.navigationController.navigationBar.bottom;
        CGFloat y = (self.view.height - navigationBarBottom) * 0.35;
        [webView.scrollView setContentOffset:CGPointMake(0, y) animated:YES];// iphonex
    });
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation
      withError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL * URL = navigationAction.request.URL;
    if ([[OSEMutableDictionary  allKeys] containsObject:URL.host] && [self.title containsString:@"http"]) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
        NSString * url = [OSEMutableDictionary histroyDeatailUrl:URL.absoluteString];
        self.title = [[[OSEMutableDictionary contentData] objectForKey:URL.host] objectForKey:PlatformName];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        return ;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
    if ([URL.absoluteString containsString:@"http"]) {
        NSLog(@"url: %@",URL.absoluteString);
    }
}

@end
