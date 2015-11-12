//
//  GPLineView.h
//  GesturesPassword
//
//  Created by wpf on 15/11/10.
//  Copyright © 2015年 wpf. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GPLineViewDelegate <NSObject>

@optional
- (void)gestureTochEnd:(NSString *)password result:(void (^)(BOOL result))result;
- (void)gestureTouchBegin;
- (void)updatePassword:(NSString *)password;

@end


@interface GPLineView : UIView

- (instancetype)initWithArray:(NSMutableArray *)array;

@property (nonatomic, weak) id<GPLineViewDelegate> delegate;

- (void)enterAgain;

@end
