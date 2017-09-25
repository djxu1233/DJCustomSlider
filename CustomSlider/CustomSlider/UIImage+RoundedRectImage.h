//
//  UIImage+RoundedRectImage.h
//  CustomSlider
//
//  Created by 广州凯笙 on 2017/9/12.
//  Copyright © 2017年 广州凯笙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RoundedRectImage)

+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r;

/**
 *  返回圆型图片
 */
- (instancetype)circleImage;

/**
 *  返回圆型图片
 */
+ (instancetype)circleImage:(NSString *)image;

@end
