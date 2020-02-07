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
#define baiduSearch @"https://m.baidu.com/s?from=1000539d&word="

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
    _searchBar.placeholder       = @"请输入搜索内容";
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
        if (self.searchBar.searchTextField.editing == NO) {
            [self tryOpenWebWithUrl:self.searchBar.text];
        }
        [self.view endEditing:YES];
    }];
    [self.view addGestureRecognizer:tap];
    _contentDic = [[NSMutableDictionary alloc]initWithCapacity:4];
    [_contentDic setObject:@{@"platform"       :@"天猫",
                             @"historicalPrice":@"detail.tmallvvv.com"}
                    forKey:@"detail.tmall.com"];
    [_contentDic setObject:@{@"platform"       :@"天猫",
                            @"historicalPrice":@"detail.m.tmallvvv.com"}
                    forKey:@"detail.m.tmall.com"];
    
    //这种暂时处理不了
    [_contentDic setObject:@{@"platform"       :@"天猫",
                             @"historicalPrice":@"m.tb.cn"}
                       forKey:@"m.tb.cn"];
    
    [_contentDic setObject:@{@"platform"       :@"淘宝",
                             @"historicalPrice":@"item.taobaovvv.com"}
                    forKey:@"item.taobao.com"];
    [_contentDic setObject:@{@"platform"       :@"淘宝",
                             @"historicalPrice":@"h5.m.taobaovvv.com"}
                    forKey:@"h5.m.taobao.com"];
    
    [_contentDic setObject:@{@"platform"       :@"京东",
                             @"historicalPrice":@"item.jdvvv.com"}
                    forKey:@"item.jd.com"];
    [_contentDic setObject:@{@"platform"       :@"京东",
                             @"historicalPrice":@"item.m.jdvvv.com"}
                    forKey:@"item.m.jd.com"];
    
    [_contentDic setObject:@{@"platform"       :@"亚马逊",
                             @"historicalPrice":@"www.amazonvvv.cn"}
                    forKey:@"www.amazon.cn"];
    
    [_contentDic setObject:@{@"platform"       :@"当当",
                             @"historicalPrice":@"product.dangdangvvv.com"}
                    forKey:@"product.dangdang.com"];
    
    [_contentDic setObject:@{@"platform"       :@"当当",
                             @"historicalPrice":@"product.dangdangvvv.com"}
                       forKey:@"product.m.dangdang.com"];
    
    [_contentDic setObject:@{@"platform"       :@"苏宁易购",
                             @"historicalPrice":@"product.suningvvv.com"}
                    forKey:@"product.suning.com"];
    
    [_contentDic setObject:@{@"platform"       :@"国美",
                             @"historicalPrice":@"item.gomevvv.com.cn"}
                    forKey:@"item.gome.com.cn"];
    
    [_contentDic setObject:@{@"platform"       :@"考拉海购",
                             @"historicalPrice":@"goods.kaolavvv.com"}
                      forKey:@"goods.kaola.com"];
    [_contentDic setObject:@{@"platform"       :@"考拉海购",
                             @"historicalPrice":@"goods.kaolavvv.com"}
                      forKey:@"m-goods.kaola.com"];
    
    _domains   = _contentDic.allKeys;
}

- (void)tutorial:(UIButton *)sender {
    if (!_tutorialViewController) {
        _tutorialViewController = [[OSETutorialViewController alloc]init];
        _tutorialViewController.title = @"使用教程";
    }
    [self.navigationController pushViewController:_tutorialViewController animated:YES];
}

- (void)enterHistoryDetailWithTitle:(NSString *)title url:(NSString *)url {
    if (url == nil && url.length < 1) return ;
    
    if ([url containsString:@"vvv"]) {
        _searchBar.text = [url stringByReplacingOccurrencesOfString:@"vvv" withString:@""];
    }
    if (!_histroyDetailViewController) {
        _histroyDetailViewController = [[OSEHistroyDetailViewController alloc]init];
    }
    _histroyDetailViewController.title = title;
    // 处理重定向问题
    NSMutableCharacterSet *set  = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [set addCharactersInString:@"#"];
    _histroyDetailViewController.url = [url stringByAddingPercentEncodingWithAllowedCharacters:set];
    [self.navigationController pushViewController:_histroyDetailViewController animated:YES];
}

- (void)tryOpenWebWithUrl:(NSString *)url {
    if (url.length < 1 || url == nil) return ;
    
    NSArray<NSString *> * urls = [self getUrlFromString:url];
    if (urls.count > 0 && urls.firstObject.length > 0 ) {
        url = urls.firstObject;
    }

    if ([url containsString:@"vvv"]) {
        url = [url stringByReplacingOccurrencesOfString:@"vvv" withString:@""];
    }
    BOOL openSucess = false ;
    for (NSString *currentDomain  in _domains){
        if ([url containsString:currentDomain]) {
            NSString * historicalPrice = [[_contentDic objectForKey:currentDomain] objectForKey:@"historicalPrice"];
            url = [url stringByReplacingOccurrencesOfString:currentDomain withString:historicalPrice];
            NSString * title = [[_contentDic objectForKey:currentDomain] objectForKey:@"platform"];
            [self enterHistoryDetailWithTitle:title url:url];
            openSucess = YES;
            break ;
        }
    }
    if (openSucess == false) {
        [self searchWithContent:url];
    }
    
    _searchBar.showsSearchResultsButton = YES;
    _searchBar.searchResultsButtonSelected = openSucess;
}

- (void)searchWithContent:(NSString *)content {
    NSString * url = nil;
    if([content containsString:@"http"] || [content containsString:baiduSearch]) {
        url = content;
        content = [[content stringByRemovingPercentEncoding] stringByReplacingOccurrencesOfString:baiduSearch withString:@""];
        _searchBar.text = content;
    }else {
        url = [NSString stringWithFormat:@"%@%@",baiduSearch,content];
    }
    [self enterHistoryDetailWithTitle:content url:url];
}

- (NSString *)pastboardUrl{
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    if (pastboard.string.length < 1) return @"";
    
    return pastboard.string;
}

- (NSArray*)getUrlFromString:(NSString *)string {
    NSError *error;
    //可以识别url的正则表达式
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
    options:NSRegularExpressionCaseInsensitive
    error:&error];

    NSArray *arrayOfAllMatches = [regex matchesInString:string
    options:0
    range:NSMakeRange(0, [string length])];

    //NSString *subStr;
    NSMutableArray *arr=[[NSMutableArray alloc] init];

    for (NSTextCheckingResult *match in arrayOfAllMatches){
        NSString* substringForMatch;
        substringForMatch = [string substringWithRange:match.range];
        [arr addObject:substringForMatch];
    }
    return arr;
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
