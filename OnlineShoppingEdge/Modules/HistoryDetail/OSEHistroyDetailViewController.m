//
//  OSEHistroyDetailViewController.m
//  OnlineShoppingEdge
//
//  Created by luting on 20/1/11.
//  Copyright © 2020 luting. All rights reserved.
//

#import "OSEHistroyDetailViewController.h"
#import <YYCategories/UIView+YYAdd.h>
@import WebKit;

@interface OSEHistroyDetailViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonnull,strong,nonatomic)WKWebView * webView ;
@property (nonnull,strong,nonatomic)UIButton  * backBtn ;

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
    _backBtn.frame = CGRectMake(self.view.width - 50 - 10, self.view.height - 40 - 15, 50, 40);
}

- (void)layoutSubviews {
    _webView =[[WKWebView alloc]initWithFrame:self.view.bounds
                                      configuration:[[WKWebViewConfiguration alloc]init]];
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    [self.view addSubview:_webView];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
    [_backBtn setImage:[UIImage imageNamed:@"goback"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
}

- (void)appWillEnterForeground {
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    if (![pastboard hasURLs] && [pastboard.string isEqualToString:_url]) return ;
    
    [self dismissViewControllerAnimated:NO completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationWillEnterForegroundNotification object:nil];
    }];
}


- (void)goBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)openWebWithUrl:(NSString *)urlstr {
    NSURL *url =[NSURL URLWithString:urlstr];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

@end
