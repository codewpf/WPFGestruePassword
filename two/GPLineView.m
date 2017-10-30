//
//  GPLineView.m
//  GesturesPassword
//
//  Created by wpf on 15/11/10.
//  Copyright © 2015年 wpf. All rights reserved.
//

#import "GPLineView.h"
#import "GPButton.h"


@interface GPLineView ()

@property (nonatomic, assign) CGPoint lineEndPoint;

@property (nonatomic, strong) NSMutableArray *touchesArray;
@property (nonatomic, strong) NSMutableArray *pointsArray;
@property (nonatomic, assign) BOOL success;

@property (nonatomic,strong) NSArray * buttonArray;

@end


@implementation GPLineView

- (instancetype)initWithArray:(NSMutableArray *)array
{
    if(self = [super init])
    {
        self.backgroundColor = [UIColor clearColor];
        _touchesArray = [[NSMutableArray alloc]init];
        _pointsArray = [[NSMutableArray alloc]init];
        _success = 1;
        _buttonArray = [[NSArray alloc]initWithArray:array];
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    for (int i=0; i<self.pointsArray.count; i++)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        if (self.success)
        {
            CGContextSetRGBStrokeColor(context, 255/255.f, 255/255.f, 255/255.f, 1);//线条颜色
        }
        else
        {
            CGContextSetRGBStrokeColor(context, 255/255.f, 255/255.f, 0/255.f, 0.7);//红色
        }
        
        CGContextSetLineWidth(context,3);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGPoint point = [[self.pointsArray objectAtIndex:i] CGPointValue];
        CGContextMoveToPoint(context, point.x, point.y-GPBUTTONSPACE-GPBUTTONWIDTH);
        if (i<self.pointsArray.count-1)
        {
            CGPoint pointt = [[self.pointsArray objectAtIndex:i+1] CGPointValue];
            CGContextAddLineToPoint(context, pointt.x, pointt.y-GPBUTTONSPACE-GPBUTTONWIDTH);
        }
        else
        {
            if (self.success)
            {
                CGContextAddLineToPoint(context, self.lineEndPoint.x, self.lineEndPoint.y-GPBUTTONSPACE-GPBUTTONWIDTH);
            }
        }
        CGContextStrokePath(context);
    }
}

- (void)enterAgain {
    [self.touchesArray removeAllObjects];
    [self.pointsArray removeAllObjects];
    for (int i=0; i<self.buttonArray.count; i++) {
        GPButton * buttonTemp = ((GPButton *)[self.buttonArray objectAtIndex:i]);
        [buttonTemp setSelected:NO];
        [buttonTemp setSuccess:YES];
        [buttonTemp setNeedsDisplay];
    }
    
    [self setNeedsDisplay];
}


#pragma mark -
#pragma mark - touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.touchesArray removeAllObjects];
    [self.pointsArray removeAllObjects];
    self.success = YES;

    if ([self.delegate respondsToSelector:@selector(gestureTouchBegin)]) {
        [self.delegate gestureTouchBegin];
    }
    
    
    UITouch *touch = [touches anyObject];
    if (touch) {
        CGPoint touchPoint = [touch locationInView:[self superview]];
        for (GPButton * buttonTemp in self.buttonArray)
        {
            if(CGRectContainsPoint(buttonTemp.frame,touchPoint))
            {
                NSString *btag = [NSString stringWithFormat:@"%ld",buttonTemp.tag];

                [buttonTemp setSelected:YES];
                [buttonTemp setNeedsDisplay];
                
                [self.touchesArray addObject:btag];
                [self.pointsArray addObject:[NSValue valueWithCGPoint:buttonTemp.center]];
                self.lineEndPoint = buttonTemp.center;
                break;
            }
        }
        
        [self setNeedsDisplay];
    }
    
    if ([self.delegate respondsToSelector:@selector(updatePassword:)]) {
        [self.delegate updatePassword:[self.touchesArray componentsJoinedByString:@""]];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"%@",[NSDate date]);
    UITouch *touch = [touches anyObject];
    if (touch)
    {
        CGPoint touchPoint = [touch locationInView:[self superview]];
        for(GPButton *buttonTemp in self.buttonArray)
        {
            if (CGRectContainsPoint(buttonTemp.frame,touchPoint))
            {
                NSString *btag = [NSString stringWithFormat:@"%ld",buttonTemp.tag];
                if([self.touchesArray containsObject:btag])
                {
                    self.lineEndPoint = touchPoint;
                    [self setNeedsDisplay];
                    return;
                }
                
                [buttonTemp setSelected:YES];
                [buttonTemp setNeedsDisplay];
                
                [self.touchesArray addObject:btag];
                [self.pointsArray addObject:[NSValue valueWithCGPoint:buttonTemp.center]];
                break;
                
            }
        }
        self.lineEndPoint = touchPoint;
        [self setNeedsDisplay];
    }
    
    
    if ([self.delegate respondsToSelector:@selector(updatePassword:)]) {
        [self.delegate updatePassword:[self.touchesArray componentsJoinedByString:@""]];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSString *resultString = [self.touchesArray componentsJoinedByString:@""];
    if ([self.delegate respondsToSelector:@selector(updatePassword:)]) {
        [self.delegate updatePassword:resultString];
    }
    
    if ([self.delegate respondsToSelector:@selector(gestureTochEnd:result:)]) {
        [self.delegate gestureTochEnd:resultString result:^(BOOL result) {
            self.success = result;
            
            for (int i=0; i<self.touchesArray.count; i++) {
                NSInteger selection = [[self.touchesArray objectAtIndex:i]integerValue];
                GPButton * buttonTemp = ((GPButton *)[self.buttonArray objectAtIndex:selection]);
                [buttonTemp setSuccess:self.success];
                [buttonTemp setNeedsDisplay];
            }
            [self setNeedsDisplay];
        }];
    }

}

@end
