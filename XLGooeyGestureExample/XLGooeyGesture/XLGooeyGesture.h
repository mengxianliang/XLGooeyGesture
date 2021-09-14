//
//  XLGooeyGesture.h
//  XLGooeyGestureExample
//
//  Created by mxl on 2021/9/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLGooeyGesture : UIGestureRecognizer

/// 粘性动画颜色
@property (nonatomic, strong) UIColor *color;

/// 最大拖拽举例，默认300
@property (nonatomic, assign) CGFloat maxDragDistance;

/// 起始大小 默认60
@property (nonatomic, assign) CGFloat originHeight;

/// 超过最大距离隐藏
//Sliding beyond the maximum distance
@property (nonatomic, assign) BOOL shouldHideBeyondTheMaxDistance;

@end

NS_ASSUME_NONNULL_END
