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
#define HistoricRecords  @1
#define SearchCenter     @2
#define CommentsFeedback @3
#define ContectUs        @4
#define DeviceInfo       @5
#define TrialVersion     @6
#define Contribute       @7

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
                      HistoricRecords :@{@"title":@"历史记录",
                                         @"page" :@""},
                      CommentsFeedback:@{@"title":@"意见与反馈",
                                         @"page" :@""},
                      SearchCenter    :@{@"title":@"搜索中心",
                                         @"page" :@"OSESearchCenterViewController"},
                      ContectUs       :@{@"title":@"联系我们",
                                         @"page" :@""},
                      DeviceInfo      :@{@"title":@"设备信息",
                                         @"page" :@"OSEUserInfoViewController"},
                      Contribute      :@{@"title":@"捐赠",
                                         @"page" :@"OSEContributeViewController"},
        };
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 80)];
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
    cell.textLabel.text  = [[_pageInfo objectForKey:@(indexPath.row)] objectForKey:@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == TrialVersion.intValue) {
        [self openURL:TestflightUrl];
    }else if(indexPath.row == CommentsFeedback.intValue) {
        [self openURL:[NSString stringWithFormat:QQGroupUrl,@"607385329",QQGroupKey]];
    }else if(indexPath.row == ContectUs.intValue) {
        [self openURL:[NSString stringWithFormat:QQGroupUrl,@"877106454",QQGroupKey]];
    }else {
        NSDictionary * item = [self.pageInfo objectForKey:@(indexPath.row)];
        NSString * class = [item objectForKey:@"page"];
        if (!class || class.length < 1)  {
            [_slideMenuController hideMenu];
            return ;
        }
        [_slideMenuController showViewController:class title:[item objectForKey:@"title"]];
    }
    [_slideMenuController hideMenu];
}

- (void)openURL:(NSString *)urlStr {
    NSURL * url = [NSURL URLWithString:urlStr];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

@end
