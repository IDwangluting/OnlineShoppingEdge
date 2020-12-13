//
//  OSECanvas.m
//  OnlineShoppingEdge
//
//  Created by luting on 20/12/13.
//  Copyright © 2020 luting. All rights reserved.
//

#import "OSECanvas.h"
#import <YYCategories/UIView+YYAdd.h>

#define MarginLeftOrBottom 25
#define MarginTopOrRight   7
#define PointOut           MarginTopOrRight

@implementation OSECanvasData

+ (instancetype)canvasWithxAxis:(NSTimeInterval)xAxis yAxis:(NSTimeInterval)yAxis {
    OSECanvasData * canvasData = [OSECanvasData new];
    canvasData.xAxis = xAxis;
    canvasData.yAxis = yAxis;
    return canvasData;
}

@end

@implementation OSEBaseCanvasView

- (CGContextRef)drawSettingWithColor:(CGColorRef)color lineWidth:(CGFloat)lineWidth {
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ref, color);
    CGContextSetLineWidth(ref, lineWidth);
    return ref;
}

- (void)drawline:(CGContextRef)context points:(NSArray <NSValue *>*)p{
    CGPoint points[p.count];
    for (NSInteger index = 0; index < p.count; index++) {
        points[index] = p[index].CGPointValue;
    }
    CGContextAddLines(context, points, p.count);
    CGContextStrokePath(context);
}

- (NSValue *)valuePoint:(CGPoint)point {
    return [NSValue valueWithCGPoint:point];
}

@end

@implementation OSECanvasCoordinateSystemView {
    NSInteger _xAxisPointOutCount,_yAxisPointOutCount;
}

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    CGFloat height = self.height - MarginTopOrRight - 2 * MarginLeftOrBottom - 10 ;
    CGFloat width  = self.width  - MarginTopOrRight - MarginLeftOrBottom - 10 ;
    _yAxisPointOutCount = height / 50;
    _xAxisPointOutCount = width  / 50;
    self.yAxisValueSpan = height / _yAxisPointOutCount;
    self.xAxisValueSpan = width  / _xAxisPointOutCount;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = [self drawSettingWithColor:self.lineColor.CGColor lineWidth:1];
    
    CGFloat y = self.height - MarginLeftOrBottom;
    NSMutableArray * points = [NSMutableArray new];
    [points addObject:[self valuePoint:CGPointMake(MarginLeftOrBottom,MarginTopOrRight)]];
    [points addObject:[self valuePoint:CGPointMake(MarginLeftOrBottom,y)]];
    [points addObject:[self valuePoint:CGPointMake(MarginLeftOrBottom,y)]];
    [points addObject:[self valuePoint:CGPointMake(self.width - MarginTopOrRight,y)]];
    [self drawline:context points:points];

    for (NSInteger index = 1; index <= _yAxisPointOutCount; index++) {
        [self drawline:context points: @[[self valuePoint:CGPointMake(MarginLeftOrBottom,y - self.yAxisValueSpan * index)],
                                         [self valuePoint:CGPointMake(MarginLeftOrBottom + PointOut, y - self.yAxisValueSpan * index)]]];
    }
    
    for (NSInteger index = 1; index <= _xAxisPointOutCount; index++) {
        [self drawline:context points: @[[self valuePoint:CGPointMake(MarginLeftOrBottom + self.xAxisValueSpan * index, y)],
                                         [self valuePoint:CGPointMake(MarginLeftOrBottom + self.xAxisValueSpan * index, y - PointOut)]]];
    }
}

@end

@interface OSECanvasView()

@property (nonatomic,strong)NSArray <OSECanvasData *>* datas;

@end

@implementation OSECanvasView

- (void)drawRect:(CGRect)rect {
    CGContextRef context = [self drawSettingWithColor:self.lineColor.CGColor lineWidth:1];
    
    CGFloat xSpan = self.width  / (self.maxXAxis - self.minXAxis) ;
    CGFloat ySpan = (self.height - 20) / self.maxYAxis;
    NSMutableArray *points = [NSMutableArray new];
    for (OSECanvasData * canvasData in _datas) {
        NSInteger pointX = (canvasData.xAxis - self.minXAxis) * xSpan;
        NSInteger pointY = (canvasData.yAxis - self.minYAxis) * ySpan;
        CGPoint point = CGPointMake(pointX,pointY);
        [points addObject:[self valuePoint:point]];
    }
    
    [self drawline:context points:points];
}

