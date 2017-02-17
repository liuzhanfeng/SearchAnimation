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
static const CGFloat backgroundLayer_W = 25;//外圈放大镜大小
static const CGFloat insideLayerSize = 10;//内圈小放大镜大小
static const CGFloat lineW = 5;
static const NSTimeInterval animationTimer = 0.3;//动画时长
static const CGFloat max_w = 200;//搜索框拉升长度


//放大镜手柄size
static const CGFloat big_handle_w = 8;
static const CGFloat big_handle_h = 3;

static const CGFloat min_handle_w = 3;
static const CGFloat min_handle_h = 1.5;

@interface SearchAnimationView()
{
    UIColor *basicColor;
    BOOL spread;//是否是展开的
    CGPoint originPoint;
    CGFloat originWidth;//原始长度
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"点击搜索按钮");
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickSearchAction:)]) {
        [self.delegate clickSearchAction:self];
    }
}

-(void)setupView{
    self.backgroundColor = [UIColor orangeColor];
    spread = NO;
    originWidth = self.frame.size.width;
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
        glass.borderWidth = 1.5;
        glass.borderColor = self.backgroundColor.CGColor;
        glass.cornerRadius = insideLayerSize/2;
        glass.position = CGPointMake(backgroundLayer_W/2, backgroundLayer_W/2);
        [_backgroundLayer addSublayer:glass];
        
        CALayer *handle = [[CALayer alloc] init];
        handle.bounds = CGRectMake(0, 0, min_handle_w, min_handle_h);
        handle.position = CGPointMake(glass.position.x + insideLayerSize/2,glass.position.x + insideLayerSize/2);
        CGAffineTransform transform= CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(45));
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
        _roundLayer.bounds = CGRectMake(0, 0, backgroundLayer_W - lineW, backgroundLayer_W - lineW);
        _roundLayer.cornerRadius = (backgroundLayer_W - lineW)/2;
        _roundLayer.backgroundColor = self.backgroundColor.CGColor;
        _roundLayer.position = CGPointMake(backgroundLayer_W/2, backgroundLayer_W/2);
    }
    return _roundLayer;
}

-(CALayer *)handleLayer{
    if (!_handleLayer) {
        CGFloat w = 11;
        _handleLayer = [[CALayer alloc] init];
        _handleLayer.backgroundColor = basicColor.CGColor;
        _handleLayer.bounds = CGRectMake(0, 0, big_handle_w, big_handle_h);
        CGAffineTransform transform= CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(45));
        _handleLayer.affineTransform = transform;
        _handleLayer.position = CGPointMake(self.backgroundLayer.position.x + backgroundLayer_W/2 +w, self.backgroundLayer.position.y + backgroundLayer_W/2);
        
        originPoint = _handleLayer.position;
    }
    return _handleLayer;
}

-(void)startAnimation{
    spread = !spread;
    [self spreadAnimation];
    [self bigHandleAnimation];
    CGRect frame = self.frame;
    frame.size.width = spread?max_w+backgroundLayer_W:originWidth;
    [UIView animateWithDuration:animationTimer animations:^{
        self.frame = frame;
    }];

}

-(void)spreadAnimation{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    animation.duration = animationTimer;
    animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, spread?max_w:backgroundLayer_W,backgroundLayer_W)];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.backgroundLayer addAnimation:animation forKey:nil];
}

-(void)bigHandleAnimation{
    CAAnimationGroup *round = [CAAnimationGroup animation];
    round.duration = animationTimer;
    round.animations = @[[self roundAnimation],[self roundCornerRadius]];
    round.fillMode = kCAFillModeForwards;
    round.removedOnCompletion = NO;
    [self.roundLayer addAnimation:round forKey:nil];
    
    CAAnimationGroup *handle = [CAAnimationGroup animation];
    handle.duration = animationTimer;
    handle.fillMode = kCAFillModeForwards;
    handle.removedOnCompletion = NO;
    handle.animations = @[[self handlePositionBounds],[self handlePosition],[self handleOpacity]];
    [self.handleLayer addAnimation:handle forKey:nil];
    
}

-(CABasicAnimation *)roundAnimation{
    CABasicAnimation *round = [CABasicAnimation animationWithKeyPath:@"bounds"];
    round.toValue = [NSValue valueWithCGRect:spread?CGRectMake(0, 0, 0, 0):CGRectMake(0, 0, backgroundLayer_W - lineW, backgroundLayer_W - lineW)];
    round.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return round;
}

-(CABasicAnimation *)roundCornerRadius{
    CABasicAnimation *a = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    a.toValue = spread?@(0):@((backgroundLayer_W - lineW)/2);
    return a;
}

-(CABasicAnimation *)handleOpacity{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.toValue = spread?@(0):@(1.0);
    return animation;
}


//位移
-(CABasicAnimation *)handlePosition{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.toValue = [NSValue valueWithCGPoint:spread?CGPointMake(CGRectGetMaxX(self.backgroundLayer.frame), self.frame.size.height/2):originPoint];
    return animation;
}

//size
-(CABasicAnimation *)handlePositionBounds{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    animation.toValue = [NSValue valueWithCGRect:spread?CGRectMake(0, 0, 0, big_handle_h):CGRectMake(0, 0, big_handle_w, big_handle_h)];
    return animation;

}


@end
