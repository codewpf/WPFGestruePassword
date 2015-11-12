//
//  GPassWordVC.m
//  two
//
//  Created by wpf on 15/11/11.
//  Copyright © 2015年 wpf. All rights reserved.
//

#import "GPassWordVC.h"

@implementation GPassWordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    
    
    GPView *gp = [[GPView alloc]init];
    [gp buttonBlock:^(NSInteger tag) {
        if(tag == 0)
        {
            NSLog(@"跳过");
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if(tag == 1)
        {
            NSLog(@"放弃修改");
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if(tag == 2)
        {
            NSLog(@"忘记手势密码");
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }];
    [gp result:^(BOOL result, GPType type) {
        if(type == GP_New)
        {
            NSLog(@"设置通过");
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if(type == GP_Update)
        {
            NSLog(@"更新完成");
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if(type == GP_Ver)
        {
            NSLog(@"手势密码验证完成");
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }];
    [gp setType:self.type];
    [self.view addSubview:gp];
    
    
    WS(weakSelf);
    [gp makeConstraints:^(MASConstraintMaker *make) {
        NSInteger offset = 0;
        if(weakSelf.type != GP_Ver) offset = 64;
        make.center.centerOffset(CGPointMake(0, offset));
        make.width.equalTo(GPSIDE);
        make.height.equalTo(GPSIDE+GPBUTTONWIDTH*2+GPBUTTONSPACE);
    }];
    
}
@end
