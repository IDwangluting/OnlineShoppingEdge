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
    _webView = [[WKWebView alloc]initWithFrame:self.view.bounds  configuration:[[WKWebViewConfiguration alloc]init]];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:weiboUrl]]];
    _webView.frame = CGRectMake(0, 0, self.view.frame.size.width, 100);
    [self.view addSubview:_webView];
    
    [self performSelector:@selector(refreshRealTime) withObject:nil afterDelay:3.0];
}

- (void)refreshRealTime {
    if(_stopWebViewReload == YES) return ;
    
    self.refreshCount++;
    [self.webView reload];
    [self performSelector:@selector(refreshRealTime) withObject:nil afterDelay:3.0];
}

- (void)stopRefresh{
    _stopWebViewReload = YES;
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
}

@end
