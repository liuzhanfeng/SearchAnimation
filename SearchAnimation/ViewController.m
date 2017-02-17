//
//  ViewController.m
//  SearchAnimation
//
//  Created by LZF on 2017/2/16.
//  Copyright © 2017年 zf.com. All rights reserved.
//

#import "ViewController.h"
#import "SearchAnimationView.h"
#import "SearchAnimationButton.h"

@interface ViewController ()
{
    SearchAnimationButton *view;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =[UIColor orangeColor];
    view = [[SearchAnimationButton alloc] initWithFrame:CGRectMake(0, 20, 50, 44)];//模拟导航条的大小
    [self.view addSubview:view];

    
//    view = [[SearchAnimationView alloc] initWithFrame:CGRectMake(0, 20, 50, 44)];//模拟导航条的大小
//    [self.view addSubview:view];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [view startAnimation];
//    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)btn:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    button.selected = !button.selected;
    
    [view startAnimation];
    
}

@end
