//
//  OSEHistroyDetailViewController.m
//  OnlineShoppingEdge
//
//  Created by luting on 20/1/11.
//  Copyright © 2020 luting. All rights reserved.
//

#import "OSEHistroyDetailViewController.h"
#import "OSEMutableDictionary.h"
#import "CustomActivity.h"
#import "MBProgressHUD.h"
@import WebKit;

#define offsetY  210 / 375.0 * [UIScreen mainScreen].bounds.size.width

@interface OSEHistroyDetailViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonnull,strong,nonatomic)WKWebView * webView ;

@end

@implementation OSEHistroyDetailViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"分享"
                                                              style:UIBarButtonItemStyleDone
                                                             target:self
                                                             action:@selector(share:)];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _webView.frame = self.view.frame;
}

- (void)setUrl:(NSURL *)url {
    if ([_url.absoluteString isEqualToString:url.absoluteString])  return ;
    
    _url = url;
    [self openWebWithUrl:_url];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.view addSubview:self.webView];
}

- (void)share:(id)sender {
     NSString *text  = @"网购利器--帮你用最低的价格购买心仪的商品";
     UIImage  *image = [UIImage imageNamed:@"AppIcon.png"];
     NSURL    *url   = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1497669870?mt=8"];
     NSArray  *activityItems = @[url,text,image];
     CustomActivity * customActivity = [[CustomActivity alloc] initWithTitie:@"网购利器"
                                                                       image:image
                                                                         url:url
                                                                        type:@"CustomActivity"
                                                                     context:activityItems];
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                                           applicationActivities:@[customActivity]];
    activity.excludedActivityTypes = @[];
    activity.completionWithItemsHandler = ^(NSString *activityType ,BOOL completed,
                                            NSArray  *returnedItems,NSError *activityError) {
        if (completed){

        }else{
//            activityError
        }
    };
    
    if ([activity respondsToSelector:@selector(popoverPresentationController)]) {        activity.popoverPresentationController.sourceView = self.view;
    }
    [self presentViewController:activity animated:YES completion:nil];
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

- (void)openWebWithUrl:(NSURL *)url {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (![[OSEMutableDictionary  allKeys] containsObject:[_url.host stringByReplacingOccurrencesOfString:@"vvv" withString:@""]]) return ;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [webView.scrollView setContentOffset:CGPointMake(0, offsetY) animated:YES] ;
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
        _url = URL;
        self.title = [[[OSEMutableDictionary contentData] objectForKey:URL.host] objectForKey:PlatformName];
        [self.webView loadRequest:[NSURLRequest requestWithURL:URL]];
        return ;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
    if ([URL.absoluteString containsString:@"http"]) {
        NSLog(@"url: %@",URL.absoluteString);
    }
}

@end
