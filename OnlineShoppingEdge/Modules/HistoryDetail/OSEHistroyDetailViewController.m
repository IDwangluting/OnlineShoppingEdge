//
//  OSEHistroyDetailViewController.m
//  OnlineShoppingEdge
//
//  Created by luting on 20/1/11.
//  Copyright © 2020 luting. All rights reserved.
//

#import "OSEHistroyDetailViewController.h"
#import "OSEMutableDictionary.h"
#import "KGRNetworking.h"
#import "TFHpple.h"
#import "CustomActivity.h"
#import "MBProgressHUD.h"
#import "CommonDefine.h"
#import "AppInfoMananger.h"

@import WebKit;

#define offsetY  210 / 375.0 * [UIScreen mainScreen].bounds.size.width

@interface OSEHistroyDetailViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (strong,nonatomic)WKWebView * webView ;

@property (nonnull,strong,nonatomic)NSString * cheakCode;
@property (nonnull,strong,nonatomic)NSMutableArray * historyDataArray;

@end

@implementation OSEHistroyDetailViewController {
    UIButton  * _buyBtn ;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"分享",nil)
                                                              style:UIBarButtonItemStyleDone
                                                             target:self
                                                             action:@selector(share:)];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _webView.frame = self.view.frame;
    CGFloat top = self.navigationController.navigationBar.bottom + 10;
    _buyBtn.frame = CGRectMake(self.view.width - 70, top, 60, 40);
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
    
    if (!_buyBtn) {
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyBtn.layer.cornerRadius = 5;
        _buyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_buyBtn setTitle:@"去购买" forState:UIControlStateNormal];
        [_buyBtn setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
        [_buyBtn setBackgroundColor:UIColor.grayColor];
        [_buyBtn addTarget:self action:@selector(gotoBuy:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_buyBtn];
    }
}

- (void)gotoBuy:(UIButton *)sender {
    NSString * tmp = [_url.absoluteString stringByReplacingOccurrencesOfString:@"vvv" withString:@""];
    NSURL * url = [NSURL URLWithString:tmp];
    if (![[UIApplication sharedApplication] canOpenURL:url]) return ;
    
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:url];
    }
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

- (void)share:(id)sender {
     NSString *text  = @"网购利器--帮你用最低的价格购买心仪的商品";
     UIImage  *image = [UIImage imageNamed:@"AppIcon.png"];
     NSURL    *url   = [NSURL URLWithString:AppInstallUrl];
     NSArray  *activityItems = @[url,text,image];
     CustomActivity * customActivity = [[CustomActivity alloc] initWithTitie:NSLocalizedString([AppInfoMananger manager].appName, nil)
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
    
    if ([activity respondsToSelector:@selector(popoverPresentationController)]) {
        activity.popoverPresentationController.sourceView = self.view;
    }
    [self presentViewController:activity animated:YES completion:nil];
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
