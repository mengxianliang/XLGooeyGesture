# XLGooeyGesture

XLGooeyGesture继承于UIGestureRecognizer，使用时只需要将手势添加给需要显示粘性动画的view即可

## 效果

![image](https://github.com/mengxianliang/XLGooeyGesture/blob/main/Images/1.gif)

## 代码

```objc
    UIView *view = [[UIView alloc] init];
    
    XLGooeyGesture *gesture = [[XLGooeyGesture alloc] init];
    [view addGestureRecognizer:gesture];
```
