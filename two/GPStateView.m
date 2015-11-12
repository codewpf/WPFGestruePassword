//
//  GPStateView.m
//  GesturesPassword
//
//  Created by wpf on 15/11/10.
//  Copyright © 2015年 wpf. All rights reserved.
//

#import "GPStateView.h"

@interface GPStateView ()

@property (nonatomic, strong) NSMutableArray *cicleViews;

@end

@implementation GPStateView
- (id)init
{
    if(self = [super init])
    {
        _cicleViews = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < 9; i++)
        {
            NSInteger row = i/3;
            NSInteger column = i%3;
            CGFloat pointW = GPBUTTONWIDTH/5.0f;

            UIImageView *point = [[UIImageView alloc]init];
            point.layer.cornerRadius = pointW/2;
            point.layer.borderColor = [UIColor whiteColor].CGColor;
            point.layer.borderWidth = 1.0f;
            point.backgroundColor = [UIColor clearColor];
            [self addSubview:point];
            
            [point makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(column*pointW*2);
                make.top.equalTo(row*pointW*2);
                make.width.equalTo(pointW);
                make.height.equalTo(pointW);
            }];
            
            [_cicleViews addObject:point];
        }
    }
    
    return self;
}

#pragma mark - setters
- (void)setPassword:(NSString *)password
{
    if (![_password isEqualToString:password]) {
        
        _password = [password copy];
        
        for (NSInteger i = 0; i < password.length; i++) {
            NSRange range;
            range.location = i;
            range.length = 1;
            NSString *pass = [password substringWithRange:range];
            
            NSInteger passValue = pass.integerValue;
            UIImageView *point = [self.cicleViews objectAtIndex:passValue];
            point.backgroundColor = [UIColor whiteColor]; //选中时点的颜色
        }
    }
    

}


#pragma mark - object methods
- (void)reset
{
    for (UIImageView *point in self.cicleViews) {
        point.backgroundColor = [UIColor clearColor];
    }
}

@end
