//
//  ViewController.m
//  CustomSlider
//
//  Created by 广州凯笙 on 2017/9/11.
//  Copyright © 2017年 广州凯笙. All rights reserved.
//

#import "ViewController.h"
#import "DJHorizontalSlider.h"
#import "DJVerticalSlider.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    for (int i = 0; i < 2; i ++) {
        UILabel *valueLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 70+80*i, 300, 16)];
        valueLab.textColor = [UIColor whiteColor];
        valueLab.textAlignment = NSTextAlignmentCenter;
        valueLab.font = [UIFont systemFontOfSize:15];
        valueLab.tag = 1000+i;
        if (i == 0) {
            valueLab.text = @"HorizontalSlider";
        } else {
            valueLab.text = @"30.00";
        }
        [self.view addSubview:valueLab];
    }
    
    DJHorizontalSlider *slider = [[DJHorizontalSlider alloc] initWithFrame:CGRectMake(30, 100, 275, 40)];
    slider.backgroundColor = [UIColor clearColor];
    [slider setSliderMinValue:0 maxValue:100];
    //设置是否取精度（默认是YES）
//    slider.isFine = NO;
    //设置简单间隔单位为5
//    slider.precision = 5;
    //设置滑块初始位置
    [slider setSliderThumbLocationByValue:30];
    [slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];

    
    for (int i = 0; i < 2; i ++) {
        UILabel *valueLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 220+(300+25)*i, 100, 16)];
        valueLab.textColor = [UIColor whiteColor];
        valueLab.textAlignment = NSTextAlignmentCenter;
        valueLab.font = [UIFont systemFontOfSize:15];
        valueLab.tag = 1002+i;
        if (i == 0) {
            valueLab.text = @"VerticalSlider";
        } else {
            valueLab.text = @"7.0";
        }
        [self.view addSubview:valueLab];
    }
    
    DJVerticalSlider *verticalSlider = [[DJVerticalSlider alloc] initWithFrame:CGRectMake(80, 250, 40, 300)];
    verticalSlider.backgroundColor = [UIColor clearColor];
    [verticalSlider setSliderMinValue:0 maxValue:10];
    //设置精度
    verticalSlider.isFine = NO;
    [verticalSlider setSliderThumbLocationByValue:7];
    [verticalSlider addTarget:self action:@selector(verticalSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:verticalSlider];
    
}

- (void)valueChanged:(DJHorizontalSlider *)slider {    
    UILabel *valueLab = (UILabel *)[self.view viewWithTag:1001];
    valueLab.text = [NSString stringWithFormat:@"%.2f",slider.value];
}


- (void)verticalSliderValueChanged:(DJVerticalSlider *)slider {
    UILabel *valueLab2 = (UILabel *)[self.view viewWithTag:1003];
    valueLab2.text = [NSString stringWithFormat:@"%.1f",slider.value];

}



    


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
