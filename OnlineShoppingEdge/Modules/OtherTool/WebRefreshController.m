//
//  WebRefreshController.m
//  OnlineShoppingEdge
//
//  Created by luting on 20/3/24.
//  Copyright © 2020 luting. All rights reserved.
//

#import "WebRefreshController.h"
@import WebKit;

#define weiboUrl  @"https://www.weibo.com/u/3038116844?is_hot=1"

@interface WebRefreshController ()

@property (nonatomic,strong) WKWebView  * webView ;

@end

@implementation WebRefreshController

- (instancetype)initWithUrl:(NSString * _Nonnull )url {
    if (self = [super init]) {
        self.url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"网页刷新神器";
    [self webView];
    _refreshTimespan = 3.0f;
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc]initWithFrame:self.view.bounds  configuration:[[WKWebViewConfiguration alloc]init]];
        _webView.frame = CGRectMake(0, 0, self.view.frame.size.width, 100);
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (void)setUrl:(NSString *)url {
    _url = url;
    if (_url.length < 1) {
        [self stopRefresh];
        return ;
    }
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
}

- (void)refresh {
    [self.webView reload];
    [self performSelector:@selector(refresh) withObject:nil afterDelay:_refreshTimespan];
}

- (void)stopRefresh {
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
}

- (void)dealloc {
    [self stopRefresh];
}

@end
