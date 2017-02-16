//
//  SearchAnimationView.m
//  SearchAnimation
//
//  Created by LZF on 2017/2/16.
//  Copyright © 2017年 zf.com. All rights reserved.
//

#import "SearchAnimationView.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
/**可以自定义常量**/
static const CGFloat backgroundLayer_W = 50;//放大镜大小
static const CGFloat insideLayerSize = 20;//小放大镜大小
static const CGFloat lineW = 2.5;
//static const NSTimeInterval animationTimer = 2;//动画时长

//放大镜手柄size
static const CGFloat big_handle_w = 25;
static const CGFloat big_handle_h = 5;

static const CGFloat min_handle_w = 7;
static const CGFloat min_handle_h = 3;

@interface SearchAnimationView()
{
    UIColor *basicColor;
}
@property (nonatomic , strong)CALayer *backgroundLayer;
@property (nonatomic , strong)CALayer *handleLayer;
@property (nonatomic , strong)CALayer *roundLayer;

@end

@implementation SearchAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    self.backgroundColor = [UIColor blueColor];
    basicColor = [UIColor whiteColor];
    [self.layer addSublayer:self.backgroundLayer];
    [self.layer addSublayer:self.handleLayer];
    
}

-(CALayer *)backgroundLayer{
    if (!_backgroundLayer) {
        _backgroundLayer = [[CALayer alloc] init];
        _backgroundLayer.backgroundColor = [UIColor whiteColor].CGColor;
        _backgroundLayer.anchorPoint = CGPointMake(0, 0.5);
        _backgroundLayer.bounds = CGRectMake(0, 0, backgroundLayer_W, backgroundLayer_W);
        _backgroundLayer.position = CGPointMake(backgroundLayer_W/2, self.frame.size.height/2);
        _backgroundLayer.cornerRadius = backgroundLayer_W/2;
        
        CALayer *glass = [[CALayer alloc] init];
        glass.bounds = CGRectMake(0, 0, insideLayerSize, insideLayerSize);
        glass.borderWidth = lineW;
        glass.borderColor = self.backgroundColor.CGColor;
        glass.cornerRadius = insideLayerSize/2;
        glass.position = CGPointMake(backgroundLayer_W/2, backgroundLayer_W/2);
        [_backgroundLayer addSublayer:glass];
        
        CALayer *handle = [[CALayer alloc] init];
        handle.bounds = CGRectMake(0, 0, min_handle_w, min_handle_h);
        handle.position = CGPointMake(backgroundLayer_W/4+min_handle_h, CGRectGetMaxY(glass.frame)+min_handle_h);
        CGAffineTransform transform= CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-45));
        handle.backgroundColor = self.backgroundColor.CGColor;
        handle.affineTransform = transform;
        [_backgroundLayer addSublayer:handle];
        
        [_backgroundLayer addSublayer:self.roundLayer];

        
    }
    return _backgroundLayer;

}

-(CALayer *)roundLayer{
    if (!_roundLayer) {
        _roundLayer = [[CALayer alloc] init];
        _roundLayer.bounds = CGRectMake(0, 0, 0, 0);
        _roundLayer.backgroundColor = self.backgroundColor.CGColor;
        _roundLayer.hidden = YES;
        _roundLayer.position = CGPointMake(backgroundLayer_W/2, backgroundLayer_W/2);
    }
    return _roundLayer;
}

-(CALayer *)handleLayer{
    if (!_handleLayer) {
        _handleLayer = [[CALayer alloc] init];
        _handleLayer.backgroundColor = basicColor.CGColor;
        _handleLayer.bounds = CGRectMake(0, 0, big_handle_w, big_handle_h);
        CGAffineTransform transform= CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-45));
        _handleLayer.affineTransform = transform;
        _handleLayer.position = CGPointMake(backgroundLayer_W/2 - 5, CGRectGetMaxY(self.backgroundLayer.frame)+5);
    }
    return _handleLayer;
}



@end
