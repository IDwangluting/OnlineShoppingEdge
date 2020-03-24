//
//  OSEUserInfoViewController.m
//  OnlineShoppingEdge
//
//  Created by luting on 2020/3/24.
//  Copyright © 2020 luting. All rights reserved.
//

#import "OSEUserInfoViewController.h"
#import "AppInfoMananger.h"

@interface OSEUserInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;

@end

@implementation OSEUserInfoViewController {
    NSMutableArray * _userInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _userInfo = [NSMutableArray arrayWithCapacity:4];
    NSDictionary * tmp = [[AppInfoMananger manager] appInfo];
    for (NSString * key in tmp) {
        NSString * name = @"";
        if ([key isEqualToString:@"system"]) {
            name = @"操作系统";
        }else if ([key isEqualToString:@"bundleId"]) {
            name = @"应 用 ID";
        }else if ([key isEqualToString:@"version"]) {
            name = @"版 本 号";
        }else if ([key isEqualToString:@"bulidNumber"]) {
            name = @"编译版本";
        }else if ([key isEqualToString:@"appName"]) {
            name = @"app名字";
        }else if ([key isEqualToString:@"deviceName"]) {
            name = @"设 备 名";
        }else if ([key isEqualToString:@"systemVersion"]) {
            name = @"系统版本";
        }else if ([key isEqualToString:@"uuid"]) {
            name = @"手机 ID";
        }else if ([key isEqualToString:@"appEnvironment"]) {
            name = @"安装环境";
        }else if ([key isEqualToString:@"phoneNumber"]) {
            name = @"本机号码";
        }else if ([key isEqualToString:@"allowsVOIP"]) {
            name = @"允许VOIP";
        }else if ([key isEqualToString:@"localizedModel"]) {
            name = @"平   台";
        }else if ([key isEqualToString:@"platform"]) {
            name = @"设备详情";
        }else if ([key isEqualToString:@"phoneModel"]) {
            name = @"手机模式";
        }else if ([key isEqualToString:@"carrierName"]) {
            name = @"供应商名称";
        }else if ([key isEqualToString:@"carrierName"]) {
            name = @"供应商名称";
        }else if ([key isEqualToString:@"mobileCountryCode"]) {
            name = @"国家编号";
        }else if ([key isEqualToString:@"mobileNetworkCode"]) {
            name = @"网络编号";
        }else if ([key isEqualToString:@"isoCountryCode"]) {
            name = @"国家代码";
        }
        if (name.length < 1)  name = key ;
        NSString * value = tmp[key];
        if (value.length < 1) {
            [_userInfo addObject:[NSString stringWithFormat:@"%@:%@",name,tmp[key]]];
        }else if(_userInfo.count < 1) {
            [_userInfo addObject:[NSString stringWithFormat:@"%@:%@",name,tmp[key]]];
        }else{
            [_userInfo insertObject:[NSString stringWithFormat:@"%@:%@",name,tmp[key]] atIndex:0];
        }
    }
}

- (void)layoutSubviews {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(5, self.view.top, self.view.width - 5 * 2, self.view.height)
                                             style:UITableViewStylePlain];
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
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
