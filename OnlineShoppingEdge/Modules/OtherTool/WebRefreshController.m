//
//  WebRefreshController.m
//  OnlineShoppingEdge
//
//  Created by luting on 20/3/24.
//  Copyright © 2020 luting. All rights reserved.
//

#import "WebRefreshController.h"
@import WebKit;

#define weiboUrl      @"https://www.weibo.com/u/3038116844?is_hot=1"

@interface WebRefreshController ()

@property (nonatomic,strong) WKWebView  * webView ;
@property (nonatomic,assign) NSInteger refreshCount;

@end

@implementation WebRefreshController {
    BOOL _stopWebViewReload;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"网页刷新神器";
    _refreshCount = 0;
    _webView = [[WKWebView alloc]initWithFrame:self.view.bounds
                                 configuration:[[WKWebViewConfiguration alloc]init]];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:weiboUrl]]];
    _webView.frame = CGRectMake(0, 0, self.view.frame.size.width, 100);
    [self.view addSubview:_webView];
    [self reloadWebView];
}

- (void)reloadWebView {
    if(_stopWebViewReload == YES) return ;
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.refreshCount++;
        [weakSelf.webView reload];
        [weakSelf reloadWebView];
    });
}

@end