@end


@interface OSECanvas ()

@property (nonatomic,strong)OSECanvasCoordinateSystemView * coordinateSystemView;
@property (nonatomic,strong)NSArray<OSECanvasData *> * _Nullable canvasDatas ;

@end

@implementation OSECanvas {
    UIView * _backgroudView;
}
@synthesize canvasView = _canvasView;

- (instancetype)initWithDatas:(NSArray<OSECanvasData *> * _Nullable )datas {
    if (self = [super init]) {
        _backgroudView = [[UIView alloc]init];
        _backgroudView.backgroundColor = UIColor.whiteColor;
        [self coordinateSystemView];
        [self canvasView];
        self.canvasDatas = datas;
    }
    return self;
}

- (OSECanvasCoordinateSystemView *)coordinateSystemView {
    if (!_coordinateSystemView) {
        _coordinateSystemView = [[OSECanvasCoordinateSystemView alloc]init];
        _coordinateSystemView.backgroundColor = [UIColor.blueColor colorWithAlphaComponent:0.5] ;
        _coordinateSystemView.lineColor = [UIColor.darkTextColor colorWithAlphaComponent:0.3] ;
    }
    return _coordinateSystemView;
}

- (OSECanvasView *)canvasView {
    if (!_canvasView) {
        _canvasView = [[OSECanvasView alloc]init];
        _canvasView.lineColor = [UIColor.redColor colorWithAlphaComponent:0.8] ;
        _canvasView.backgroundColor = UIColor.clearColor;
    }
    return _canvasView;
}

- (void)setCanvasDatas:(NSArray<OSECanvasData *> *)canvasDatas {
    _canvasDatas = canvasDatas;
    [self prepare:canvasDatas];
}

- (void)prepare:(NSArray<OSECanvasData *> *)canvasDatas {
    OSECanvasData * defaultData = canvasDatas[0];
    _coordinateSystemView.maxYAxis = defaultData.yAxis;
    _coordinateSystemView.minYAxis = defaultData.yAxis;
    _coordinateSystemView.maxXAxis = defaultData.xAxis;
    _coordinateSystemView.minXAxis = defaultData.xAxis;
    
    for (OSECanvasData * data in canvasDatas) {
        _coordinateSystemView.maxYAxis = MAX(data.yAxis, _coordinateSystemView.maxYAxis);
        _coordinateSystemView.maxXAxis = MAX(data.xAxis, _coordinateSystemView.maxXAxis);
        _coordinateSystemView.minYAxis = MIN(data.yAxis, _coordinateSystemView.minYAxis);
        _coordinateSystemView.minXAxis = MIN(data.xAxis, _coordinateSystemView.minXAxis);
    }
    
    _canvasView.minXAxis = _coordinateSystemView.minXAxis;
    _canvasView.maxXAxis = _coordinateSystemView.maxXAxis;
    _canvasView.maxYAxis = _coordinateSystemView.maxYAxis;
    _canvasView.minYAxis = _coordinateSystemView.minYAxis;
    _canvasView.datas    = canvasDatas;
}

- (void)canvasViewAddTo:(UIView *)view {
    [view addSubview:_backgroudView];
    [view addSubview:_coordinateSystemView];
    [_coordinateSystemView addSubview:_canvasView];
}

- (void)setcCanvasViewFrame:(CGRect)frame {
    _backgroudView.frame = frame;
    self.coordinateSystemView.frame = frame;
    self.canvasView.frame = CGRectMake(MarginLeftOrBottom, MarginLeftOrBottom,
                                       CGRectGetWidth(frame)  - MarginLeftOrBottom - MarginTopOrRight ,
                                       CGRectGetHeight(frame) -  2 * MarginLeftOrBottom);
    self.canvasView.xAxisValueSpan = self.coordinateSystemView.xAxisValueSpan;
    self.canvasView.yAxisValueSpan = self.coordinateSystemView.yAxisValueSpan;
}

@end
