//
//  KSVerticalSlider.h
//  CustomSlider
//
//  Created by 广州凯笙 on 2017/9/13.
//  Copyright © 2017年 广州凯笙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSVerticalSlider : UIControl

- (instancetype)initWithFrame:(CGRect)frame;

- (void)setSliderMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue;

//精度
@property (nonatomic, assign) BOOL isFine;
//输出value
@property (nonatomic, assign) CGFloat value;
//输出eqValue
@property (nonatomic, assign) CGFloat eqValue;
//根据value定位thumbImage
- (void)setSliderThumbLocationByValue:(CGFloat)value;
//根据eqValue定位thumbImage
- (void)setSliderThumbLocationByEqValue:(CGFloat)eqValue;

@end
