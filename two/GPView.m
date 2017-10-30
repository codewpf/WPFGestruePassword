//
//  GPView.m
//  two
//
//  Created by wpf on 15/11/11.
//  Copyright © 2015年 wpf. All rights reserved.
//

#import "GPView.h"
#import <CommonCrypto/CommonDigest.h>


@interface GPView ()
{
    ResultBlock  _saveBlock;
    ButtonBlock  _btnBlock;
    NSTimer     *_tempTimer;
}
@property (nonatomic, strong) GPStateView    *state;
@property (nonatomic, strong) UILabel        *label;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) GPLineView     *line;
@property (nonatomic, strong) UIButton       *button;

/**
 * 新手势密码，开始为空字符串 第一次输入,如果第二次错误则清空
 */
@property (nonatomic, copy)   NSString       *first;
/**
 * 验证密码输入错误次数，最多5次 超过五次之后要停30秒才能重新开始输入
 */
@property (nonatomic, assign) NSInteger       failNumber;
/**
 * 验证密码超过5次之后 30秒时间数
 */
@property (nonatomic, assign) NSInteger       timerCount;

@end

@implementation GPView

- (instancetype)init
{
    if(self = [super init])
    {
        
        
//        self.backgroundColor = [UIColor greenColor];
        self.first = @"";
        self.failNumber = 5;
        self.timerCount = 30;
        
        WS(weakSelf);
        [self.state makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.and.top.equalTo(weakSelf);
            make.width.and.height.equalTo(GPBUTTONWIDTH);
        }];
        
        [self.label makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.state.bottom);
            make.left.and.right.equalTo(0);
            make.height.equalTo(GPBUTTONSPACE);
        }];
        
        // buttons 在selfline中添加了
        
        [self.line makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.label.bottom);
            make.left.equalTo(0);
            make.width.and.height.equalTo(GPSIDE);
        }];
        
        [self.button makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.line.bottom);
            make.centerX.equalTo(weakSelf);
            make.width.equalTo(GPSIDE/2);
            make.height.equalTo(GPBUTTONWIDTH);
        }];
 
        
        
    }
    return self;
}






