//
//  ViewController.m
//  CustomSlider
//
//  Created by 广州凯笙 on 2017/9/11.
//  Copyright © 2017年 广州凯笙. All rights reserved.
//

#import "ViewController.h"
#import "KSSlider.h"
#import "CustomSlider.h"
#import "DJSlider.h"
#import "KSVerticalSlider.h"

#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式

static const float kPROGRESS_LINE_WIDTH=4.0;

@interface ViewController ()

@property (nonatomic,strong) CAShapeLayer *progressLayer;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    UILabel *valueLab = [[UILabel alloc] initWithFrame:CGRectMake(100, 70, 300, 16)];
    valueLab.text = @"";
    valueLab.textColor = [UIColor whiteColor];
    valueLab.textAlignment = NSTextAlignmentCenter;
    valueLab.font = [UIFont systemFontOfSize:15];
    valueLab.tag = 1001;
    [self.view addSubview:valueLab];
    
    UILabel *valueLab2 = [[UILabel alloc] initWithFrame:CGRectMake(100, 150, 300, 16)];
    valueLab2.text = @"";
    valueLab2.textColor = [UIColor whiteColor];
    valueLab2.textAlignment = NSTextAlignmentCenter;
    valueLab2.font = [UIFont systemFontOfSize:15];
    valueLab2.tag = 1002;
    [self.view addSubview:valueLab2];

    
//    CustomSlider *slider = [[CustomSlider alloc] initWithFrame:CGRectMake(100, 100, 549/2, 15)];
//    [self.view addSubview:slider];

    
    DJSlider *slider = [[DJSlider alloc] initWithFrame:CGRectMake(100, 100, 275, 40)];
    slider.backgroundColor = [UIColor clearColor];
    [slider setSliderMinValue:0 maxValue:100];
    //设置精度
    slider.isFine = NO;
    slider.precision = 5;
    [slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
    [slider setSliderThumbLocationByValue:2.5];
//    [slider setSliderThumbLocationByEqValue:600];
    
    
    UILabel *valueLab3 = [[UILabel alloc] initWithFrame:CGRectMake(450, 70, 140, 16)];
    valueLab3.text = @"";
    valueLab3.textColor = [UIColor whiteColor];
    valueLab3.textAlignment = NSTextAlignmentCenter;
    valueLab3.font = [UIFont systemFontOfSize:15];
    valueLab3.tag = 1003;
    [self.view addSubview:valueLab3];
    
    KSVerticalSlider *verticalSlider = [[KSVerticalSlider alloc] initWithFrame:CGRectMake(500, 100, 40, 300)];
    verticalSlider.backgroundColor = [UIColor clearColor];
    [verticalSlider setSliderMinValue:5 maxValue:10];
    //设置精度
    verticalSlider.isFine = NO;
    [verticalSlider setSliderThumbLocationByValue:7];
//    [verticalSlider setSliderThumbLocationByEqValue:600];
    [verticalSlider addTarget:self action:@selector(verticalSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:verticalSlider];
    
    
//    [self setupView1];
//    [self setupView2];
}

- (void)valueChanged:(DJSlider *)slider {
//    NSLog(@"current value = %.1f",slider.value);
//    NSLog(@"current eqValue===%f",slider.eqValue);
    
    UILabel *valueLab = (UILabel *)[self.view viewWithTag:1001];
    valueLab.text = [NSString stringWithFormat:@"%.1f",slider.value];

    UILabel *valueLab2 = (UILabel *)[self.view viewWithTag:1002];
    valueLab2.text = [NSString stringWithFormat:@"%.f",slider.eqValue];
}


- (void)verticalSliderValueChanged:(KSVerticalSlider *)slider {
    UILabel *valueLab2 = (UILabel *)[self.view viewWithTag:1003];
    valueLab2.text = [NSString stringWithFormat:@"%.1f",slider.value];

}


- (void)setupView1 {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(100, 250, 200, 200)];
    [self.view addSubview:bgView];
    
    //设置贝塞尔曲线
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(bgView.bounds.size.width/2, bgView.bounds.size.height/2) radius:(bgView.frame.size.width-kPROGRESS_LINE_WIDTH)/2 startAngle:degreesToRadians(-210) endAngle:degreesToRadians(30) clockwise:YES];
    
    //遮罩层
    
    _progressLayer = [CAShapeLayer layer];
    
    _progressLayer.frame = bgView.bounds;
    
    _progressLayer.fillColor = [[UIColor clearColor] CGColor];
    
    _progressLayer.strokeColor=[UIColor redColor].CGColor;
    
    _progressLayer.lineCap = kCALineCapRound;
    
    _progressLayer.lineWidth = kPROGRESS_LINE_WIDTH;
    
    //渐变图层
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    
    gradientLayer.frame = _progressLayer.frame;
    
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[[UIColor redColor] CGColor],(id)[[UIColor yellowColor] CGColor],(id)[[UIColor blueColor] CGColor], nil]];
    
    [gradientLayer setLocations:@[@0,@0.6,@1]];
    
    [gradientLayer setStartPoint:CGPointMake(0, 0)];
    
    [gradientLayer setEndPoint:CGPointMake(1, 0)];
    
    //用progressLayer来截取渐变层 遮罩
    
    [gradientLayer setMask:_progressLayer];
    
    [bgView.layer addSublayer:gradientLayer];
    
    //增加动画
    
    CABasicAnimation *pathAnimation=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    
    pathAnimation.duration = 2;
    
    pathAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    pathAnimation.fromValue=[NSNumber numberWithFloat:0.0f];
    
    pathAnimation.toValue=[NSNumber numberWithFloat:1.0f];
    
    pathAnimation.autoreverses=NO;
    
    _progressLayer.path=path.CGPath;
    
    [_progressLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
}

    


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
