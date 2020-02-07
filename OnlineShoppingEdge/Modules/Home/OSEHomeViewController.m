//
//  OSEHomeViewController.m
//  OnlineShoppingEdge
//
//  Created by luting on 20/2/3.
//  Copyright © 2020 luting. All rights reserved.
//

#import "OSEHomeViewController.h"
#import "OSETutorialViewController.h"
#import "OSEHistroyDetailViewController.h"
#import <YYCategories/UIGestureRecognizer+YYAdd.h>

//#import <CoreTelephony/CTTelephonyNetworkInfo.h>
//#import <CoreTelephony/CTCarrier.h>

@interface OSEHomeViewController ()<UISearchBarDelegate>

@property (nonatomic,strong)UISearchBar * searchBar;

@end

@implementation OSEHomeViewController {
    NSArray             * _domains;
    NSMutableDictionary * _contentDic;
    OSEHistroyDetailViewController * _histroyDetailViewController;
    OSETutorialViewController * _tutorialViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        [self tryOpenWebWithUrl:[self pastboardUrl]];
    });
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat top =  self.view.height / 4 - 45 + self.navigationController.navigationBar.bottom;
    _searchBar.frame = CGRectMake(45, top , self.view.width - 45 * 2, 45);
}

- (void)layoutSubviews {
    self.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"使用教程"
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(tutorial:)];
    
    _searchBar                   = [[UISearchBar alloc]init];
    _searchBar.searchBarStyle    = UISearchBarStyleProminent;
    _searchBar.barStyle          = UIBarStyleBlack;
    _searchBar.placeholder       = @"请输入网址";
    _searchBar.returnKeyType     = UIReturnKeyDone;
    _searchBar.keyboardType      = UIKeyboardTypeURL;
    _searchBar.scopeButtonTitles = @[];
    _searchBar.tintColor         = UIColor.darkGrayColor;
    _searchBar.layer.cornerRadius= 8;
    _searchBar.clipsToBounds     = YES;
    _searchBar.delegate          = self;
    [self.view addSubview:_searchBar];
}

