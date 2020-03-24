//
//  AppInfoMananger.h
//  Kangaroo
//
//  Created by luting on 2019/5/9.
//  Copyright © 2019 bocai. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface AppInfoMananger : NSObject

@property (nonatomic,copy)NSString * bundleId;
@property (nonatomic,copy)NSString * version;
@property (nonatomic,copy)NSString * bulidNumber;
@property (nonatomic,copy)NSString * appName;
@property (nonatomic,copy)NSString * deviceName;
@property (nonatomic,copy)NSString * systemName;
@property (nonatomic,copy)NSString * systemVersion;
@property (nonatomic,copy)NSString * phoneModel; //手机型号
@property (nonatomic,copy)NSString * localizedModel; //地方型号  （国际化区域名称）
@property (nonatomic,copy)NSString * uuid;
@property (nonatomic,copy)NSString * devicePlatform;
@property (nonatomic,copy)NSString * appEnvironment;

@property (nonatomic,copy)NSString * carrierName;//供应商名称（中国联通 中国移动）
@property (nonatomic,copy)NSString * mobileCountryCode; //所在国家编号
@property (nonatomic,copy)NSString * mobileNetworkCode; //供应商网络编号
@property (nonatomic,copy)NSString * allowsVOIP ;
@property (nonatomic,copy)NSString * isoCountryCode;

@property (nonatomic,strong)NSArray * appInfo;

+ (instancetype)manager;

+ (NSString *)getiByteRate;

+ (NSString *)getoByteRate;

@end

NS_ASSUME_NONNULL_END
