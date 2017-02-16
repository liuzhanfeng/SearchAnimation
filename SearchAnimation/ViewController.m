//
//  ViewController.m
//  SearchAnimation
//
//  Created by LZF on 2017/2/16.
//  Copyright © 2017年 zf.com. All rights reserved.
//

#import "ViewController.h"
#import "SearchAnimationView.h"

@interface ViewController ()
{
    SearchAnimationView *view;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    view = [[SearchAnimationView alloc] initWithFrame:CGRectMake(20, 100, 300, 100)];
    [self.view addSubview:view];
    
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