- (void)commonInit {
    @weakify(self);
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(self);
        [self.view endEditing:YES];
        [self tryOpenWebWithUrl:self.searchBar.text];
    }];
    [self.view addGestureRecognizer:tap];
    _histroyDetailViewController = [[OSEHistroyDetailViewController alloc]init];
    _contentDic = [[NSMutableDictionary alloc]initWithCapacity:4];
    [_contentDic setObject:@{@"platform"       :@"手机天猫",
                             @"historicalPrice":@"https://detail.tmallvvv.com/"}
                    forKey:@"https://detail.tmall.com/"];
    [_contentDic setObject:@{@"platform"       :@"手机天猫",
                             @"historicalPrice":@"http://detail.tmallvvv.com/"}
                    forKey:@"http://detail.tmall.com/"];
    [_contentDic setObject:@{@"platform"       :@"手机天猫",
                            @"historicalPrice":@"https://detail.m.tmallvvv.com/"}
                    forKey:@"https://detail.m.tmall.com/"];
    [_contentDic setObject:@{@"platform"       :@"手机天猫",
                             @"historicalPrice":@"http://detail.m.tmallvvv.com/"}
                    forKey:@"http://detail.m.tmall.com/"];
    
    [_contentDic setObject:@{@"platform"       :@"手机淘宝",
                             @"historicalPrice":@"https://item.taobaovvv.com/"}
                    forKey:@"https://item.taobao.com/"];
    [_contentDic setObject:@{@"platform"       :@"手机淘宝",
                             @"historicalPrice":@"http://item.taobaovvv.com/"}
                    forKey:@"http://item.taobao.com/"];
    [_contentDic setObject:@{@"platform"       :@"手机淘宝",
                             @"historicalPrice":@"https://h5.m.taobaovvv.com/"}
                    forKey:@"https://h5.m.taobao.com/"];
    [_contentDic setObject:@{@"platform"       :@"手机淘宝",
                             @"historicalPrice":@"http://h5.m.taobaovvv.com/"}
                    forKey:@"http://h5.m.taobao.com/"];
    
    [_contentDic setObject:@{@"platform"       :@"京东",
                             @"historicalPrice":@"https://item.jdvvv.com/"}
                    forKey:@"https://item.jd.com/"];
    [_contentDic setObject:@{@"platform"       :@"京东",
                             @"historicalPrice":@"http://item.jdvvv.com/"}
                    forKey:@"http://item.jd.com/"];
    [_contentDic setObject:@{@"platform"       :@"京东",
                             @"historicalPrice":@"https://item.m.jdvvv.com/"}
                    forKey:@"https://item.m.jd.com/"];
    [_contentDic setObject:@{@"platform"       :@"京东",
                             @"historicalPrice":@"http://item.m.jdvvv.com/"}
                    forKey:@"http://item.m.jd.com/"];
    
    [_contentDic setObject:@{@"platform"       :@"亚马逊中国",
                             @"historicalPrice":@"https://www.amazonvvv.cn/"}
                    forKey:@"https://www.amazon.cn/"];
    [_contentDic setObject:@{@"platform"       :@"亚马逊中国",
                             @"historicalPrice":@"http://www.amazonvvv.cn/"}
                    forKey:@"http://www.amazon.cn/"];
    
    [_contentDic setObject:@{@"platform"       :@"当当",
                             @"historicalPrice":@"https://product.dangdangvvv.com/"}
                    forKey:@"https://product.dangdang.com/"];
    [_contentDic setObject:@{@"platform"       :@"当当",
                             @"historicalPrice":@"http://product.dangdangvvv.com/"}
                    forKey:@"http://product.dangdang.com/"];
    
    [_contentDic setObject:@{@"platform"       :@"苏宁易购",
                             @"historicalPrice":@"https://product.suningvvv.com/"}
                    forKey:@"https://product.suning.com/"];
    [_contentDic setObject:@{@"platform"       :@"苏宁易购",
                             @"historicalPrice":@"http://product.suningvvv.com/"}
                    forKey:@"http://product.suning.com/"];
    
    [_contentDic setObject:@{@"platform"       :@"国美",
                             @"historicalPrice":@"https://item.gomevvv.com.cn/"}
                    forKey:@"https://item.gome.com.cn/"];
    [_contentDic setObject:@{@"platform"       :@"国美",
                             @"historicalPrice":@"http://item.gomevvv.com.cn/"}
                    forKey:@"http://item.gome.com.cn/"];
    
    [_contentDic setObject:@{@"platform"       :@"考拉海购",
                            @"historicalPrice":@"https://goods.kaolavvv.com/"}
                      forKey:@"https://goods.kaola.com/"];
    [_contentDic setObject:@{@"platform"       :@"考拉海购",
                             @"historicalPrice":@"http://goods.kaolavvv.com/"}
                    forKey:@"http://goods.kaola.com/"];
    _domains   = _contentDic.allKeys;
}

- (void)tutorial:(UIButton *)sender {
    if (!_tutorialViewController) {
        _tutorialViewController = [[OSETutorialViewController alloc]init];
        _tutorialViewController.title = @"使用教程";
    }
    [self.navigationController pushViewController:_tutorialViewController animated:YES];
}

- (void)enterHistoryDetailWithUrl:(NSString *)url {
    if (url == nil && url.length < 1) return ;
    
    if ([url containsString:@"vvv"]) {
        _searchBar.text = [url stringByReplacingOccurrencesOfString:@"vvv" withString:@""];
    }
    _histroyDetailViewController.url = url;
    [self.navigationController pushViewController:_histroyDetailViewController animated:YES];
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
    
    _searchBar.showsSearchResultsButton = YES;
    _searchBar.searchResultsButtonSelected = openSucess;
}

- (NSString *)pastboardUrl{
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    NSLog(@"---pastboard.string:%@",pastboard.string);
    if (![pastboard hasURLs]) {
        return nil;
    }
    return  pastboard.string;
}

- (void)appWillEnterForegroundNotification {
    NSString * url = [self pastboardUrl];
    UIViewController *viewController = self.navigationController.viewControllers.lastObject;
    if ([viewController isEqual:_histroyDetailViewController]) {
        NSString * tmpUrl = [_histroyDetailViewController.url stringByReplacingOccurrencesOfString:@"vvv" withString:@""];
        if ([tmpUrl isEqualToString:url]) {
            return ;
        }else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }else if (![viewController isEqual:self]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    [self tryOpenWebWithUrl:url];
}

#pragma mark UISearchBarDelegate
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self tryOpenWebWithUrl:searchBar.text];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"] && ![searchBar.text isEqualToString:@"\n"] ){
        [_searchBar endEditing:YES];
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
