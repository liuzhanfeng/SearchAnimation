//
//  SearchAnimationView.m
//  SearchAnimation
//
//  Created by LZF on 2017/2/16.
//  Copyright © 2017年 zf.com. All rights reserved.
//

#import "SearchAnimationView.h"
#import <math.h>

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

/**可以自定义常量**/
static const CGFloat backgroundLayer_W = 15;//外圈放大镜大小
static const CGFloat insideLayerSize = 7;//内圈小放大镜大小
static const CGFloat outSideLine_w = 2;//外圈大放大镜线宽
static const CGFloat insideLine_w = 1.5;//内圈小放大镜线宽

static const NSTimeInterval animationTimer = 0.3;//动画时长
static const CGFloat max_w = 200;//搜索框拉升长度



@interface SearchAnimationView()
{
    UIColor *basicColor;
    BOOL spread;//是否是展开的
    CGPoint originPoint;
    CGFloat originWidth;//原始长度
    
    CALayer *smallGlass;
    CALayer *smallHandle;
    
    //大小手柄长度
    CGFloat big_handle;
    CGFloat small_handle;
}
@property (nonatomic , strong)CALayer *backgroundLayer;
@property (nonatomic , strong)CALayer *handleLayer;
@property (nonatomic , strong)CALayer *roundLayer;
@property (nonatomic , strong)CATextLayer *textLayer;

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
        
        smallGlass = [[CALayer alloc] init];
        smallGlass.bounds = CGRectMake(0, 0, insideLayerSize, insideLayerSize);
        smallGlass.borderWidth = insideLine_w;
        smallGlass.borderColor = self.backgroundColor.CGColor;
        smallGlass.cornerRadius = insideLayerSize/2;
        smallGlass.position = CGPointMake(_backgroundLayer.position.x*2,_backgroundLayer.position.y);
        [_backgroundLayer addSublayer:smallGlass];
        
        CGFloat handle_w = (sqrt(insideLayerSize*insideLayerSize + insideLayerSize *insideLayerSize) - insideLayerSize);
        small_handle = handle_w;
        
        smallHandle = [[CALayer alloc] init];
        smallHandle.bounds = CGRectMake(0, 0, handle_w, insideLine_w);
        smallHandle.position = CGPointMake(smallGlass.position.x + insideLayerSize/2,smallGlass.position.x + insideLayerSize/2);
        CGAffineTransform transform= CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(45));
        smallHandle.backgroundColor = self.backgroundColor.CGColor;
        smallHandle.affineTransform = transform;
        [_backgroundLayer addSublayer:smallHandle];
        
        [_backgroundLayer addSublayer:self.roundLayer];
    }
    return _backgroundLayer;

}

-(CATextLayer *)textLayer{
    
    if (!_textLayer) {
        CATextLayer *lary = [CATextLayer layer];
        lary.string = @"点击进入搜索";
        lary.bounds = CGRectMake(0, 0, max_w, backgroundLayer_W);
        //字体的名字 不是 UIFont
        lary.fontSize = 11.f;
        //字体的大小
        lary.alignmentMode = kCAAlignmentCenter;//字体的对齐方式
        lary.position = CGPointMake(max_w/2, backgroundLayer_W);
        lary.foregroundColor =
        [UIColor blackColor].CGColor;//字体的颜色
        _textLayer = lary;
    }
    return  _textLayer;
}


-(CALayer *)roundLayer{
    if (!_roundLayer) {
        _roundLayer = [[CALayer alloc] init];
        _roundLayer.bounds = CGRectMake(0, 0, backgroundLayer_W - outSideLine_w, backgroundLayer_W - outSideLine_w);
        _roundLayer.cornerRadius = (backgroundLayer_W - outSideLine_w)/2;
        _roundLayer.backgroundColor = self.backgroundColor.CGColor;
        _roundLayer.position = CGPointMake(backgroundLayer_W/2, backgroundLayer_W/2);
    }
    return _roundLayer;
}

