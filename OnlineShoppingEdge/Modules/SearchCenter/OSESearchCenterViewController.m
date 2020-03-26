//
//  OSESearchCenterViewController.m
//  OnlineShoppingEdge
//
//  Created by luting on 20/2/3.
//  Copyright © 2020 luting. All rights reserved.
//

#import "OSESearchCenterViewController.h"
#import "OSESearchDetailViewController.h"

#define QuarkSearch @"https://quark.sm.cn/s?from=kkframenew&uc_param_str=dnntnwvepffrgibijbprsvpidsdichei&q="

@interface OSESearchCenterViewController ()<UISearchBarDelegate>

@property (nonatomic,strong)UISearchBar * searchBar;
@property (nonatomic,assign)BOOL isEditing;

@end

@implementation OSESearchCenterViewController {
    NSArray             * _hosts;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    _searchBar                   = [[UISearchBar alloc]init];
    _searchBar.searchBarStyle    = UISearchBarStyleProminent;
    _searchBar.barStyle          = UIBarStyleBlack;
    _searchBar.placeholder       = NSLocalizedString(@"请输入搜索内容", nil);
    _searchBar.returnKeyType     = UIReturnKeyDone;
    _searchBar.keyboardType      = UIKeyboardTypeURL;
    _searchBar.scopeButtonTitles = @[];
    _searchBar.tintColor         = UIColor.darkGrayColor;
    _searchBar.layer.cornerRadius= 8;
    _searchBar.clipsToBounds     = YES;
    _searchBar.delegate          = self;
    [self.view addSubview:_searchBar];
}

- (void)enterHistoryDetailWithTitle:(NSString *)title url:(NSString *)url {
    if (url == nil && url.length < 1) return ;
    
    NSMutableCharacterSet *set  = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [set addCharactersInString:@"#"];
    NSURL * URL = [NSURL URLWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:set]];
    OSESearchDetailViewController * searchlViewController = [[OSESearchDetailViewController alloc]initWithUrl:URL];
    searchlViewController.title = title;
    
    [self presentViewController:searchlViewController animated:YES completion:nil];
}
- (void)tryOpenWebWithUrl:(NSString *)url {
    if (url.length < 1 || url == nil) return ;
    
  
    [self searchWithContent:url];
    
    _searchBar.showsSearchResultsButton = YES;
    _searchBar.searchResultsButtonSelected = YES;
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

@end
