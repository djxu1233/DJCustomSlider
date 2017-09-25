//
//  DJSlider.h
//  CustomSlider
//
//  Created by 广州凯笙 on 2017/9/12.
//  Copyright © 2017年 广州凯笙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJHorizontalSlider : UIControl

- (instancetype)initWithFrame:(CGRect)frame;

- (void)setSliderMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue;

//是否取精度
@property (nonatomic, assign) BOOL isFine;
//精度大小
@property (nonatomic, assign) CGFloat precision;
//输出value
@property (nonatomic, assign) CGFloat value;
//根据value定位thumbImage
- (void)setSliderThumbLocationByValue:(CGFloat)value;



@end