-(CALayer *)handleLayer{
    if (!_handleLayer) {
        
        CGFloat handle_w = (sqrt(backgroundLayer_W*backgroundLayer_W + backgroundLayer_W *backgroundLayer_W) - backgroundLayer_W);
        big_handle = handle_w;
        _handleLayer = [[CALayer alloc] init];
        _handleLayer.backgroundColor = basicColor.CGColor;
        _handleLayer.bounds = CGRectMake(0, 0, handle_w, outSideLine_w);
        CGAffineTransform transform= CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(45));
        _handleLayer.affineTransform = transform;
        _handleLayer.position = CGPointMake(self.backgroundLayer.position.x + backgroundLayer_W, self.backgroundLayer.position.y + backgroundLayer_W/2);
        //记录开始坐标点
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
    animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, spread?max_w:backgroundLayer_W,spread?backgroundLayer_W*2:backgroundLayer_W)];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.backgroundLayer addAnimation:animation forKey:nil];
    
    CABasicAnimation *cornerRadius = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    cornerRadius.duration = animationTimer;
    cornerRadius.toValue = spread?@(backgroundLayer_W):@(backgroundLayer_W/2);
    cornerRadius.removedOnCompletion = NO;
    cornerRadius.fillMode = kCAFillModeForwards;
    [self.backgroundLayer addAnimation:cornerRadius forKey:nil];
    
    
    spread?[self.backgroundLayer addSublayer:self.textLayer]:[self.textLayer removeFromSuperlayer];
    

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
    

    
    [UIView  animateWithDuration:animationTimer animations:^{
        smallGlass.position = CGPointMake(backgroundLayer_W/2,spread?backgroundLayer_W:backgroundLayer_W/2);
        smallHandle.position = CGPointMake(smallGlass.position.x + insideLayerSize/2, smallGlass.position.y+insideLayerSize/2);
        self.roundLayer.position = CGPointMake(backgroundLayer_W/2, spread?backgroundLayer_W:backgroundLayer_W/2);

    }];
}



//-(CABasicAnimation *)smallGlassPosition{
//    CABasicAnimation *a = [CABasicAnimation animationWithKeyPath:@"position"];
//    a.toValue = [NSValue valueWithCGPoint:CGPointMake(self.backgroundLayer.position.x,spread?backgroundLayer_W:backgroundLayer_W/2)];
//    a.duration = animationTimer;
//    a.fillMode = kCAFillModeForwards;
//    a.removedOnCompletion = NO;
//    [smallGlass addAnimation:a forKey:nil];
//    return a;
//}
//
//-(CABasicAnimation *)smallHandlePosition{
//    CABasicAnimation *a = [CABasicAnimation animationWithKeyPath:@"position"];
//    a.toValue = [NSValue valueWithCGPoint:CGPointMake(smallGlass.position.x + insideLayerSize/2, smallGlass.position.y+insideLayerSize/2)];
//    a.duration = animationTimer;
//    a.fillMode = kCAFillModeForwards;
//    a.removedOnCompletion = NO;
//    [smallHandle addAnimation:a forKey:nil];
//    return a;
//}




-(CABasicAnimation *)roundAnimation{
    CABasicAnimation *round = [CABasicAnimation animationWithKeyPath:@"bounds"];
    round.toValue = [NSValue valueWithCGRect:spread?CGRectMake(0, 0, 0, 0):CGRectMake(0, 0, backgroundLayer_W - outSideLine_w, backgroundLayer_W - outSideLine_w)];
    round.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return round;
}

-(CABasicAnimation *)roundCornerRadius{
    CABasicAnimation *a = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    a.toValue = spread?@(0):@((backgroundLayer_W - outSideLine_w)/2);
    return a;
}

-(CABasicAnimation *)roundPosition{
    CABasicAnimation *a = [CABasicAnimation animationWithKeyPath:@"position"];
    a.toValue = spread?@(0):@((backgroundLayer_W - outSideLine_w)/2);
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
    animation.toValue = [NSValue valueWithCGRect:spread?CGRectMake(0, 0, 0, outSideLine_w):CGRectMake(0, 0, big_handle, outSideLine_w)];
    return animation;

}


@end
