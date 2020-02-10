//
//  OSEMutableDictionary.m
//  OnlineShoppingEdge
//
//  Created by luting on 20/2/9.
//  Copyright © 2020 luting. All rights reserved.
//

#import "OSEMutableDictionary.h"

@implementation OSEMutableDictionary
static OSEMutableDictionary * obj = nil;
static NSMutableDictionary * contentData = nil;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[OSEMutableDictionary alloc]init];
    });
    return obj;
}

- (instancetype)init {
    if (self = [super init]) {
        contentData = [[NSMutableDictionary alloc]initWithCapacity:4];
        NSString *tmail = NSLocalizedString(@"天猫", nil);
        [contentData setObject:@{PlatformName       :tmail,
                          HistoricalPriceData:@"detail.tmallvvv.com"}
                 forKey:@"detail.tmall.com"];
        [contentData setObject:@{PlatformName       :tmail,
                          HistoricalPriceData:@"detail.m.tmallvvv.com"}
                 forKey:@"detail.m.tmall.com"];
                      
        NSString *taobao = NSLocalizedString(@"淘宝", nil);
        [contentData setObject:@{PlatformName       :taobao,
                          HistoricalPriceData:@"item.taobaovvv.com"}
                 forKey:@"item.taobao.com"];
        [contentData setObject:@{PlatformName       :taobao,
                          HistoricalPriceData:@"h5.m.taobaovvv.com"}
                 forKey:@"h5.m.taobao.com"];
        
        NSString *jd = NSLocalizedString(@"京东", nil);
        [contentData setObject:@{PlatformName       :jd,
                          HistoricalPriceData:@"item.jdvvv.com"}
                 forKey:@"item.jd.com"];
        [contentData setObject:@{PlatformName       :jd,
                          HistoricalPriceData:@"item.m.jdvvv.com"}
                 forKey:@"item.m.jd.com"];
                      
        NSString * amazon = NSLocalizedString(@"亚马逊", nil);
        [contentData setObject:@{PlatformName       :amazon,
                          HistoricalPriceData:@"www.amazonvvv.cn"}
                 forKey:@"www.amazon.cn"];
                      
        NSString * dangdang = NSLocalizedString(@"当当", nil);
        [contentData setObject:@{PlatformName       :dangdang,
                          HistoricalPriceData:@"product.dangdangvvv.com"}
                 forKey:@"product.dangdang.com"];
        [contentData setObject:@{PlatformName       :dangdang,
                          HistoricalPriceData:@"product.dangdangvvv.com"}
                 forKey:@"product.m.dangdang.com"];
                                
        NSString * kaola = NSLocalizedString(@"考拉海购", nil);
        [contentData setObject:@{PlatformName       :kaola,
                          HistoricalPriceData:@"goods.kaolavvv.com"}
                 forKey:@"goods.kaola.com"];
        [contentData setObject:@{PlatformName       :kaola,
                          HistoricalPriceData:@"goods.kaolavvv.com"}
                 forKey:@"m-goods.kaola.com"];
                           
        //        [contentData setObject:@{PlatformName       :@"苏宁易购",
        //                          HistoricalPriceData:@"product.suningvvv.com"}
        //                 forKey:@"product.suning.com"];
        //
        //        [contentData setObject:@{PlatformName       :@"国美",
        //                          HistoricalPriceData:@"item.gomevvv.com.cn"}
        //                 forKey:@"item.gome.com.cn"];
        // 暂不支持
//        [contentData setObject:@{PlatformName       :@"苏宁易购",
//                          HistoricalPriceData:@"m.suning.com"}
//                 forKey:@"m.suning.com"];
//        [contentData setObject:@{PlatformName       :@"国美",
//                          HistoricalPriceData:@"item.m.gome.com.cn"}
//                 forKey:@"item.m.gome.com.cn"];
    }
    return self;
}

+ (NSArray *)allKeys {
    [OSEMutableDictionary shareInstance];
    return contentData.allKeys;
}

+ (NSDictionary *)contentData {
    return contentData;
}

+ (NSString *)histroyDeatailUrl:(NSString *)url {
    NSString * host = [NSURL URLWithString:url].host;
    if ([contentData.allKeys containsObject:host]) {
        NSString * historicalPrice = [[contentData objectForKey:host] objectForKey:HistoricalPriceData];
        url = [url stringByReplacingOccurrencesOfString:host withString:historicalPrice];
    }
    return url;
}

@end
