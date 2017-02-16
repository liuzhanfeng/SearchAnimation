//
//  SearchAnimationView.h
//  SearchAnimation
//
//  Created by LZF on 2017/2/16.
//  Copyright © 2017年 zf.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchAnimationView;

@protocol SearchAnimationViewDelegate <NSObject>

@optional
-(void)clickSearchAction:(SearchAnimationView *)searchButton;

@end


@interface SearchAnimationView : UIView
@property (nonatomic , assign)id<SearchAnimationViewDelegate> delegate;
-(void)startAnimation;
@end
