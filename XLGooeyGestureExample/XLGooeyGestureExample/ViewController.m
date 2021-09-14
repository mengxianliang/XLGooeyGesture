//
//  ViewController.m
//  XLGooeyGestureExample
//
//  Created by mxl on 2021/9/14.
//

#import "ViewController.h"
#import "XLGooeyGesture.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, 100, 100)];
    numberLabel.center = CGPointMake(self.view.bounds.size.width/2.0f, numberLabel.center.y);
    numberLabel.layer.cornerRadius = numberLabel.bounds.size.width/2.0f;
    numberLabel.layer.masksToBounds = YES;
    numberLabel.text = @"8";
    numberLabel.font = [UIFont systemFontOfSize:60];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.textColor = [UIColor whiteColor];
    numberLabel.userInteractionEnabled = YES;
    numberLabel.backgroundColor = [UIColor redColor];
    [self.view addSubview:numberLabel];
    
    XLGooeyGesture *pan = [[XLGooeyGesture alloc] init];
    [numberLabel addGestureRecognizer:pan];
    
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(numberLabel.frame) + 200, 100, 100)];
    label2.center = CGPointMake(self.view.bounds.size.width/2.0f, label2.center.y);
    label2.text = @"99";
    label2.font = [UIFont systemFontOfSize:60];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = [UIColor whiteColor];
    label2.userInteractionEnabled = YES;
    label2.backgroundColor = [UIColor blackColor];
    [self.view addSubview:label2];
    
    XLGooeyGesture *pan2 = [[XLGooeyGesture alloc] init];
    pan2.color = [UIColor greenColor];
    pan2.maxDragDistance = 200;
    pan2.originHeight = 10;
    pan2.shouldHideBeyondTheMaxDistance = YES;
    [label2 addGestureRecognizer:pan2];
    
}


@end
