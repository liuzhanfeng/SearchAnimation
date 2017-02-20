//
//  SearchAnimationButton.h
//  SearchAnimation
//
//  Created by LZF on 2017/2/17.
//  Copyright © 2017年 zf.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchAnimationButton;

@protocol SearchAnimationButtonDelegate <NSObject>

@optional
-(void)clickSearchAction:(SearchAnimationButton *)searchButton;

@end

@interface SearchAnimationButton : UIView
@property (nonatomic , assign)id<SearchAnimationButtonDelegate> delegate;
//展开 | 关闭 动画方法
-(void)startAnimation;
@end
