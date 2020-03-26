//
//  OSELeftMenuController.m
//  OnlineShoppingEdge
//
//  Created by luting on 20/1/11
//  Copyright © 2020 luting. All rights reserved.
//

#import "OSELeftMenuController.h"
#import "OSESlideMenuController.h"
#import <StoreKit/StoreKit.h>
#import "AppInfoMananger.h"
#import "MBProgressHUD.h"
#import "CommonDefine.h"
#import <Toast/Toast.h>

#define UserGuide        @0
#define SearchCenter     @1
#define FeedbackCenter   @2
#define ContectUs        @3
#define DeviceInfo       @4
#define ChectUpdate      @5
#define TrialVersion     @6
//#define HistoricRecords  @7
//#define Contribute       @8


@interface OSELeftMenuController ()<SKStoreProductViewControllerDelegate>

@property (nonatomic,strong) NSDictionary * pageInfo;

@end

@implementation OSELeftMenuController {
    OSESlideMenuController * _slideMenuController;
}

- (instancetype)init {
    if (self = [super init]) {
        _pageInfo = @{UserGuide       :@{@"title":@"使用教程",
                                         @"page" :@"OSETutorialViewController"},
                      FeedbackCenter  :@{@"title":@"反馈中心",
                                         @"page" :@""},
                      ChectUpdate     :@{@"title":@"检查更新",
                                         @"page" :@""},
                      SearchCenter    :@{@"title":@"搜索中心",
                                         @"page" :@"OSESearchCenterViewController"},
                      ContectUs       :@{@"title":@"联系我们",
                                         @"page" :@""},
                      DeviceInfo      :@{@"title":@"设备信息",
                                         @"page" :@"OSEUserInfoViewController"},
//                      TrialVersion    :@{@"title":@"体验版",
//                                         @"page" :@""},
//                      Contribute      :@{@"title":@"捐赠",
//                                         @"page" :@"OSEContributeViewController"},
//                      HistoricRecords :@{@"title":@"历史记录",
//                                         @"page" :@""},
        };
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 0)];
    self.tableView.tableHeaderView = headerView;
    [self.tableView reloadData];
    
    if (!_slideMenuController) {
        _slideMenuController = [self slideMenuController];
        for (NSDictionary * item in _pageInfo.allValues) {
            NSString * identifier = [item objectForKey:@"page"];
            if (!identifier || identifier.length < 0)  continue ;
            
            [_slideMenuController registerClass:NSClassFromString(identifier)
                         forCellReuseIdentifier:identifier];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _pageInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])
                                                            forIndexPath:indexPath];
    if(cell == nil) return  nil;
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    cell.textLabel.font  = [UIFont systemFontOfSize:15];
    NSString * title     = [[_pageInfo objectForKey:@(indexPath.row)] objectForKey:@"title"];
    cell.textLabel.text  = NSLocalizedString(title,nil);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == TrialVersion.intValue) {
        [self openURL:TestflightUrl];
    }else if(indexPath.row == FeedbackCenter.intValue) {
        [self openURL:FacebackCenterUrl];
    }else if(indexPath.row == ContectUs.intValue) {
        [self openURL:ContectUsUrl];
    }else if(indexPath.row == ChectUpdate.intValue) {
        [self checkUpdate];
        return ;
    }else {
        NSDictionary * item = [self.pageInfo objectForKey:@(indexPath.row)];
        NSString * class = [item objectForKey:@"page"];
        if (class && class.length > 1)  {
            [_slideMenuController showViewController:class title:[item objectForKey:@"title"]];
        }
    }
    [_slideMenuController hideMenu];
}

- (void)openURL:(NSString *)urlStr {
    NSURL * url = [NSURL URLWithString:urlStr];
    if(![[UIApplication sharedApplication] canOpenURL:url]) return ;
        
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        return ;
    }
    [[UIApplication sharedApplication] openURL:url];
}

- (void)checkUpdate {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self ;
    void (^UpdataTip)(NSString *tips) = ^(NSString * tips){
        [weakSelf.view makeToast:tips
                        duration:2.0
                        position:CSToastPositionTop];
    };
    NSError *error;
    NSDictionary *appInfo = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:AppInfoUrl]]
                                                            options:NSJSONReadingAllowFragments
                                                              error:&error];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (error){
        UpdataTip(@"更新出错");
        return ;
    }

    NSArray *infoContent = [appInfo objectForKey:@"results"];
    NSString * version   = [[infoContent objectAtIndex:0]objectForKey:@"version"];
    if (version && [version isEqualToString:[AppInfoMananger manager].version]) {
        UpdataTip(@"不需要更新");
        return ;
    }
    [self openURL:AppInstallUrl];
}

- (void)recommandInstallAppWithId:(NSString *)appId {
    if (@available(iOS 10.3, *)) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        __block SKStoreProductViewController *productViewController = [[SKStoreProductViewController alloc] init];
        productViewController.delegate = self;
        __weak typeof(self) weakSelf = self ;
        [productViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:appId}
                                         completionBlock:^(BOOL result, NSError *error) {
            [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
            if (result == false || error) return ;
            
            [weakSelf presentViewController:productViewController animated:YES completion:nil];
        }];
    }
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
