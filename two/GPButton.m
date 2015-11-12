//
//  GPButton.m
//  GesturesPassword
//
//  Created by wpf on 15/11/10.
//  Copyright © 2015年 wpf. All rights reserved.
//

#import "GPButton.h"

@implementation GPButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.success = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect bounds = self.bounds;
    
    if (self.selected) {
        if (self.success) {
            CGContextSetRGBStrokeColor(context, 255/255.f, 255/255.f, 255/255.f,1);//线条颜色
            CGContextSetRGBFillColor(context,255/255.f, 255/255.f, 255/255.f,1);//选中时中间圆心颜色
        }
        else {
            CGContextSetRGBStrokeColor(context, 255/255.f, 255/255.f, 255/255.f,1);//线条颜色
            CGContextSetRGBFillColor(context,255/255.f, 255/255.f, 255/255.f,1);
        }
        CGRect frame = CGRectMake(bounds.size.width/3+1, bounds.size.height/3, bounds.size.width/3, bounds.size.height/3);
        CGContextAddEllipseInRect(context,frame);
        CGContextFillPath(context);
    }
    else{
        //默认圆圈颜色
        CGContextSetRGBStrokeColor(context, 255/255.f,255/255.f,255/255.f,0.7);//线条颜色
    }
    
    CGContextSetLineWidth(context,2);
    CGRect frame = CGRectMake(2, 2, bounds.size.width-3, bounds.size.height-3);
    CGContextAddEllipseInRect(context,frame);
    CGContextStrokePath(context);
    if (self.success) {
        CGContextSetRGBFillColor(context,0/255.f, 0/255.f, 0/255.f,0.1);//选中时圆圈内背景颜色
    } else {
        CGContextSetRGBFillColor(context,0/255.f, 0/255.f, 0/255.f,0.1);
    }
    CGContextAddEllipseInRect(context,frame);
    if (self.selected) {
        CGContextFillPath(context);
    }

}


@end
