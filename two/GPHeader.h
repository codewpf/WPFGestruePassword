//
//  GPHeader.h
//  two
//
//  Created by wpf on 15/11/11.
//  Copyright © 2015年 wpf. All rights reserved.
//

#ifndef GPHeader_h
#define GPHeader_h

#import "GPView.h"
#import "GPLineView.h"
#import "GPButton.h"
#import "GPStateView.h"



// 按键宽度
#define GPBUTTONWIDTH     75
// 按键中间距离
#define GPBUTTONSPACE     30
// 总页面宽度    高度需要另外增加状态和文字的高度
#define GPSIDE            (GPBUTTONWIDTH*3+GPBUTTONSPACE*2)
// 防止循环引用
#define WS(weakSelf)      __weak __typeof(&*self)weakSelf = self;

// 项目手势密码Defaults的key 需要添加用户的uid
#define GPWD             [NSString stringWithFormat:@"%@-GP",[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey]]


#endif /* GPHeader_h */
