//
//  WebRefreshController.h
//  OnlineShoppingEdge
//
//  Created by luting on 20/3/24.
//  Copyright © 2020 luting. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebRefreshController : UIViewController

@property (nonatomic,assign)CGFloat refreshTimespan; //default 3 second

@property (nonatomic,copy) NSString * url;

+ (instancetype)new API_UNAVAILABLE(ios);

- (instancetype)init API_UNAVAILABLE(ios);

- (void)refresh;

- (void)stopRefresh;

@end

NS_ASSUME_NONNULL_END
