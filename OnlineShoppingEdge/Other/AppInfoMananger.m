//
//  AppInfoMananger.m
//  Kangaroo
//
//  Created by luting on 2019/5/9.
//  Copyright © 2019 bocai. All rights reserved.
//

#import "AppInfoMananger.h"
#import "sys/sysctl.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
#import <UIKit/UIDevice.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@implementation AppInfoMananger {
    NSDictionary *_infoDictionary;
    CTCarrier    *_carrier;
}

+ (instancetype)manager {
    static AppInfoMananger * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AppInfoMananger alloc]init];
    });
    return manager ;
}

- (instancetype)init {
    if (self = [super init]) {
        CTTelephonyNetworkInfo *  networkInfo = [[CTTelephonyNetworkInfo alloc] init];
        _carrier = networkInfo.subscriberCellularProvider;
        _infoDictionary = [[NSBundle mainBundle] infoDictionary];
    }
    return self;
}

- (NSDictionary *)appInfo {
    if (!_appInfo) {
        AppInfoMananger *  manager = [AppInfoMananger manager];
        _appInfo = @{@"bundleId"          :manager.bundleId,
                     @"version"           :manager.version,
                     @"bulidNumber"       :manager.bulidNumber,
//                     @"appName"           :manager.appName,
                     @"deviceName"        :manager.deviceName,
                     @"system"            :manager.systemName,
                     @"systemVersion"     :manager.systemVersion,
                     @"localizedModel"    :manager.localizedModel,
                     @"platform"          :manager.devicePlatform,
                     @"uuid"              :manager.uuid,
                     @"phoneModel"        :manager.phoneModel,
                     @"appEnvironment"    :manager.appEnvironment,
                     @"carrierName"       :manager.carrierName,
                     @"mobileCountryCode" :manager.mobileCountryCode,
                     @"mobileNetworkCode" :manager.mobileNetworkCode,
                     @"allowsVOIP"        :manager.allowsVOIP,
                     @"isoCountryCode"    :manager.isoCountryCode,
                     @"phoneNumber"       :manager.phoneNumber
        };
    }
    return _appInfo;
}

- (NSString *)bundleId {
    if (!_bundleId) {
        _bundleId = [[NSBundle mainBundle] bundleIdentifier];
    }
    return _bundleId;
}

