//
//  DJSlider.m
//  CustomSlider
//
//  Created by 广州凯笙 on 2017/9/12.
//  Copyright © 2017年 广州凯笙. All rights reserved.
//
//  ⚠️⚠️⚠️注意
//  创建Slider时，设置Frame的size至少需要(250, 40)，否则无法完全显示Slider
//  ⚠️⚠️⚠️⚠️⚠️


#define SliderW 250.0
#define SliderH 15.0
#define ThumbImageWH 37.0
#define Slider_StartX 13.0
#define Slider_StartY 20.0

#define EQPARA 0.058048381

#import "DJHorizontalSlider.h"

@interface DJHorizontalSlider ()

@property (nonatomic, strong) UIImage *thumbImage;
@property (nonatomic, assign) CGRect sliderRect;        //sliderFrame
@property (nonatomic, assign) CGRect thumbRect;         //thumbFrame
@property (nonatomic, assign) BOOL isFirst;             //首次运行
@property (nonatomic, assign) CGFloat minValue;
@property (nonatomic, assign) CGFloat maxValue;

@end


@implementation DJHorizontalSlider

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.thumbImage = [UIImage imageNamed:@"thumb-horizontal-on"];
        //设置默认值
        _isFirst = NO;
        _isFine = YES;
        _precision = 1.0;
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
    CGPoint endPoint  = CGPointMake(Slider_StartX+SliderW, Slider_StartY);
    CGContextMoveToPoint(context, starPoint.x, starPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextSetLineWidth(context, SliderH);                    // 线的宽度
    CGContextSetLineCap(context, kCGLineCapRound);              // 起点和终点圆角
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:61/255.0f green:61/255.0f blue:61/255.0f alpha:1.0].CGColor);
    CGContextStrokePath(context);
    
    // 用BezierPath画高亮滑杆
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(ThumbImageWH/2-Slider_StartX, Slider_StartY-7.5, self.thumbRect.origin.x+ThumbImageWH/2, SliderH) cornerRadius:SliderH/2];
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
    
    CGFloat currentOffsetX = 0;
    CGFloat thumbOffsetX = 0;

    if (_isFine) {
        if (point.x <= Slider_StartX) {
            thumbOffsetX = Slider_StartX-ThumbImageWH/2;
        } else if (point.x > Slider_StartX && point.x < Slider_StartX+SliderW) {
            thumbOffsetX = point.x-ThumbImageWH/2;
        } else if (point.x >= Slider_StartX+SliderW) {
            thumbOffsetX = Slider_StartX+SliderW-ThumbImageWH/2;
        }
        currentOffsetX = thumbOffsetX-(Slider_StartX-ThumbImageWH/2);
    } else {
        CGFloat perX = SliderW/((self.maxValue-self.minValue)/_precision);
        CGFloat count = 0;
        if (point.x <= Slider_StartX) {
            count = 0;
            thumbOffsetX = Slider_StartX-ThumbImageWH/2;
        } else if (point.x > Slider_StartX && point.x < Slider_StartX+SliderW) {
            count = floorf((point.x-Slider_StartX)/perX); // 向下取整
            thumbOffsetX = perX*count+Slider_StartX-ThumbImageWH/2;
        } else if (point.x >= Slider_StartX+SliderW) {
            count = ((CGFloat)SliderW)/perX;
            thumbOffsetX = Slider_StartX+SliderW-ThumbImageWH/2;
        }
        currentOffsetX = perX*count;
    }

    self.thumbRect = CGRectMake(thumbOffsetX, self.thumbRect.origin.y, ThumbImageWH, ThumbImageWH);
    [self getCurrentValueWithOffsetX:currentOffsetX];
    [self setNeedsDisplay];

    //增加控制事件
    [self addTarget:self action:@selector(touchInside) forControlEvents:UIControlEventTouchDragInside];
    [self sendActionsForControlEvents:UIControlEventValueChanged];

    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    [self touchOutside];
}

- (void)touchInside {
    self.thumbImage = [UIImage imageNamed:@"thumb-off"];
    [self setNeedsDisplay];
}

- (void)touchOutside {
    self.thumbImage = [UIImage imageNamed:@"thumb-horizontal-on"];
    [self setNeedsDisplay];

}

//根据滑动的比例输出值value
- (void)getCurrentValueWithOffsetX:(CGFloat)value {
    // 获取正常值
    [self getSliderValue:value];
}

/**
 *  获取输出value
 *  value
 */
- (void)getSliderValue:(CGFloat)value {
    CGFloat percent = value/(SliderW);
    CGFloat count = _minValue+percent*(_maxValue-_minValue);
    self.value = count;
}

//根据value定位thumbImage
- (void)setSliderThumbLocationByValue:(CGFloat)value {
    CGFloat perX = SliderW/(self.maxValue-self.minValue);  
    CGFloat marginValue = value-self.minValue;
    if(value >= self.minValue && value <= self.maxValue) {
        self.thumbRect = CGRectMake(marginValue*perX+Slider_StartX-ThumbImageWH/2, Slider_StartY-(ThumbImageWH)/2, ThumbImageWH, ThumbImageWH);
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
