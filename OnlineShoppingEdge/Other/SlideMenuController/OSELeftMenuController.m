//
//  OSELeftMenuController.m
//  OnlineShoppingEdge
//
//  Created by luting on 20/1/11
//  Copyright © 2020 luting. All rights reserved.
//

#import "OSELeftMenuController.h"
#import "OSESlideMenuController.h"

#define UserGuide        @0
#define TrialVersion     @1
#define SearchCenter     @2
#define CommentsFeedback @3
#define HistoricRecords  @4
#define ContectUs        @5
#define UpdateInfo       @6
#define AppInfoUserInfo  @7
#define Contribute       @8

#define TestflightUrl    @"https://testflight.apple.com/join/QsLkbB3d"
#define QQGroupKey       @"b4405d01b954d4a9d85258514bc6a8331151afc11fa627533d4541359bc85bd7"
#define QQGroupUrl       @"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external"

@interface OSELeftMenuController ()

@property (nonatomic,strong) NSDictionary * pageInfo;

@end

@implementation OSELeftMenuController {
    OSESlideMenuController * _slideMenuController;
}

- (instancetype)init {
    if (self = [super init]) {
        _pageInfo = @{UserGuide       :@{@"title":@"使用教程",
                                         @"page" :@"OSETutorialViewController"},
                      TrialVersion    :@{@"title":@"体验版",
                                         @"page" :@""},
                      HistoricRecords :@{@"title":@"搜索记录",
                                         @"page" :@""},
                      CommentsFeedback:@{@"title":@"意见与反馈",
                                         @"page" :@""},
                      SearchCenter    :@{@"title":@"搜索中心",
                                         @"page" :@"OSESearchCenterViewController"},
                      ContectUs       :@{@"title":@"联系我们",
                                         @"page" :@""},
                      UpdateInfo      :@{@"title":@"更新内容",
                                         @"page" :@""},
                      AppInfoUserInfo :@{@"title":@"app信息",
                                         @"page" :@""},
                      Contribute      :@{@"title":@"捐赠",
                                         @"page" :@""},
        };
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 80)];
    self.tableView.tableHeaderView = headerView;
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _pageInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"
                                                            forIndexPath:indexPath];
    if(cell == nil) return  nil;
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    cell.textLabel.font  = [UIFont systemFontOfSize:15];
    cell.textLabel.text  = [[_pageInfo objectForKey:@(indexPath.row)] objectForKey:@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_slideMenuController) {
        _slideMenuController = [self slideMenuController];
    }
    if (indexPath.row == TrialVersion.intValue) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:TestflightUrl]
                                               options:@{}
                                     completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:TestflightUrl]];
        }
        
    }else if(indexPath.row == CommentsFeedback.intValue) {
        [self jumpQQqun:@"607385329"];
    }else if(indexPath.row == ContectUs.intValue) {
        [self jumpQQqun:@"877106454"];
    }else if(indexPath.row == AppInfoUserInfo.intValue) {
        NSString * title = [[self.pageInfo objectForKey:@(indexPath.row)] objectForKey:@"title"];
        NSString * class = [[self.pageInfo objectForKey:@(indexPath.row)] objectForKey:@"page"];
        if (!class || class.length < 1)  {
            [_slideMenuController hideMenu];
            return ;
        }
                  
        UIViewController * viewController = [[NSClassFromString(class) alloc]init];
        viewController.title = NSLocalizedString(title, nil);
        [_slideMenuController showViewController:viewController];
    }
    [_slideMenuController hideMenu];
}

- (void)jumpQQqun:(NSString *)groupId {
    NSString * urlStr  = [NSString stringWithFormat:QQGroupUrl,groupId,QQGroupKey];
    NSURL * url = [NSURL URLWithString:urlStr];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
        return ;
    }
}

@end
