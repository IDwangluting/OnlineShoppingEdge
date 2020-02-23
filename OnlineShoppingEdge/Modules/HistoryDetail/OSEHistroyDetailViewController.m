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
#import "KGRNetworking.h"
#import "TFHpple.h"

@import WebKit;

#define offsetY  210 / 375.0 * [UIScreen mainScreen].bounds.size.width

@interface OSEHistroyDetailViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonnull,strong,nonatomic)WKWebView * webView ;

@property (nonnull,strong,nonatomic)NSString * cheakCode;
@property (nonnull,strong,nonatomic)NSMutableArray * historyDataArray;

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

- (void)setUrl:(NSURL *)url {
    if ([_url.absoluteString isEqualToString:url.absoluteString])  return ;

    _url = url;
    self.cheakCode = [self searchCheakCodeWithData:[[NSData alloc] initWithContentsOfURL:_url]];
    [self openWebWithUrl:_url];
}

- (void)setCheakCode:(NSString *)cheakCode {
    _cheakCode = cheakCode;
    if (!_cheakCode  || _cheakCode.length < 1) return ;
 
    [self getCodeWithCheckCode:_cheakCode];
}

- (void)setHistoryDataArray:(NSMutableArray *)historyDataArray {
    _historyDataArray = historyDataArray;
}

- (void)dealWithArray:(NSArray *)orignArray {
    NSMutableArray <NSString *>* array = [[NSMutableArray alloc]initWithArray:orignArray];
    for (NSInteger index = array.count -1; index >= 0; index--) {
        if (array[index].length > 50 || array[index].length < 5) {
            [array removeObjectAtIndex:index];
        }
    }
    self.historyDataArray = array;
}

- (void)getCodeWithCheckCode:(NSString *)checkCode {
    @weakify(self);
    NSString * con = [_url.absoluteString stringByReplacingOccurrencesOfString:@"vvv" withString:@""];
    [[KGRNetworking manager]postRequest:@"http://www.amazonvvv.cn/dm/ptinfo.php"
                             parameters:@{@"checkCode":checkCode,@"con":con }
                                success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable result) {
           NSError * error = nil ;
           NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:result
                                                                    options:NSJSONReadingMutableLeaves
                                                                      error:&error];
           if (error || !jsonDict ||![jsonDict.allKeys containsObject:@"code"]) return ;
           
           @strongify(self);
           [self getHistroyDataWithCode:jsonDict[@"code"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {}];
}

- (void)getHistroyDataWithCode:(NSString *)code {
    NSString *url = [NSString stringWithFormat:@"http://212.64.43.245/vv/dm/historynew.php?code=%@&t=",code];
    @weakify(self);
    [[KGRNetworking manager] getRequest:url
                                success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable result) {
        NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@"[]"];
        NSString * str = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        @strongify(self);
        [self dealWithArray:[str componentsSeparatedByCharactersInSet:set]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {}];
}

- (NSString *)searchCheakCodeWithData:(NSData *)data {
    TFHpple *hpple = [[TFHpple alloc]initWithHTMLData:data ];
    TFHppleElement * element = [[hpple searchWithXPathQuery:@"//input[@id='checkCodeId']"] lastObject];
    for (NSString * tmp  in [element.raw componentsSeparatedByString:@" "]) {
        if ([tmp containsString:@"value="]) {
            NSString * str = [tmp stringByReplacingOccurrencesOfString:@"value=\"" withString:@""];
            return [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        }
    }
    return nil;
}

- (NSString *)deleteHtmlChinese:(NSString *)htmlCode {
    NSString * tmpHtmlCode = [htmlCode copy];
    NSUInteger start = 0 , end = 0;
    for (NSUInteger index = tmpHtmlCode.length - 1 ; index > 0; index--) {
        int asc = [tmpHtmlCode characterAtIndex:index];
        if( asc > 0x4e00 && asc < 0x9fff) {
            if (start == 0 && end == 0) {
                end   = index;
                start = index;
            }else if(start - index == 1) {
                start = index;
            }else {
                NSString * tmp = [tmpHtmlCode substringWithRange:NSMakeRange(start, end -start + 2)];
                tmpHtmlCode = [tmpHtmlCode stringByReplacingOccurrencesOfString:tmp withString:@""];
                start = 0;
                end = 0;
            }
        }
    }
    return tmpHtmlCode;
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
