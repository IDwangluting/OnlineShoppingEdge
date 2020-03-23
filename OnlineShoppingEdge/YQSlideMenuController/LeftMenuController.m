//
//  LeftMenuController.m
//  YQSlideMenuControllerDemo
//
//  Created by Wang on 15/5/26.
//  Copyright (c) 2015年 Wang. All rights reserved.
//

#import "LeftMenuController.h"
#import "YQSlideMenuController.h"
#import <YYCategories/YYCategoriesMacro.h>

#define UserGuide        @0
#define TrialVersion     @1
#define SearchCenter     @4
#define TestflightUrl    @"https://testflight.apple.com/join/QsLkbB3d"

@interface LeftMenuController ()

@property (nonatomic,strong) NSDictionary * pageInfo;

@end

@implementation LeftMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageInfo = @{UserGuide       :@{@"title":@"使用教程",
                                     @"page" :@"OSETutorialViewController"},
                  TrialVersion    :@{@"title":@"体验版",
                                     @"page" :@""},
                  SearchCenter    :@{@"title":@"搜索中心",
                                     @"page" :@"OSESearchCenterViewController"},
    };
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    if(cell == nil) return  nil;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [[_pageInfo objectForKey:@(indexPath.row)] objectForKey:@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == TrialVersion.intValue) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:TestflightUrl]
                                           options:@{}
                                 completionHandler:nil];
        return ;
    }
    
    NSString * title = [[self.pageInfo objectForKey:@(indexPath.row)] objectForKey:@"title"];
    NSString * class = [[self.pageInfo objectForKey:@(indexPath.row)] objectForKey:@"page"];
    if (!class || class.length < 1)  return ;
           
    UIViewController * viewController = [[NSClassFromString(class) alloc]init];
    viewController.title = NSLocalizedString(title, nil);
    [[self slideMenuController] showViewController:viewController];
}

- (YQSlideMenuController *)slideMenuController {
    UIViewController *iter = self.parentViewController;
    while (iter) {
        if ([iter isKindOfClass:[YQSlideMenuController class]]) {
            return (YQSlideMenuController *)iter;
        } else if (iter.parentViewController && iter.parentViewController != iter) {
            iter = iter.parentViewController;
        } else {
            iter = nil;
        }
    }
    return nil;
}

@end
