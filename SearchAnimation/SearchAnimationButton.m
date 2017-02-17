//
//  SearchAnimationButton.m
//  SearchAnimation
//
//  Created by LZF on 2017/2/17.
//  Copyright © 2017年 zf.com. All rights reserved.
//

#import "SearchAnimationButton.h"

static const CGFloat searchText_H = 30;//搜索框大小
static const CGFloat search_h = 15;//原始图标大小

static const CGFloat max_w = 200;//搜索框拉升长度
static const NSTimeInterval animationTimer = 0.3;//动画时长


@interface SearchAnimationButton()
{
    BOOL spread;//是否是展开的

}
@property (nonatomic , strong) UIButton *searchButton;
@property (nonatomic , strong) UIButton *searchTextButton;
@end

@implementation SearchAnimationButton

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
    self.backgroundColor = [UIColor clearColor];
    spread = NO;
    [self addSubview:self.searchButton];
    [self addSubview:self.searchTextButton];
}

-(UIButton *)searchButton{
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
        [_searchButton setBounds:CGRectMake(10, 0, search_h, search_h)];
        _searchButton.center = CGPointMake(15, self.frame.size.height/2);
        [_searchButton addTarget:self action:@selector(clickSearch) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _searchButton;
}

-(UIButton *)searchTextButton{
    if (!_searchTextButton) {
        _searchTextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchTextButton.backgroundColor = [UIColor whiteColor];
        _searchTextButton.bounds = CGRectMake(0, 0, searchText_H, searchText_H);
        _searchTextButton.center = CGPointMake(self.searchButton.center.x - searchText_H/2, self.searchButton.center.y);
        _searchTextButton.layer.cornerRadius = searchText_H/2;
        _searchTextButton.hidden = YES;
        _searchTextButton.layer.anchorPoint = CGPointMake(0, 0.5);
        [_searchTextButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_searchTextButton addTarget:self action:@selector(clickTextField) forControlEvents:UIControlEventTouchUpInside];
//        UIImage *image = [UIImage imageNamed:@"yuan"];
//        CGFloat top = 0; // 顶端盖高度
//        CGFloat bottom = 0 ; // 底端盖高度
//        CGFloat left = image.size.width/2 - 1; // 左端盖宽度
//        CGFloat right = -(image.size.width/2 - 1); // 右端盖宽度
//        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        // 指定为拉伸模式，伸缩后重新赋值
//        image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
//        [_searchTextButton setBackgroundImage:image forState:UIControlStateNormal];
        
    }
    return _searchTextButton;
}

-(void)searchTextButton_big:(CALayer *)layer{
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        [layer setValue:[NSValue valueWithCGRect:CGRectMake(0, 0, searchText_H + 5, searchText_H +5)] forKey:@"bounds"];
        [self sendSubviewToBack:self.searchTextButton];
        [self.searchButton setImage:[UIImage imageNamed:@"small_search"] forState:UIControlStateNormal];
        self.searchTextButton.hidden = NO;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            [layer setValue:[NSValue valueWithCGRect:CGRectMake(0, 0, searchText_H, searchText_H)] forKey:@"bounds"];
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                [layer setValue:[NSValue valueWithCGRect:CGRectMake(0, 0, max_w, searchText_H)] forKey:@"bounds"];
                CGRect rect = self.frame;
                rect.size.width = max_w +  50;
                self.frame = rect;

                //显示内圈放大镜
//                [self.searchTextButton setImage:[UIImage imageNamed:@"small_search"] forState:UIControlStateNormal];
//                [self.searchTextButton setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, max_w - 26)];
                
                [self.searchTextButton setTitle:@"请输入搜索内容" forState:UIControlStateNormal];
                [self.searchTextButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                self.searchTextButton.titleLabel.font = [UIFont systemFontOfSize:12];
                

                
            } completion:nil];
        }];
    }];

}


-(void)searchTextButton_small:(CALayer *)layer{
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        [layer setValue:[NSValue valueWithCGRect:CGRectMake(0, 0, searchText_H, searchText_H)] forKey:@"bounds"];
        CGRect rect = self.frame;
        rect.size.width = 50;
        self.frame = rect;
        [self.searchTextButton setTitle:nil forState:UIControlStateNormal];

    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            [layer setValue:[NSValue valueWithCGRect:CGRectZero] forKey:@"bounds"];
            [self.searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
            self.searchButton.hidden = NO;
        } completion:^(BOOL finished) {
            self.searchTextButton.hidden = YES;
//            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
//                [layer setValue:[NSValue valueWithCGRect:CGRectMake(0, 0, max_w, searchText_H)] forKey:@"bounds"];
//            } completion:nil];
        }];
    }];

}

-(void)clickTextField{
    [self searchTextButton_small:self.searchTextButton.layer];
    spread = NO;
}

-(void)clickSearch{
    [self searchTextButton_big:self.searchTextButton.layer];
    spread = YES;
    NSLog(@"点击搜索按钮");
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickSearch:)]) {
        [self.delegate clickSearchAction:self];
    }

}


-(void)startAnimation{
    if (spread) {
        [self searchTextButton_small:self.searchTextButton.layer];
    }else{
        [self searchTextButton_big:self.searchTextButton.layer];
    }
    spread = !spread;
}


@end
