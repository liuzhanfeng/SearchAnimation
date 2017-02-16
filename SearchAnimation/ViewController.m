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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SearchAnimationView *view = [[SearchAnimationView alloc] initWithFrame:CGRectMake(50, 100, 100, 100)];
    [self.view addSubview:view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
