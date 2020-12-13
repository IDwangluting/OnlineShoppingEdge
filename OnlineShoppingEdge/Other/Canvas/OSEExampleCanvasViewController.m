//
//  OSEExampleCanvasViewController.m
//  OnlineShoppingEdge
//
//  Created by luting on 20/12/13.
//  Copyright © 2020 luting. All rights reserved.
//

#import "OSEExampleCanvasViewController.h"
#import <YYCategories/NSDate+YYAdd.h>
#import <YYCategories/UIView+YYAdd.h>
#import "KGRNetworking.h"
#import "OSECanvas.h"

@interface OSEExampleCanvasViewController ()

@property (nonatomic,strong)OSECanvas *canvas;
@property (nonatomic,strong)NSArray * canvasDatas;

@end

@implementation OSEExampleCanvasViewController

- (instancetype)init {
    if (self = [super init]) {
        NSString * url = @"http://122.51.146.191/vv/dm/historynew.php?code=bf42c25e71e93ce96bbe9e3f23db93f99aa259ee9171641d4892037045eff94ee52a9b7962ce844d3f7c635a2a1b8b71b71ee788f5c711e0d6eaa8ce4077c9ba54a769cf104cebb38097d20503ef98769041fbdf7be70e3432b1de1ccf2c436049422b31b787f357a1c0ac4adbe53d6049ef71d41ce110d78d89896a6bf7fcc2850afddda307dd550628e95460b23b882f368047b2154afaf1a2d0964b4d9a8d81e22be801914a775d5806a7cd4a22b3452e0a15296d5ce50ea16f33bc164934220c4b0a3a7ebdf85246f48663c898f9bd233151e5af71d870259fb1eefa6aa7f471606e1e1ec5ed3955780c1d86b3142c642c724e13fc3c243e232b8bf7c5b3ee2a666d4f4ca47d7711e21bbe111b1bcddf02767498414e&t=&ud=WSVWDERWCJANRFIZACJ_HN_1607789919&reqid=ab0d495641ce5574d016f437396d8dea";
        [self historyPriceRequestWithURL:url];
    }
    return self;
}

- (void)requestWithURL:(NSString *)url {
    [[KGRNetworking manager] getRequest:url success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable result) {
        NSString *requestResult = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSMutableArray * canvasDatas = [NSMutableArray new];
        for (NSString * item in [requestResult componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[]"]]) {
            if ([item containsString:@"Date.UTC"]) {
                NSArray <NSString *>* tmps = [item componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()"]];
                if (tmps.count == 3) {
                    NSArray *dateArray = [tmps[1] componentsSeparatedByString:@","];
                    if (dateArray.count == 3) {
                        NSString *monthStr = [dateArray[1] intValue] < 10 ? [NSString stringWithFormat:@"0%@",dateArray[1]]:dateArray[1];
                        NSString *dayStr   = [dateArray[2] intValue] < 10 ? [NSString stringWithFormat:@"0%@",dateArray[2]]:dateArray[2];
                        NSString * dateStr = [NSString stringWithFormat:@"%@,%@,%@",dateArray[0],monthStr,dayStr];
                        NSDate  * date  = [NSDate dateWithString:dateStr format:@"yyyy,MM,dd"];
                        if (date.timeIntervalSince1970 > 10) {
                            NSArray <NSString *>* priceArray = [tmps[2] componentsSeparatedByString:@","];
                            CGFloat  yAxis = [priceArray[1] floatValue];
                            [canvasDatas addObject:[OSECanvasData canvasWithxAxis:date.timeIntervalSince1970 yAxis:yAxis]];
                        }
                    }
                }
            }
        }
        self.canvasDatas = [canvasDatas copy];
    } failure:nil];
}

- (void)setCanvasDatas:(NSArray *)canvasDatas {
    _canvasDatas = canvasDatas;
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.canvas = [[OSECanvas alloc]initWithDatas:canvasDatas];
            [self.canvas canvasViewAddTo:self.view];
        });
    }else {
        self.canvas = [[OSECanvas alloc]initWithDatas:canvasDatas];
        [self.canvas canvasViewAddTo:self.view];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat top    = self.navigationController.navigationBar.height + 20;
    CGFloat left   = 5;
    CGFloat height = self.view.width / 3 * 2;
    CGFloat width  = self.view.width  - left * 2;
    [self.canvas setcCanvasViewFrame:CGRectMake(left,top,width,height)];
}

@end