- (NSString *)phoneNumber {
    if (!_phoneNumber) {
        _phoneNumber = [[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"]?:@"";
    }
    return _phoneNumber;
}

- (NSString *)version {
    if (!_version) {
        _version = [_infoDictionary objectForKey:@"CFBundleShortVersionString"];
    }
    return _version;
}

- (NSString *)bulidNumber {
    if (!_bulidNumber) {
        _bulidNumber = [_infoDictionary objectForKey:@"CFBundleVersion"];
    }
    return _bulidNumber;
}

- (NSString *)appName {
    if (!_appName) {
       _appName = [_infoDictionary objectForKey:@"CFBundleDisplayName"];
    }
    return _appName;
}

- (NSString *)deviceName {
    if (!_deviceName) {
        _deviceName = [[UIDevice currentDevice] name];
    }
    return _deviceName;
}

- (NSString *)systemName {
    if (!_systemName) {
        _systemName = [[UIDevice currentDevice] systemName];
    }
    return _systemName;
}

- (NSString *)systemVersion {
    if (!_systemVersion) {
        _systemVersion = [[UIDevice currentDevice] systemVersion];
    }
    return _systemVersion;
}

- (NSString *)phoneModel {
    if (!_phoneModel) {
        _phoneModel = [[UIDevice currentDevice] model];
    }
    return _phoneModel;
}

- (NSString *)localizedModel {
    if (!_localizedModel) {
        _localizedModel = [[UIDevice currentDevice] localizedModel];
    }
    return _localizedModel ;
}

- (NSString *)uuid {
    if (!_uuid) {
       _uuid = [UIDevice currentDevice].identifierForVendor.UUIDString;
    }
    return _uuid;
}

- (NSString *)appEnvironment {
    if (!_appEnvironment) {
        #if DEBUG
            _appEnvironment = @"debug";
        #else
            _appEnvironment = @"release";
        #endif
    }
    return _appEnvironment;
}

- (NSString *)carrierName {
    if (!_carrierName) {
        _carrierName = _carrier.carrierName?:@"";
    }
    return _carrierName;
}

- (NSString *)mobileCountryCode {
    if (!_mobileCountryCode) {
        _mobileCountryCode = _carrier.mobileCountryCode?:@"";
    }
    return _mobileCountryCode;
}

- (NSString *)mobileNetworkCode {
    if (!_mobileNetworkCode) {
        _mobileNetworkCode = _carrier.mobileNetworkCode?:@"";
    }
    return _mobileNetworkCode;
}

- (NSString *)isoCountryCode {
    if (!_isoCountryCode) {
        _isoCountryCode = _carrier.isoCountryCode?:@"";
    }
    return _isoCountryCode;
}

- (NSString *)allowsVOIP {
    if (!_allowsVOIP) {
        _allowsVOIP = _carrier.allowsVOIP?@"YES":@"NO";
    }
    return _allowsVOIP;
}

- (NSString *)machine {
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    return platform;
}

- (NSString *)devicePlatform {
    if (_devicePlatform)  return _devicePlatform;

    NSString *platform = [self machine];
//    iPhone
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6 (A1549/A1586/A1589)";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus (A1522/A1524/1593)";
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6s (A1633/A1688/A1691/A1700)";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus (A1634/A1687/A1699)";
    if ([platform isEqualToString:@"iPhone8,4"])    return @"iPhone SE (A1662/A1723/A1724)";
    if ([platform isEqualToString:@"iPhone9,1"])    return @"iPhone 7 (A1600/A1778/A1779,A1780)";
    if ([platform isEqualToString:@"iPhone9,3"])    return @"iPhone 7 (A1600/A1778/A1779,A1780)";
    if ([platform isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus (A1661/A1784/A1785/A1786)";
    if ([platform isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus (A1661/A1784/A1785/A1786)";
    if ([platform isEqualToString:@"iPhone10,1"])   return @"iPhone 8 (A1863/A1905/A1906,A1907)";
    if ([platform isEqualToString:@"iPhone10,4"])   return @"iPhone 8 (A1863/A1905/A1906,A1907)";
    if ([platform isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus(A1864/A1897/A1898,A1899)";
    if ([platform isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus(A1864/A1897/A1898,A1899)";
    if ([platform isEqualToString:@"iPhone10,3"])   return @"iPhoneX (A1865/A1901/A1902)";
    if ([platform isEqualToString:@"iPhone10,6"])   return @"iPhoneX (A1865/A1901/A1902)";
    if ([platform isEqualToString:@"iPhone11,2"])   return @"iPhoneXS (A1920/A2097/A2098/A2100)";
    if ([platform isEqualToString:@"iPhone11,6"])   return @"iPhoneXS Max(A1921/A2101/A2102/A2104)";
    if ([platform isEqualToString:@"iPhone11,8"])   return @"iPhoneXR (A1984/A2105/A2106/A2108)";
//iPod
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
//iPod
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPad (Wifi)     (A1219)";
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad (Wifi+3G)  (A1337)";
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2(Wifi)    (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2(Wifi+3G GSM)  (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2(Wifi+3G CDMA) (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2(Wifi) (A1395)";
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3(Wifi) (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3(Wifi+Cellular) (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3(Wifi+Cellular) (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4(Wifi) (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4(Wifi+Cellular) (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4(Wifi+Cellular MM) (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (Wifi)(A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (Wifi+Cellular) (A1475/A1476)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad5,3"])   return @"iPad Air 2 (WiFi)(A1566)";
    if ([platform isEqualToString:@"iPad5,4"])   return @"iPad Air 2 (Wifi+Cellular)(A1567)";
    
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (Wifi)(A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (Wifi+Cellular)(A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (Wifi+Cellular MM)(A1455)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490/A1491)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    if ([platform isEqualToString:@"iPad4,7"])   return @"iPad Mini 3G(Wifi) (A1599)";
    if ([platform isEqualToString:@"iPad4,8"])   return @"iPad Mini 3G(Wifi+Cellular) (A1600/A1601)";
    if ([platform isEqualToString:@"iPad5,1"])   return @"iPad Mini 4G(Wifi) (A1538)";
    if ([platform isEqualToString:@"iPad5,2"])   return @"iPad Mini 4G(Wifi+Cellular) (A1550)";
    
    if ([platform isEqualToString:@"iPad6,3"])   return @"iPad Pro (9.7-inch-WiFi)(A1673)";
    if ([platform isEqualToString:@"iPad6,4"])   return @"iPad Pro (9.7-inch-Cellular)(A1674/1675)";
    if ([platform isEqualToString:@"iPad7,3"])   return @"iPad Pro (10.5-inch-WiFi)(A1701)";
    if ([platform isEqualToString:@"iPad7,4"])   return @"iPad Pro (10.5-inch-WiFi+Cellular)(A1709)";
    if ([platform isEqualToString:@"iPad6,7"])   return @"iPad Pro (12.9-inch-WiFi) (A1584)";
    if ([platform isEqualToString:@"iPad6,8"])   return @"iPad Pro (12.9-inch-Cellular)(A1652)";
    if ([platform isEqualToString:@"iPad7,1"])   return @"iPad Pro 2 (12.9-inch-WiFi)(A1670)";
    if ([platform isEqualToString:@"iPad7,2"])   return @"iPad Pro 2 (12.9-inch-Cellular)(A1821)";
    if ([platform isEqualToString:@"iPad7,4"])   return @"iPad Pro (10.5-inch-4G)";
    if ([platform isEqualToString:@"iPad6,11"])  return @"iPad 5 (WiFi)(A1822)";
    if ([platform isEqualToString:@"iPad6,12"])  return @"iPad 5 (WiFi+Cellular)(A1823)";
    if ([platform isEqualToString:@"iPad7,5"])   return @"iPad 6 (WiFi)(A1893)";
    if ([platform isEqualToString:@"iPad7,6"])   return @"iPad 6 (WiFi+Cellular)(A1954)";
    
    if ([platform isEqualToString:@"iPad8,1"])   return @"iPad Pro (11-inch-WiFi) (A1584)";
    if ([platform isEqualToString:@"iPad8,2"])   return @"iPad Pro (11-inch-WiFi) (A1584)";
    if ([platform isEqualToString:@"iPad8,3"])   return @"iPad Pro (11-inch-WiFi+Cellular) (A2013/!1934/A1979)";
    if ([platform isEqualToString:@"iPad8,4"])   return @"iPad Pro (11-inch-WiFi+Cellular) (A2013/!1934/A1979)";
    if ([platform isEqualToString:@"iPad8,5"])   return @"iPad Pro 3 (12.9-inch-WiFi) (A1876)";
    if ([platform isEqualToString:@"iPad8,6"])   return @"iPad Pro 3 (12.9-inch-WiFi) (A1876)";
    
    if ([platform isEqualToString:@"iPad8,7"])   return @"iPad Pro 3 (12.9-inch-WiFi+Cellular) (A2014/A1895/A1983)";
    if ([platform isEqualToString:@"iPad8,8"])   return @"iPad Pro 3 (12.9-inch-WiFi+Cellular) (A2014/A1895/A1983)";
    
//    iPhone Simulator
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
}

+ (NSString *)getByteRate {
    long long intcurrentBytes = [AppInfoMananger getInterfaceBytes];
    NSString *rateStr = [AppInfoMananger formatNetWork:intcurrentBytes];
    return rateStr;
}

+ (long long)getInterfaceBytes {
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1)  return 0;
    
    uint32_t iBytes = 0;
    uint32_t oBytes = 0;
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next) {
        if (AF_LINK != ifa->ifa_addr->sa_family) continue;
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))   continue;
        if (ifa->ifa_data == 0) continue;
        /* Not a loopback device. */
        if (strncmp(ifa->ifa_name, "lo", 2)){
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            iBytes += if_data->ifi_ibytes;
            oBytes += if_data->ifi_obytes;
        }
    }
    freeifaddrs(ifa_list);
    return iBytes + oBytes;
}

+ (NSString *)formatNetWork:(long long int)rate {
    if (rate < 1024) return [NSString stringWithFormat:@"%lldB/秒", rate];
    else if (rate >=1024&& rate <1024*1024) {
        return [NSString stringWithFormat:@"%.1fKB/秒", (double)rate /1024];
    } else if (rate >=1024*1024&& rate <1024*1024*1024) {
        return [NSString stringWithFormat:@"%.2fMB/秒", (double)rate / (1024*1024)];
    } else return@"10Kb/秒";
}

@end
