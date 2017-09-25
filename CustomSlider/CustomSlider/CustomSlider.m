//
//  CustomSlider.m
//  CustomSlider
//
//  Created by 广州凯笙 on 2017/9/11.
//  Copyright © 2017年 广州凯笙. All rights reserved.
//

#import "CustomSlider.h"

static CGFloat Slider_Width = 549/2;
static CGFloat Slider_Hight = 30/2;     //长条推子
static CGFloat Thumb_Width = 74/2;        //推子的宽高，包括阴影部分

@interface CustomSlider ()

@property (nonatomic, strong) UIImageView *thumbImgV;
@property (nonatomic, assign) CGFloat originX;
@property (nonatomic, assign) CGFloat currentX;

@end

@implementation CustomSlider

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
//        UIImage *bgImgGray = [UIImage imageNamed:@"stretch_Right_Track"];
//        bgImageView.image = bgImgGray;
//        [self addSubview:bgImageView];
        _thumbImgV = [[UIImageView alloc] initWithFrame:CGRectMake(-(Thumb_Width/2), -(Thumb_Width-Slider_Hight)/2, Thumb_Width, Thumb_Width)];
        _thumbImgV.image = [UIImage imageNamed:@"thumb-on"];
        [self addSubview:_thumbImgV];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    UIImage *bgImgGray = [UIImage imageNamed:@"stretch_Right_Track"];
    [bgImgGray drawInRect:CGRectMake(0, 0, Slider_Width, Slider_Hight)];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
//    UIImage *bgImg = [UIImage imageNamed:@"stretch_Left_Track"];  //这里放白色滑块背景图

    CGContextAddRect(context, CGRectMake(0, 0, (_thumbImgV.frame.origin.x+Thumb_Width/2), Slider_Hight));
    CGContextClip(context);

//    [bgImg drawInRect:CGRectMake(0, 0, _thumbImgV.frame.origin.x+Thumb_Width/2, Slider_Hight)];

    CGContextStrokePath(context);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    [super hitTest:point withEvent:event];
//    _originX = point.x;
//    return _thumbImgV;
    
    CGPoint curP = [self convertPoint:point toView:_thumbImgV];
    if ([_thumbImgV pointInside:curP withEvent:event]) {
        _originX = curP.x;
        return [super hitTest:point withEvent:event];
    }
    return nil;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    
    CGPoint point = [[touches anyObject] locationInView:self];
    
    float positionX = point.x - _originX;
    
    CGFloat minX = (Thumb_Width-Slider_Hight)/2;
    if (positionX< -minX) {
        positionX = -minX;
    }else if (positionX > Slider_Width-Thumb_Width+minX){
        positionX = Slider_Width-Thumb_Width+minX;
    }

//    CGFloat offsetX = point.x-_originX;
//    if (offsetX < -Thumb_Width/2) {
//        _currentX = -Thumb_Width/2;
//    } else if (offsetX >= -Thumb_Width/2 && offsetX < Slider_Width+Thumb_Width-_originX) {
//        _currentX = Slider_Width+Thumb_Width-_originX;
//    } else if (offsetX > Slider_Width+Thumb_Width/2-_originX) {
//        _currentX = Slider_Width+Thumb_Width/2-_originX;
//    }
//    
//    else if (offsetX >= 0 && offsetX < Slider_Width) {
//        _currentX = _originX+offsetX;
//    } else if (offsetX >= Slider_Width) {
//        _currentX = Slider_Width;
//    }
    
//    if (_currentX <= 0) {
//        _currentX = 0;
//    } else if (_currentX >= Slider_Width) {
//        _currentX = Slider_Width;
//    }
    
    CGRect thumbFrame = _thumbImgV.frame;
    thumbFrame.origin.x = positionX;
    _thumbImgV.frame = thumbFrame;
    
    [self setNeedsDisplay];
    NSLog(@"currentX===%.2f",_currentX);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
