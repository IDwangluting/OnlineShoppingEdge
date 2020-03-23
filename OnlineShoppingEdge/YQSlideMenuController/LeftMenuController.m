//
//  LeftMenuController.m
//  YQSlideMenuControllerDemo
//
//  Created by Wang on 15/5/26.
//  Copyright (c) 2015年 Wang. All rights reserved.
//

#import "LeftMenuController.h"
#import "UIViewController+YQSlideMenu.h"
#import "OSETutorialViewController.h"

#define UserGuide        @0
#define TrialVersion     @1
@implementation LeftMenuController {
    NSDictionary *_titleDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleDic = @{UserGuide       :@"使用教程",
                  TrialVersion    :@"体验版",
    };
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 80)];
    self.tableView.tableHeaderView = headerView;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titleDic.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    if(cell == nil) return  nil;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [_titleDic objectForKey:@(indexPath.row)];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController * viewController = nil;
    
    if (indexPath.row == UserGuide.intValue) {
        viewController = [[OSETutorialViewController alloc]init];
    }else if (indexPath.row == TrialVersion.intValue) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://testflight.apple.com/join/QsLkbB3d"] options:@{} completionHandler:nil];
        return ;
    }
    viewController.title = NSLocalizedString([_titleDic objectForKey:@(indexPath.row)], nil);
    [self.slideMenuController showViewController:viewController];
}

@end
