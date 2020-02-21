//
//  OSEHomeViewController.m
//  OnlineShoppingEdge
//
//  Created by luting on 20/2/3.
//  Copyright © 2020 luting. All rights reserved.
//

#import "OSEHomeViewController.h"
#import "OSEMutableDictionary.h"
#import "OSETutorialViewController.h"
#import "OSEHistroyDetailViewController.h"
#import <YYCategories/UIGestureRecognizer+YYAdd.h>

//#import <CoreTelephony/CTTelephonyNetworkInfo.h>
//#import <CoreTelephony/CTCarrier.h>

#define QuarkSearch @"https://quark.sm.cn/s?from=kkframenew&uc_param_str=dnntnwvepffrgibijbprsvpidsdichei&q="

//可以识别url的正则表达式
#define RegulaStr @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"

@interface OSEHomeViewController ()<UISearchBarDelegate>

@property (nonatomic,strong)UISearchBar * searchBar;
@property (nonatomic,assign)BOOL isEditing;

@end

@implementation OSEHomeViewController {
    NSArray             * _hosts;
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.isEditing = NO;
}

- (void)layoutSubviews {
    self.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"如何使用?", nil)
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(tutorial:)];
    
    _searchBar                   = [[UISearchBar alloc]init];
    _searchBar.searchBarStyle    = UISearchBarStyleProminent;
    _searchBar.barStyle          = UIBarStyleBlack;
    _searchBar.placeholder       = NSLocalizedString(@"请输入网商品地址", nil);
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
        if (self.isEditing) {
            [self.view endEditing:YES];
            return ;
        }
        [self tryOpenWebWithUrl:self.searchBar.text];
    }];
    [self.view addGestureRecognizer:tap];
    _hosts = [OSEMutableDictionary allKeys];
}

- (void)tutorial:(UIButton *)sender {
    if (!_tutorialViewController) {
        _tutorialViewController = [[OSETutorialViewController alloc]init];
        _tutorialViewController.title = NSLocalizedString(@"使用教程", nil);
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
    _histroyDetailViewController.url = [NSURL URLWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:set]];
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
    NSString * host = [NSURL URLWithString:url].host;
    url = [OSEMutableDictionary histroyDeatailUrl:url];
    if ([_hosts containsObject:host]) {
        NSString * title = [[[OSEMutableDictionary contentData] objectForKey:host] objectForKey:PlatformName];
        [self enterHistoryDetailWithTitle:title url:url];
        openSucess = YES;
    }
    
    if (openSucess == false) {
        [self searchWithContent:url];
    }
    
    _searchBar.showsSearchResultsButton = YES;
    _searchBar.searchResultsButtonSelected = openSucess;
}

- (void)searchWithContent:(NSString *)content {
    NSString * url = nil;
    if([content containsString:@"http"] || [content containsString:QuarkSearch]) {
        url = content;
        content = [[content stringByRemovingPercentEncoding] stringByReplacingOccurrencesOfString:QuarkSearch withString:@""];
        _searchBar.text = content;
    }else {
        url = [NSString stringWithFormat:@"%@%@",QuarkSearch,content];
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

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:RegulaStr
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
        NSString * tmpUrl = [_histroyDetailViewController.url.absoluteString stringByReplacingOccurrencesOfString:@"vvv" withString:@""];
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
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    _isEditing = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    _isEditing = NO;
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
