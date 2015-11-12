//
//  GPView.h
//  two
//
//  Created by wpf on 15/11/11.
//  Copyright © 2015年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPLineView.h"

typedef NS_ENUM(NSInteger, GPType) {
    GP_New = 0, // 新设置
    GP_Update,  // 修改
    GP_Ver,     // 验证
};

typedef void(^ResultBlock)(BOOL result, GPType type);
typedef void(^ButtonBlock)(NSInteger tag);

@interface GPView : UIView<GPLineViewDelegate>

@property (nonatomic, unsafe_unretained) GPType type;

- (void)result:(ResultBlock)result;
- (void)buttonBlock:(ButtonBlock)button;
- (NSString *)md5:(NSString *)str;

@end
