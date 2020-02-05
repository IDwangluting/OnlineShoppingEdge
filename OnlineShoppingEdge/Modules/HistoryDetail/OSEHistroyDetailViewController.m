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
    NSArray  * _domains;
    NSString * _urlString;
    NSMutableDictionary * _contentDic;
}

- (instancetype)initWithUrl:(NSString *)url {
    if (self = [super init]) {
        _contentDic = [[NSMutableDictionary alloc]initWithCapacity:4];
        [_contentDic setObject:@{@"platform"       :@"天猫",
                                 @"historicalPrice":@"http://detail.tmallvvv.com/"}
                        forKey:@"https://detail.tmall.com/"];
        [_contentDic setObject:@{@"platform"       :@"天猫",
                                 @"historicalPrice":@"http://detail.tmallvvv.com/"}
                        forKey:@"http://detail.tmall.com/"];
        [_contentDic setObject:@{@"platform"       :@"天猫",
                                @"historicalPrice":@"http://detail.m.tmallvvv.com/"}
                        forKey:@"https://detail.m.tmall.com/"];
        [_contentDic setObject:@{@"platform"       :@"天猫",
                                 @"historicalPrice":@"http://detail.m.tmallvvv.com/"}
                        forKey:@"http://detail.m.tmall.com/"];
        
        [_contentDic setObject:@{@"platform"       :@"淘宝",
                                 @"historicalPrice":@"http://item.taobaovvv.com/"}
                        forKey:@"https://item.taobao.com/"];
        [_contentDic setObject:@{@"platform"       :@"淘宝",
                                 @"historicalPrice":@"http://item.taobaovvv.com/"}
                        forKey:@"http://item.taobao.com/"];
        [_contentDic setObject:@{@"platform"       :@"淘宝",
                                 @"historicalPrice":@"http://h5.m.taobaovvv.com/"}
                        forKey:@"https://h5.m.taobao.com/"];
        [_contentDic setObject:@{@"platform"       :@"淘宝",
                                 @"historicalPrice":@"http://h5.m.taobaovvv.com/"}
                        forKey:@"http://h5.m.taobao.com/"];
        
        [_contentDic setObject:@{@"platform"       :@"京东",
                                 @"historicalPrice":@"http://item.jdvvv.com/"}
                        forKey:@"https://item.jd.com/"];
        [_contentDic setObject:@{@"platform"       :@"京东",
                                 @"historicalPrice":@"http://item.jdvvv.com/"}
                        forKey:@"http://item.jd.com/"];
        [_contentDic setObject:@{@"platform"       :@"京东",
                                 @"historicalPrice":@"http://item.m.jdvvv.com/"}
                        forKey:@"https://item.m.jd.com/"];
        [_contentDic setObject:@{@"platform"       :@"京东",
                                 @"historicalPrice":@"http://item.m.jdvvv.com/"}
                        forKey:@"http://item.m.jd.com/"];
        
        [_contentDic setObject:@{@"platform"       :@"亚马逊",
                                 @"historicalPrice":@"https://www.amazonvvv.cn/"}
                        forKey:@"https://www.amazon.cn/"];
        [_contentDic setObject:@{@"platform"       :@"亚马逊",
                                 @"historicalPrice":@"http://www.amazonvvv.cn/"}
                        forKey:@"http://www.amazon.cn/"];
        
        [_contentDic setObject:@{@"platform"       :@"当当",
                                 @"historicalPrice":@"http://product.dangdangvvv.com/"}
                        forKey:@"https://product.dangdang.com/"];
        [_contentDic setObject:@{@"platform"       :@"当当",
                                 @"historicalPrice":@"http://product.dangdangvvv.com/"}
                        forKey:@"http://product.dangdang.com/"];
        
        [_contentDic setObject:@{@"platform"       :@"苏宁易购",
                                 @"historicalPrice":@"http://product.suningvvv.com/"}
                        forKey:@"https://product.suning.com/"];
        [_contentDic setObject:@{@"platform"       :@"苏宁易购",
                                 @"historicalPrice":@"http://product.suningvvv.com/"}
                        forKey:@"http://product.suning.com/"];
        
        [_contentDic setObject:@{@"platform"       :@"国美",
                                 @"historicalPrice":@"http://item.gomevvv.com.cn/"}
                        forKey:@"https://item.gome.com.cn/"];
        [_contentDic setObject:@{@"platform"       :@"国美",
                                 @"historicalPrice":@"http://item.gomevvv.com.cn/"}
                        forKey:@"http://item.gome.com.cn/"];
        
        [_contentDic setObject:@{@"platform"       :@"网易考拉",
                                @"historicalPrice":@"http://goods.kaolavvv.com/"}
                          forKey:@"https://goods.kaola.com/"];
        [_contentDic setObject:@{@"platform"       :@"网易考拉",
                                 @"historicalPrice":@"http://goods.kaolavvv.com/"}
                        forKey:@"http://goods.kaola.com/"];
        _domains   = _contentDic.allKeys;
        _urlString = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self webView];
    [self backBtn];
    [self tryOpenWebWithUrl:_urlString];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _webView.frame = self.view.frame;
    _backBtn.frame = CGRectMake(self.view.width - 50 - 10, self.view.height - 40 - 15, 50, 40);
}

- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
        _webView =[[WKWebView alloc]initWithFrame:self.view.bounds configuration:configuration];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed:@"goback"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backBtn];
    }
    return _backBtn;
}

- (void)goBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tryOpenWebWithUrl:(NSString *)url {
    // 处理重定向问题
    NSMutableCharacterSet *set  = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [set addCharactersInString:@"#"];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:set];
  
    BOOL openSucess = false ;
    for (NSString *currentDomain  in _domains){
        if ([url containsString:currentDomain]) {
            NSString * historicalPrice = [[_contentDic objectForKey:currentDomain] objectForKey:@"historicalPrice"];
            url = [url stringByReplacingOccurrencesOfString:currentDomain withString:historicalPrice];
            [self openWebWithUrl:url];
            openSucess = YES;
            break ;
        }
    }
    
    if (openSucess) {
        
    }
}

- (void)openWebWithUrl:(NSString *)urlstr {
    NSURL *url =[NSURL URLWithString:urlstr];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

@end
