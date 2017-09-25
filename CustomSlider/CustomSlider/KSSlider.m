//
//  KSSlider.m
//  CustomSlider
//
//  Created by 广州凯笙 on 2017/9/11.
//  Copyright © 2017年 广州凯笙. All rights reserved.
//

#import "KSSlider.h"

@interface KSSlider ()

@property (nonatomic, assign) CGFloat clipperX;

@end

@implementation KSSlider

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (CGRect)trackRectForBounds:(CGRect)bounds {
    bounds = [super trackRectForBounds:bounds]; // 必须通过调用父类的trackRectForBounds 获取一个 bounds 值，否则 Autolayout 会失效，UISlider 的位置会跑偏。
    return CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, 15); // 这里面的h即为你想要设置的高度。
}

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
{
    bounds = [super thumbRectForBounds:bounds trackRect:rect value:value]; // 这次如果不调用的父类的方法 Autolayout 倒是不会有问题，但是滑块根本就不动~
    return CGRectMake(bounds.origin.x, bounds.origin.y, 30, 30); // w 和 h 是滑块可触摸范围的大小，跟通过图片改变的滑块大小应当一致。
}

//// 设置滑块右侧进度条的尺寸
//- (CGRect)maximumValueImageRectForBounds:(CGRect)bounds {
//    bounds = [super maximumValueImageRectForBounds:bounds];
//    
//    return CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);
//}
//
//// 设置滑块左侧进度条的尺寸
//- (CGRect)minimumValueImageRectForBounds:(CGRect)bounds {
//    bounds = [super minimumValueImageRectForBounds:bounds];
//    return CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    [super hitTest:point withEvent:event];
    
    return nil;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    
//    if (_pressed == NO) {
//        return;
//    }
    
//    CGPoint curP = [[touches anyObject] locationInView:self];
//    float positionX = curP.x - _clipperX;
//    
//    CGFloat minX = (clipperHW-bgImgHeight)/2;
//    if (positionX< -minX) {
//        positionX = -minX;
//    }else if (positionX > sliderWidth-clipperHW+minX){
//        positionX = sliderWidth-clipperHW+minX;
//    }
//    _clipper.x = positionX;
//    [self setNeedsDisplay];

}

@end
