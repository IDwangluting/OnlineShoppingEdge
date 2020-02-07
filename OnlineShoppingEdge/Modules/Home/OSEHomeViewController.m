//
//  OSEHomeViewController.m
//  OnlineShoppingEdge
//
//  Created by luting on 20/2/3.
//  Copyright © 2020 luting. All rights reserved.
//

//    NSString * urlString = @"http://item.jd.com/40395526489.html";
//    NSString * urlString = @"http://detail.tmall.com/item.htm?id=601565277987";
//    NSString * urlString = @"http://product.dangdang.com/28502447.html#ddclick_reco_book";
//    NSString * urlString = @"https://item.gome.com.cn/9140127528-1130660112.html?intcmp=box20-v3-1_2_0a70ae2520011113081126&frm=bigd";
//    NSString * urlString = @"https://item.taobao.com/item.htm?id=522020554602&ali_refid=a3_420435_1006:1102185729:N:8jeuVnatBzSHv0A7PH5qZA%3D%3D:10d87f1e56e49e04234f581a25de91c2&ali_trackid=1_10d87f1e56e49e04234f581a25de91c2&spm=a230r.1.1989828.22";
//
//    NSString * urlString = @"https://www.amazon.cn/gp/product/B00MCW8R1S/ref=cn_ags_s9_asin_1403206071_merchandised-search-3?pf_rd_p=33e63d50-addd-4d44-a917-c9479c457e1a&pf_rd_s=merchandised-search-3&pf_rd_t=101&pf_rd_i=1403206071&pf_rd_m=A1AJ19PSB66TGU&pf_rd_r=F6HR5G81QGBKVX14T9CM&pf_rd_r=F6HR5G81QGBKVX14T9CM&pf_rd_p=33e63d50-addd-4d44-a917-c9479c457e1a";
        
//     NSString * urlString = @"https://product.suning.com/0070067092/000000000128763302.html?srcPoint=index3_none_recscnxhB_1-7_p_0070067092_000000000128763302_rec_6-1_0_A&src=index3_none_recscnxhB_1-7_p_0070067092_000000000128763302_rec_6-1_0_A&safp=d488778a.homepage1.99347413133.13&safc=prd.1.rec_6-1_0_A";

#import "OSEHomeViewController.h"
#import "OSETutorialViewController.h"
#import "OSEHistroyDetailViewController.h"
#import <YYCategories/UIView+YYAdd.h>

//#import <CoreTelephony/CTTelephonyNetworkInfo.h>
//#import <CoreTelephony/CTCarrier.h>

@interface OSEHomeViewController ()<UISearchBarDelegate>

@property (strong,nonatomic)UISearchBar * searchBar;
@property (strong,nonatomic)UIButton    * tutorialBtn;

@end

@implementation OSEHomeViewController {
    NSArray             * _domains;
    NSMutableDictionary * _contentDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
    self.title = @"首页";
    __weak typeof(self)  weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf)  strongSelf = weakSelf;
        [strongSelf tryOpenWebWithUrl:[strongSelf pastboardUrl]];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _searchBar.frame   = CGRectMake(45, self.view.height / 4 - 45,
                                  self.view.width - 45 * 2, 45);
    _tutorialBtn.frame = CGRectMake(self.view.width  - 90 , 30 , 80 , 44);
}

- (void)layoutSubviews {
    _searchBar                   = [[UISearchBar alloc]init];
    _searchBar.searchBarStyle    = UISearchBarStyleProminent;
    _searchBar.barStyle          = UIBarStyleBlack;
    _searchBar.placeholder       = @"请输入网址";
    _searchBar.returnKeyType     = UIReturnKeyDone;
    _searchBar.keyboardType      = UIKeyboardTypeURL;
    _searchBar.scopeButtonTitles = @[];
    _searchBar.tintColor         = UIColor.brownColor;
    _searchBar.barTintColor      = UIColor.darkGrayColor;
    _searchBar.layer.cornerRadius= 8;
    _searchBar.clipsToBounds     = YES;
    _searchBar.delegate          = self;
    [self.view addSubview:_searchBar];
    
    _tutorialBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [_tutorialBtn setTitleColor:UIColor.darkGrayColor forState:UIControlStateNormal];
    [_tutorialBtn setTitle       :@"使用教程" forState:UIControlStateNormal];
    [_tutorialBtn addTarget      :self action:@selector(tutorial:) forControlEvents:UIControlEventTouchUpInside];
    _tutorialBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.view addSubview        :_tutorialBtn];
}

- (void)commonInit {
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
}

- (void)tutorial:(UIButton *)sender {
    [self.navigationController pushViewController:[[OSETutorialViewController alloc]init] animated:YES];
}

- (void)enterHistoryDetailWithUrl:(NSString *)url {
    if (url == nil && url.length < 1) return ;
    
    if ([url containsString:@"vvv"]) {
        _searchBar.text = [url stringByReplacingOccurrencesOfString:@"vvv" withString:@""];
    }
    OSEHistroyDetailViewController * vc= [[OSEHistroyDetailViewController alloc]initWithUrl:url];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)tryOpenWebWithUrl:(NSString *)url {
    // 处理重定向问题
    NSMutableCharacterSet *set  = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [set addCharactersInString:@"#"];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:set];
    BOOL openSucess = false ;
    
    if ([url containsString:@"vvv"]) {
        [self enterHistoryDetailWithUrl:url];
        openSucess = YES;
    }
    for (NSString *currentDomain  in _domains){
        if ([url containsString:currentDomain]) {
            NSString * historicalPrice = [[_contentDic objectForKey:currentDomain] objectForKey:@"historicalPrice"];
            url = [url stringByReplacingOccurrencesOfString:currentDomain withString:historicalPrice];
            [self enterHistoryDetailWithUrl:url];
            openSucess = YES;
            break ;
        }
    }
    
    self.searchBar.showsSearchResultsButton = YES;
    self.searchBar.searchResultsButtonSelected = openSucess;
}

- (NSString *)pastboardUrl{
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    NSLog(@"---pastboard.string:%@",pastboard.string);
    if (![pastboard hasURLs]) {
        return nil;
    }
    return  pastboard.string;
}

- (void)appWillEnterForeground {
    [self tryOpenWebWithUrl:[self pastboardUrl]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark UISearchBarDelegate
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self tryOpenWebWithUrl:searchBar.text];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"] && ![searchBar.text isEqualToString:@"\n"] ){
        [self tryOpenWebWithUrl:searchBar.text];
        return NO;
    }
    return YES;
}

//- (void)simCardInfo {
//    CTTelephonyNetworkInfo *  networkInfo = [[CTTelephonyNetworkInfo alloc] init];
//    CTCarrier *carrier = networkInfo.subscriberCellularProvider;
//    carrier.carrierName;//供应商名称（中国联通 中国移动）
//    carrier.mobileCountryCode; //所在国家编号
//    carrier.mobileNetworkCode; //供应商网络编号
//    carrier.allowsVOIP?@ "YES" :@ "NO";
//    carrier.isoCountryCode;
//    NSString *number = [[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"];
//    UITextContentTypeOneTimeCode
//}
@end
