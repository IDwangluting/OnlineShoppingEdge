//
//  OSECanvas.h
//  OnlineShoppingEdge
//
//  Created by luting on 20/12/13.
//  Copyright © 2020 luting. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OSECanvasData : NSObject

@property (nonatomic,assign) NSTimeInterval xAxis;
@property (nonatomic,assign) NSTimeInterval yAxis;

+ (instancetype)canvasWithxAxis:(NSTimeInterval)xAxis yAxis:(NSTimeInterval)yAxis;

@end

@interface OSEBaseCanvasView : UIView

@property (nonatomic,strong)UIColor *lineColor;

@property (nonatomic,assign)NSInteger yAxisValueSpan;
@property (nonatomic,assign)NSInteger xAxisValueSpan;

@property (nonatomic,assign)NSTimeInterval minXAxis;
@property (nonatomic,assign)NSTimeInterval maxXAxis;
@property (nonatomic,assign)NSTimeInterval minYAxis;
@property (nonatomic,assign)NSTimeInterval maxYAxis;

- (CGContextRef)drawSettingWithColor:(CGColorRef)color lineWidth:(CGFloat)lineWidth;

- (void)drawline:(CGContextRef)context points:(NSArray <NSValue *>*)points;

@end

@interface OSECanvasCoordinateSystemView : OSEBaseCanvasView

@end

@interface OSECanvasView : OSEBaseCanvasView

@end

@interface OSECanvas : NSObject

@property(nonatomic,strong,readonly)OSECanvasView * canvasView;

+ (instancetype)new API_UNAVAILABLE(ios);

- (instancetype)init API_UNAVAILABLE(ios);

- (instancetype)initWithDatas:(NSArray<OSECanvasData *> * _Nullable )datas NS_DESIGNATED_INITIALIZER;

- (void)canvasViewAddTo:(UIView *)view;

- (void)setcCanvasViewFrame:(CGRect)frame;

@end
NS_ASSUME_NONNULL_END
