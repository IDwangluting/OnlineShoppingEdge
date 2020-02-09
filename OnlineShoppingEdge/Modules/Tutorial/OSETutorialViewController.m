//
//  OSETutorialViewController.m
//  OnlineShoppingEdge
//
//  Created by luting on 20/2/7.
//  Copyright © 2020 luting. All rights reserved.
//

#import "OSETutorialViewController.h"
#import "OSETutorialDetailViewController.h"

@interface ItemTableViewCell : UITableViewCell

- (void)setContentText:(NSString *)contentText;

@end

@implementation ItemTableViewCell {
    UIView * _bottomLine;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 1, self.width, 0.5)];
        _bottomLine.backgroundColor = [UIColor.grayColor colorWithAlphaComponent:0.1];
        [self addSubview:_bottomLine];
        self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _bottomLine.frame = CGRectMake(5, self.height - 2, self.width - 10, 1);
}

- (void)setContentText:(NSString *)contentText {
    UILabel * contentLable = self.textLabel;
    contentLable.textColor = UIColor.darkTextColor;
    contentLable.text = [NSString stringWithFormat:@"%@ -- %@",contentText,@"使用教程"];
}

@end

@interface OSETutorialViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation OSETutorialViewController {
    UITableView * _tableView;
    NSArray * _dataSources;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSources = @[@"天猫",@"淘宝",@"京东",@"亚马逊",@"当当",@"考拉海购"]; // @"苏宁易购", @"国美" ,
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UITableViewCell * cell = [_tableView cellForRowAtIndexPath:_tableView.indexPathForSelectedRow];
    [cell setSelected:false animated:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tableView.frame = CGRectMake(5, self.view.top, self.view.width - 5 * 2, self.view.height);
}

- (void)layoutSubviews {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(5, self.view.top, self.view.width - 5 * 2, self.view.height)
                                             style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate       = self;
    _tableView.dataSource     = self;
    _tableView.backgroundColor = UIColor.whiteColor;
    [_tableView registerClass:[ItemTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ItemTableViewCell class])];
    [self.view addSubview:_tableView];
}

#pragma mark UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController * viewController = [[OSETutorialDetailViewController alloc]init];
    viewController.title = [_dataSources objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:NSStringFromClass([ItemTableViewCell class])];
    if (cell) cell = [[ItemTableViewCell alloc]init];
    [cell setContentText:[_dataSources objectAtIndex:indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSources.count;
}

@end
