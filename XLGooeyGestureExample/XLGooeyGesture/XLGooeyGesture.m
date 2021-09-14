//
//  XLGooeyGesture.m
//  XLGooeyGestureExample
//
//  Created by mxl on 2021/9/14.
//

#import "XLGooeyGesture.h"

static CGFloat DefaultOriginHeight = 60.0f;
static CGFloat DefaultMaxDragDistance = 300.0f;

@interface XLGooeyGesture ()

@property (nonatomic, strong) UIView *dot;

@property (nonatomic, strong) CAShapeLayer *shadowLayer;

@property (nonatomic, assign) CGFloat currentDistance;

@end

@implementation XLGooeyGesture


- (instancetype)initWithTarget:(id)target action:(SEL)action {
    if (self = [super initWithTarget:target action:action]) {
        [self initUI];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    self.originHeight = DefaultOriginHeight;
    self.maxDragDistance = DefaultMaxDragDistance;
    self.color = [UIColor redColor];
    
    //固定点
    self.dot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.originHeight, self.originHeight)];
    self.dot.center = self.view.center;
    self.dot.layer.cornerRadius = self.originHeight/2.0f;
    self.dot.layer.masksToBounds = YES;
    self.dot.backgroundColor = self.color;
    
    //阴影
    self.shadowLayer = [CAShapeLayer layer];
    self.shadowLayer.strokeColor = self.color.CGColor;
    self.shadowLayer.fillColor = self.color.CGColor;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.state = UIGestureRecognizerStateBegan;
    
    UIView *touchView = self.view;
    UIView *superView = self.view.superview;
    self.dot.center = touchView.center;
    
    [superView.layer insertSublayer:self.shadowLayer atIndex:0];
    [superView insertSubview:self.dot belowSubview:touchView];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    self.state = UIGestureRecognizerStateChanged;
    
    CGPoint location = [self locationInView:self.view.superview];
    
    self.view.center = location;
    
    //不动点信息
    CGFloat x1 = self.dot.center.x;
    CGFloat y1 = self.dot.center.y;
    
    
    //拖动点信息
    CGFloat x2 = self.view.center.x;
    CGFloat y2 = self.view.center.y;
    
    
    //计算出两点间距离
    CGFloat d = sqrtf((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1));
    
    if (d >= self.maxDragDistance) {
        self.dot.backgroundColor = [UIColor clearColor];
        self.shadowLayer.strokeColor = [UIColor clearColor].CGColor;
        self.shadowLayer.fillColor = [UIColor clearColor].CGColor;
        [self.shadowLayer removeAllAnimations];
    }else {
        self.dot.backgroundColor = self.color;
        self.shadowLayer.strokeColor = self.color.CGColor;
        self.shadowLayer.fillColor = self.color.CGColor;
        [self.shadowLayer removeAllAnimations];
    }
    
    self.currentDistance = d;
    
    CGFloat progress = d/self.maxDragDistance;
    
//    NSLog(@"progress = %f",progress);
    
    //固定点最小高度
    CGFloat dot1MiniHeight = 20.0f;
    CGFloat plusHeight = 40;
    CGFloat dot1Height = dot1MiniHeight + plusHeight*(1 - progress);
//    NSLog(@"dot1Height = %f",dot1Height);
    self.dot.bounds = CGRectMake(0, 0, dot1Height, dot1Height);
    self.dot.center = CGPointMake(x1, y1);
    self.dot.layer.cornerRadius = dot1Height/2.0f;
    
    
//    NSLog(@"两球间距：%f",d);
    
    CGFloat r1 = self.dot.bounds.size.width/2.0f;
    CGFloat r2 = self.view.bounds.size.width/2.0f;
    
    //计算出角θ的正弦和余弦值
    CGFloat sinθ = (x2 - x1)/d;
    CGFloat cosθ = (y2 - y1)/d;
    
    //根据sinθ、cosθ、两点坐标，计算出A、B、C、D的坐标
    CGPoint pointA = CGPointMake(x1 - r1*cosθ, y1 + r1*sinθ);
    CGPoint pointB = CGPointMake(x1 + r1*cosθ, y1 - r1*sinθ);
    CGPoint pointC = CGPointMake(x2 - r2*cosθ, y2 + r2*sinθ);
    CGPoint pointD = CGPointMake(x2 + r2*cosθ, y2 - r2*sinθ);
    
    //计算出点A点B计算出点O、P的坐标
    CGPoint pointE = CGPointMake(pointA.x + (d/2)*sinθ, pointA.y + (d/2)*cosθ);
    CGPoint pointF = CGPointMake(pointB.x + (d/2)*sinθ, pointB.y + (d/2)*cosθ);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:pointA];
    [path addLineToPoint:pointB];
    [path addQuadCurveToPoint:pointD controlPoint:pointF];
    [path addLineToPoint:pointC];
    [path addQuadCurveToPoint:pointA controlPoint:pointE];
    [path closePath];
    
    self.shadowLayer.path = path.CGPath;
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.state = UIGestureRecognizerStateEnded;
    [self gooeyGestureEnd];
}
    
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.state = UIGestureRecognizerStateCancelled;
    [self gooeyGestureEnd];
}

- (void)gooeyGestureEnd {
    if (_shouldHideBeyondTheMaxDistance && _currentDistance >= _maxDragDistance) {
        [self.dot removeFromSuperview];
        [self.view removeFromSuperview];
        self.shadowLayer.path = [UIBezierPath bezierPath].CGPath;
    }else {
        self.shadowLayer.path = [UIBezierPath bezierPath].CGPath;
        self.dot.backgroundColor = [UIColor clearColor];
        [UIView animateWithDuration:0.2 animations:^{
            self.view.center = self.dot.center;
        } completion:^(BOOL finished) {
            self.dot.backgroundColor = self.color;
        }];
    }
}

#pragma mark - Setter
- (void)setColor:(UIColor *)color {
    _color = color;
    
    self.dot.backgroundColor = self.color;
    
    self.shadowLayer.strokeColor = self.color.CGColor;
    self.shadowLayer.fillColor = self.color.CGColor;
}

- (void)setMaxDragDistance:(CGFloat)maxDragDistance {
    _maxDragDistance = maxDragDistance;
}

- (void)setOriginHeight:(CGFloat)originHeight {
    _originHeight = originHeight;
    self.dot.frame = CGRectMake(0, 0, self.originHeight, self.originHeight);
    self.dot.center = self.view.center;
    self.dot.layer.cornerRadius = self.originHeight/2.0f;
}

@end