#pragma mark - PublicMethods
- (BOOL)hasPassword
{
    NSString *password = [self objectForKey:GPWD];
    if(password && [password isKindOfClass:[NSString class]] && password.length == CC_MD5_DIGEST_LENGTH*2)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
- (void)result:(ResultBlock)result
{
    _saveBlock = [result copy];
}
- (void)buttonBlock:(ButtonBlock)button
{
    _btnBlock = [button copy];
}



#pragma mark - PrivateMethods
- (void)setType:(GPType)type
{
    _type = type;
    [self setLabelText:_type];
}

- (void)buttonAction
{
    if(_btnBlock) _btnBlock((NSInteger)self.type);
}
- (void)timerAction:(NSTimer *)timer
{
    self.timerCount -- ;
    if(self.timerCount == 0)
    {
        [timer invalidate];
        timer = nil;
        self.line.userInteractionEnabled = YES;
        self.label.text = @"请验证手势密码";
        return;
    }
    self.label.text = [NSString stringWithFormat:@"密码有误，请您%ld秒后再试",self.timerCount];
    
}

- (void)setLabelText:(GPType)type
{
    switch(self.type)
    {
        case GP_New:
        {
            _label.text = @"请绘制手势密码";
            [self.button setTitle:@"跳过" forState:UIControlStateNormal];
        }break;
        case GP_Update:
        {
            _label.text = @"验证成功，请绘制新手势密码";
            [self.button setTitle:@"放弃修改" forState:UIControlStateNormal];
        }break;
        case GP_Ver:
        {
            _label.text = @"请输入手势密码";
            [self.button setTitle:@"忘记手势密码" forState:UIControlStateNormal];
        }break;
    }
    
}
- (void)popView
{
    if(_tempTimer)
    {
        [_tempTimer invalidate];
        _tempTimer = nil;
    }
    
    
    
    
}



#pragma mark - GPLineViewDelegate
- (void)gestureTochEnd:(NSString *)password result:(void (^)(BOOL result))result
{
    switch(self.type)
    {
        case GP_New:
        case GP_Update:
        {
            if(password.length<5)
            {
                self.label.text = @"手势密码长度必须大于4位";
                [self.line enterAgain];
                [self.state reset];
                if(result) result(NO);
                
                return;
            }
            
            if(self.first.length == 0)
            {
                self.label.text = @"请验证手势密码";
                [self.line enterAgain];
                self.first = password;
                [self.button setHidden:YES];
                if(result) result(YES);
            }
            else
            {
                if([password isEqualToString:self.first])
                {
                    [self setObject:[self md5:password] forKey:GPWD];
                    if(result) result(YES);
                    if(_saveBlock) _saveBlock(YES, self.type);
                    [self popView];
                    
                }
                else
                {
                    self.label.text = @"两次密码不一致，请重新验证";
                    
                    [self.line enterAgain];
                    [self.state reset];

                    if(result) result(NO);
                }
            }
            
            
        }break;
        case GP_Ver:
        {
            NSString *old = [self objectForKey:GPWD];
            if([old isEqualToString:[self md5:password]])
            {
                if(result) result(YES);
                if(_saveBlock) _saveBlock(YES, self.type);
            }
            else
            {
                [self.line enterAgain];
                if(--self.failNumber > 0)
                {
                    self.label.text = [NSString stringWithFormat:@"密码有误，您还有%ld次机会",self.failNumber];
                }
                else
                {
                    self.line.userInteractionEnabled = NO;
                    self.label.text = [NSString stringWithFormat:@"密码有误，请您30秒后再试"];
                    self.timerCount = 30;
                    _tempTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
                }
                
            }
        }break;
    }
    
}



- (void)gestureTouchBegin
{
    [self.state reset];
    [self setLabelText:self.type];
}

- (void)updatePassword:(NSString *)password
{
    [self.state setPassword:password];
}




#pragma mark - setter
- (GPStateView *)state
{
    if(!_state)
    {
        _state = [[GPStateView alloc]init];
        [self addSubview:_state];
    }
    return _state;
}

- (UILabel *)label
{
    if(!_label)
    {
        _label = [[UILabel alloc]init];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:15];
        [self addSubview:_label];
    }
    return _label;
}

- (NSMutableArray *)buttons
{
    if(!_buttons)
    {
        _buttons = [[NSMutableArray alloc]init];
        for(NSInteger i=0;i<9;i++)
        {
            NSInteger row = i/3;
            NSInteger column = i%3;
            GPButton *button = [[GPButton alloc]init];
            button.tag = i;
            [self addSubview:button];
            [button makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(column*(GPBUTTONWIDTH+GPBUTTONSPACE));
                make.top.equalTo(GPBUTTONWIDTH+GPBUTTONSPACE+row*(GPBUTTONWIDTH+GPBUTTONSPACE));
                make.width.and.height.equalTo(GPBUTTONWIDTH);
            }];
            [_buttons addObject:button];
        }
        
        
    }
    return _buttons;
}

- (GPLineView *)line
{
    if(!_line)
    {
        _line = [[GPLineView alloc]initWithArray:self.buttons];
        _line.delegate = self;
//        _line.backgroundColor = [UIColor purpleColor];
        [self addSubview:_line];
//        [self sendSubviewToBack:_line];
    }
    return _line;
}

- (UIButton *)button
{
    if(!_button)
    {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        _button.backgroundColor = [UIColor clearColor];
        [_button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:_button];
    }
    return _button;
}


#pragma mark - BaseMethods
- (BOOL)setObject:(nullable id)value forKey:(nonnull NSString *)defaultName
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:value forKey:defaultName];
    return [ud synchronize];
}

- (nullable id)objectForKey:(nonnull NSString *)anAttribute
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:anAttribute];
}


- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}








@end
