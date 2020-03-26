//
//  OSEUserInfoViewController.m
//  OnlineShoppingEdge
//
//  Created by luting on 2020/3/24.
//  Copyright © 2020 luting. All rights reserved.
//

#import "OSEUserInfoViewController.h"
#import "AppInfoMananger.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>

@interface OSEUserInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * userInfo;

@end

@implementation OSEUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userInfo = [NSMutableArray arrayWithCapacity:4];
    for (NSDictionary * item in [[AppInfoMananger manager] appInfo]) {
        NSString * key = @"";
        if ([item.allKeys.firstObject isEqualToString:@"system"]) {
            key = @"操作系统";
        }else if ([item.allKeys.firstObject isEqualToString:@"bundleId"]) {
            key = @"应  用  ID";
        }else if ([item.allKeys.firstObject isEqualToString:@"appName"]) {
            key = @"应用名称";
        }else if ([item.allKeys.firstObject isEqualToString:@"version"]) {
            key = @"应用版本";
        }else if ([item.allKeys.firstObject isEqualToString:@"bulidNumber"]) {
            key = @"编译版本";
        }else if ([item.allKeys.firstObject isEqualToString:@"appkey"]) {
            key = @"app名字";
        }else if ([item.allKeys.firstObject isEqualToString:@"systemVersion"]) {
            key = @"系统版本";
        }else if ([item.allKeys.firstObject isEqualToString:@"uuid"]) {
            key = @"手  机  ID";
        }else if ([item.allKeys.firstObject isEqualToString:@"appEnvironment"]) {
            key = @"安装环境";
        }else if ([item.allKeys.firstObject isEqualToString:@"phoneNumber"]) {
            key = @"本机号码";
        }else if ([item.allKeys.firstObject isEqualToString:@"allowsVOIP"]) {
            key = @"允许voip";
        }else if ([item.allKeys.firstObject isEqualToString:@"platform"]) {
            key = @"设备详情";
        }else if ([item.allKeys.firstObject isEqualToString:@"phoneModel"]) {
            key = @"设备类型";
        }else if ([item.allKeys.firstObject isEqualToString:@"mobileCountryCode"]) {
            key = @"国家编号";
        }else if ([item.allKeys.firstObject isEqualToString:@"mobileNetworkCode"]) {
            key = @"网络类型";
        }else if ([item.allKeys.firstObject isEqualToString:@"isoCountryCode"]) {
            key = @"国家代码";
        }else if ([item.allKeys.firstObject isEqualToString:@"carrierName"]) {
            key = @"运  营  商";
        }else if ([item.allKeys.firstObject isEqualToString:@"deviceName"]) {
            key = @"设备名称";
        }
        if (key.length < 1)  key = item.allKeys.firstObject ;
        NSString * value = item.allValues.firstObject;
        [_userInfo addObject:[NSString stringWithFormat:@"%@:%@",key,value]];
    }
    __block NSString * netStatus = [self currentNetWithStatus:[[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus]];
    [self.userInfo insertObject:[NSString stringWithFormat:@"网络状态:%@",netStatus] atIndex:3];
    
    @weakify(self);
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        @strongify(self);
        netStatus = [self currentNetWithStatus:status];
        [self deleteDataWithKey:@"网络状态"];
        [self.userInfo insertObject:[NSString stringWithFormat:@"网络状态:%@",netStatus] atIndex:3];
        [self.tableView reloadData];
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self byteRate];
}

- (NSString *)currentNetWithStatus:(AFNetworkReachabilityStatus)status {
    NSString * netStatus = @"";
    switch (status) {
        case AFNetworkReachabilityStatusUnknown:
            netStatus = @"识别不了";
            break;
        case AFNetworkReachabilityStatusNotReachable:
            netStatus = @"检测不到";
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            netStatus = @"4G/3G/2G";
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            netStatus = @"WiFi";
            break;
        default:
            break;
    }
    return netStatus;
}

- (void)deleteDataWithKey:(NSString *)key {
    NSArray * tmp = [self.userInfo copy];
    for (NSInteger index = tmp.count -1; index >= 0; index--) {
        if ([[tmp objectAtIndex:index] hasPrefix:key] ) {
            [self.userInfo removeObjectAtIndex:index];
            break ;
        }
    }
}

- (void)byteRate {
    [self deleteDataWithKey:@"下载网速"];
    [self deleteDataWithKey:@"上传网速"];
    NSString * inContent = @"", *outContent = @"";
    
    if ([AFNetworkReachabilityManager sharedManager].isReachable) {
        inContent  = [NSString stringWithFormat:@"下载网速:%@",[AppInfoMananger getiByteRate]];
        outContent = [NSString stringWithFormat:@"上传网速:%@",[AppInfoMananger getoByteRate]];
    }else {
        inContent  = @"下载网速:0B/秒";
        outContent = @"上传网速:0B/秒";
    }
    [self.userInfo insertObject:inContent atIndex:4];
    [self.userInfo insertObject:outContent atIndex:5];
    [self.tableView reloadData];
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        [self byteRate];
    });
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

- (void)layoutSubviews {
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds
                                             style:UITableViewStylePlain];
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleSingleLine;
    _tableView.delegate        = self;
    _tableView.dataSource      = self;
    _tableView.backgroundColor = UIColor.whiteColor;
    [_tableView registerClass:[UITableViewCell class]
       forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self.view addSubview:_tableView];
}

#pragma mark UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])
                                                             forIndexPath:indexPath];
    if(cell == nil) return  nil;
       
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    cell.textLabel.font  = [UIFont systemFontOfSize:15];
    cell.textLabel.text  = [_userInfo objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _userInfo.count;
}

@end
