//
//  OSESlidMenuController.h
//  OnlineShoppingEdge
//
//  Created by luting on 20/1/11
//  Copyright © 2020 luting. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OSEContentViewControllerDelegate <NSObject>

- (nullable UINavigationController *)OSE_navigationController;

@end

@interface OSESlideMenuController : UIViewController
/**
 *  是否缩放内容视图 默认YES
 */
@property (nonatomic, assign) IBInspectable BOOL scaleContent;

/**
 *  菜单打开时原来内容页露在侧边的最大宽， 如果有缩放则指缩放完成之后的
 */
@property (nonatomic,assign) CGFloat contentViewVisibleWidth;

/**
 *  允许旋转 默认为NO
 */
@property (assign, nonatomic) BOOL allowRotate;

- (instancetype _Nullable )initWithHomePage:(UIViewController * _Nonnull)homePageViewController
                    slideMenuViewController:(UIViewController * _Nonnull)slideMenuViewController;  

- (void)registerClass:(nullable Class)cls forCellReuseIdentifier:(NSString * _Nonnull)identifier;

- (void)showViewController:(NSString *_Nonnull)identifier;

- (void)showViewController:(NSString *_Nonnull)identifier title:(NSString *_Nullable)title;

- (void)hideMenu;

- (void)showMenu;

@end

@interface UIViewController(SlideMenu)

 - (nullable OSESlideMenuController *)slideMenuController;

@end

