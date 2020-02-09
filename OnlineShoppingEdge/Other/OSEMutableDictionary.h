//
//  OSEMutableDictionary.h
//  OnlineShoppingEdge
//
//  Created by luting on 20/2/9.
//  Copyright © 2020 luting. All rights reserved.
//

#import <Foundation/Foundation.h>

#define  PlatformName        @"platform"
#define  HistoricalPriceData @"historicalPrice"

NS_ASSUME_NONNULL_BEGIN

@interface OSEMutableDictionary : NSObject

+ (instancetype)shareInstance;

+ (NSString *)histroyDeatailUrl:(NSString *)url;
 
+ (NSArray *)allKeys;

+ (NSDictionary *)contentData;

@end

NS_ASSUME_NONNULL_END
