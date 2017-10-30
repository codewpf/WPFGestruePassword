//
//  ViewController.m
//  two
//
//  Created by wpf on 15/11/10.
//  Copyright © 2015年 wpf. All rights reserved.
//

#import "ViewController.h"
#import "GPHeader.h"
#import "GPassWordVC.h"

@interface ViewController ()
{
    GPLineView *_tentacleView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"测试";
    
    for(NSInteger i=0;i<3;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-100)/2, 100+i*50, 100, 30);
        btn.layer.borderColor = [UIColor grayColor].CGColor;
        btn.layer.borderWidth = 0.5;
        btn.layer.cornerRadius = 5;
        [btn setTitle:@[@"新设置",@"修改",@"验证"][i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [self.view addSubview:btn];
        
    }
    
}

- (void)btnClick:(UIButton *)btn
{
    GPassWordVC *test = [[GPassWordVC alloc]init];
    test.type = (GPType)btn.tag;
    test.title = @[@"新设置",@"修改",@"验证"][btn.tag];
    if(btn.tag < 2)
        [self.navigationController pushViewController:test animated:YES];
    else
        [self presentViewController:test animated:YES completion:^{
            
        }];
}

@end
