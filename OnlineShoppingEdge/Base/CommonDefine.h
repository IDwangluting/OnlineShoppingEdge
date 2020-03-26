//
//  CommonDefine.h
//  OnlineShoppingEdge
//
//  Created by luting on 20/2/9.
//  Copyright © 2020 luting. All rights reserved.
//

#ifndef CommonDefine_h
#define CommonDefine_h

#define isIpad              [[UIDevice currentDevice].model containsString:@"iPad"]
#define isIphone            [[UIDevice currentDevice].model containsString:@"iphone"]
#define isIPodTouch         [[UIDevice currentDevice].model containsString:@"iPod touch"]

#define AppId               @"1497669870"
#define AppInfoUrl          [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",AppId]
#define AppUpdateUrl        [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8",AppId]
#define TestflightUrl       @"https://testflight.apple.com/join/QsLkbB3d"

#define QQGroupKey          @"b4405d01b954d4a9d85258514bc6a8331151afc11fa627533d4541359bc85bd7"
#define QQGroupUrl          @"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external"

#define FacebackCenterUrl   [NSString stringWithFormat:QQGroupUrl,@"607385329",QQGroupKey]
#define ContectUsUrl        [NSString stringWithFormat:QQGroupUrl,@"877106454",QQGroupKey]

#endif /* CommonDefine_h */
