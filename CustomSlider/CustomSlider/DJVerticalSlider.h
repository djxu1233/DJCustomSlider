//
//  DJVerticalSlider.h
//  CustomSlider
//
//  Created by 广州凯笙 on 2017/9/13.
//  Copyright © 2017年 广州凯笙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJVerticalSlider : UIControl

- (instancetype)initWithFrame:(CGRect)frame;

- (void)setSliderMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue;

//精度
@property (nonatomic, assign) BOOL isFine;
//输出value
@property (nonatomic, assign) CGFloat value;
//根据value定位thumbImage
- (void)setSliderThumbLocationByValue:(CGFloat)value;


@end
