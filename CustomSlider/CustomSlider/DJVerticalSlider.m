//
//  DJVerticalSlider.m
//  CustomSlider
//
//  Created by 广州凯笙 on 2017/9/13.
//  Copyright © 2017年 广州凯笙. All rights reserved.
//
//  ⚠️⚠️⚠️注意
//  创建Slider时，设置Frame的size至少需要(40, 250)，否则无法完全显示Slider
//  ⚠️⚠️⚠️⚠️⚠️

#define SliderW 15
#define SliderH 250
#define ThumbImageWH 37

#define Slider_StartX 20
#define Slider_StartY 13

#import "DJVerticalSlider.h"

@interface DJVerticalSlider ()

@property (nonatomic, strong) UIImage *thumbImage;
@property (nonatomic, assign) CGRect sliderRect;        //sliderFrame
@property (nonatomic, assign) CGRect thumbRect;         //thumbFrame
@property (nonatomic, assign) BOOL isFirst;             //首次运行
@property (nonatomic, assign) CGFloat minValue;
@property (nonatomic, assign) CGFloat maxValue;

@end

@implementation DJVerticalSlider


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.thumbImage = [UIImage imageNamed:@"thumb-vertical-on"];
    }
    return self;
}

- (void)setSliderMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue {
    self.minValue = minValue;
    self.maxValue = maxValue;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    // draw slider
    [self loadSliderWithContext:context];
    // draw thumbImage
    [self loadThumWithContext:context];
}

- (void)loadSliderWithContext:(CGContextRef)context {
    self.sliderRect = CGRectMake(Slider_StartX, Slider_StartY, SliderW, SliderH);
    
    // 画背景滑杆
    CGPoint starPoint = CGPointMake(Slider_StartX, Slider_StartY);
    CGPoint endPoint  = CGPointMake(Slider_StartX, Slider_StartY+SliderH);
    CGContextMoveToPoint(context, starPoint.x, starPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextSetLineWidth(context, SliderW);                    // 线的宽度
    CGContextSetLineCap(context, kCGLineCapRound);              // 起点和终点圆角
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:61/255.0f green:61/255.0f blue:61/255.0f alpha:1.0].CGColor);
    CGContextStrokePath(context);
    
    // 用BezierPath画高亮滑杆
    CGFloat pathH = 0;
    if (!_isFirst) {
        pathH = 0;
    } else {
        pathH = self.thumbRect.origin.y+ThumbImageWH/2;
    }
    // 用BezierPath画高亮滑杆
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(Slider_StartX-7.5, Slider_StartY-7.5, SliderW, pathH) cornerRadius:SliderH/2];
    [[UIColor colorWithRed:189/255.0f green:189/255.0f blue:189/255.0f alpha:1.0f] setFill];
    [[UIColor colorWithRed:189/255.0f green:189/255.0f blue:189/255.0f alpha:1.0f] setStroke];
    [path fill];
    [path stroke];
}

- (void)loadThumWithContext:(CGContextRef)context {
    // current thumbImage
    if (!self.isFirst) {
        //滑块初始化
        CGRect thumbRect = CGRectMake(Slider_StartX-ThumbImageWH/2, Slider_StartY-(ThumbImageWH)/2, ThumbImageWH, ThumbImageWH);
        self.thumbRect = thumbRect;
        [self.thumbImage drawInRect:thumbRect];
        self.isFirst = YES;
    }
    
    // draw thumbImage
    if (self.thumbImage) {
        [self.thumbImage drawInRect:self.thumbRect];
    }
}

// 开始拖动
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super beginTrackingWithTouch:touch withEvent:event];
    CGPoint point = [touch locationInView:self];
    // 可滑动范围
    if (!CGRectContainsPoint(self.thumbRect, point)) {
        return NO;
    }
    return YES;
}

// 持续拖动
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super continueTrackingWithTouch:touch withEvent:event];
    CGPoint point = [touch locationInView:self];
    
    CGFloat currentOffsetY = 0;
    CGFloat thumbOffsetY = 0;
    
    if (_isFine) {
        if (point.y <= Slider_StartY) {
            thumbOffsetY = Slider_StartY-ThumbImageWH/2;
        } else if (point.y > Slider_StartY && point.y < Slider_StartY+SliderH) {
            thumbOffsetY = point.y-ThumbImageWH/2;
        } else if (point.y >= Slider_StartY+SliderH) {
            thumbOffsetY = Slider_StartY+SliderH-ThumbImageWH/2;
        }
        currentOffsetY = thumbOffsetY-(Slider_StartY-ThumbImageWH/2);
    } else {
        CGFloat perY = SliderH/(self.maxValue-self.minValue);
        CGFloat count = 0;
        if (point.y <= Slider_StartY) {
            count = 0;
            thumbOffsetY = Slider_StartY-ThumbImageWH/2;
        } else if (point.y > Slider_StartY && point.y < Slider_StartY+SliderH) {
            count = floorf((point.y-Slider_StartY)/perY); // 向下取整
            thumbOffsetY = perY*count+Slider_StartY-ThumbImageWH/2;
        } else if (point.y >= Slider_StartY+SliderH) {
            count = ((CGFloat)SliderH)/perY;
            thumbOffsetY = Slider_StartY+SliderH-ThumbImageWH/2;
        }
        currentOffsetY = perY*count;
    }

    self.thumbRect = CGRectMake(self.thumbRect.origin.x, thumbOffsetY, ThumbImageWH, ThumbImageWH);
    [self getCurrentValueWithOffsetY:currentOffsetY];
    [self setNeedsDisplay];
    
    //增加控制事件
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
}

//根据滑动的比例输出值value
- (void)getCurrentValueWithOffsetY:(CGFloat)value {
    // 获取正常值
    [self getSliderValue:value];
}

/**
 *  获取输出value
 *  value
 */
- (void)getSliderValue:(CGFloat)value {
    CGFloat percent = value/(SliderH);
    if (_isFine) {
        CGFloat count = self.minValue+percent*(self.maxValue-self.minValue);
        self.value = count;
    } else {
        int count = (int)self.minValue+percent*(self.maxValue-self.minValue);
        self.value = count;
    }
}

//根据value定位thumbImage
- (void)setSliderThumbLocationByValue:(CGFloat)value {
    CGFloat perY = SliderH/(self.maxValue-self.minValue);
    CGFloat marginValue = value-self.minValue;
    if(value >= self.minValue && value <= self.maxValue) {
        self.thumbRect = CGRectMake(Slider_StartX-ThumbImageWH/2, marginValue*perY+Slider_StartY-ThumbImageWH/2, ThumbImageWH, ThumbImageWH);
        self.isFirst = YES;
        [self setNeedsDisplay];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
