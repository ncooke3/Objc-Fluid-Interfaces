//
//  PipInterfaceViewController.m
//  Objc Fluid Interfaces
//
//  Created by Nicholas Cooke on 3/13/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "PipInterfaceViewController.h"

CGFloat distanceBetweenPipPoints(CGPoint p1, CGPoint p2) {
    return sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2));
}

@interface PipInterfaceViewController ()

@property (nonatomic) GradientView *pipView;
@property (nonatomic) NSMutableArray<PipPositionView *> *pipPositionViews;
@property (nonatomic) NSMutableArray<NSValue *> *pipPositions;
@property (nonatomic) UIPanGestureRecognizer *panRecognizer;

@property (nonatomic) CGFloat pipWidth;
@property (nonatomic) CGFloat pipHeight;

@property (nonatomic) CGFloat horizontalSpacing;
@property (nonatomic) CGFloat verticalSpacing;

@property (nonatomic) CGPoint initialOffset;

@end


@implementation PipInterfaceViewController

- (NSMutableArray<PipPositionView *> *)pipPositionViews {
    if (!_pipPositionViews) {
        _pipPositionViews = [[NSMutableArray alloc] init];
    }
    return _pipPositionViews;
}

- (NSMutableArray<NSValue *> *)pipPositions {
    _pipPositions = [[NSMutableArray alloc] init];;
    for (PipPositionView *pipView in self.pipPositionViews) {
        [_pipPositions addObject:[NSValue valueWithCGPoint:pipView.center]];
    }
    return _pipPositions;
    
}

- (GradientView *)pipView {
    if (!_pipView) {
        _pipView = [[GradientView alloc] init];
        _pipView.translatesAutoresizingMaskIntoConstraints = NO;
        _pipView.topColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.23 alpha:1.00];
        _pipView.bottomColor = [UIColor colorWithRed:0.97 green:0.65 blue:0.11 alpha:1.00];
        _pipView.cornerRadius = 16.0;
    }
    return _pipView;
}

- (PipPositionView *)addPipPositionView {
    PipPositionView *pipPositionView = [[PipPositionView alloc] init];
    [self.view addSubview:pipPositionView];
    pipPositionView.translatesAutoresizingMaskIntoConstraints = NO;
    [[pipPositionView.widthAnchor constraintEqualToConstant:_pipWidth] setActive:YES];
    [[pipPositionView.heightAnchor constraintEqualToConstant:_pipHeight] setActive:YES];
    [self.pipPositionViews addObject:pipPositionView];
    return pipPositionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pipWidth = 86.0;
    _pipHeight = 130.0;
    
    _horizontalSpacing = 23.0;
    _verticalSpacing = 25.0;
    
    _initialOffset = CGPointZero;

    PipPositionView *topLeftView = [self addPipPositionView];
    [[topLeftView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:_horizontalSpacing] setActive:YES];
    [[topLeftView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:_verticalSpacing] setActive:YES];
    
    PipPositionView *topRightView = [self addPipPositionView];
    [[topRightView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-_horizontalSpacing] setActive:YES];
    [[topRightView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:_verticalSpacing] setActive:YES];
    
    PipPositionView *bottomLeftView = [self addPipPositionView];
    [[bottomLeftView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:_horizontalSpacing] setActive:YES];
    [[bottomLeftView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-_verticalSpacing] setActive:YES];
    
    PipPositionView *bottomRightView = [self addPipPositionView];
    [[bottomRightView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-_horizontalSpacing] setActive:YES];
    [[bottomRightView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-_verticalSpacing] setActive:YES];
    
    [self.view addSubview:self.pipView];
    [[_pipView.widthAnchor constraintEqualToConstant:_pipWidth] setActive:YES];
    [[_pipView.heightAnchor constraintEqualToConstant:_pipHeight] setActive:YES];
    
    _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pipPannedWithRecognizer:)];
    [_pipView addGestureRecognizer:_panRecognizer];
}



- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [_pipView setCenter:[self.pipPositions.lastObject CGPointValue]];
}


#pragma mark - Handlers

- (void)pipPannedWithRecognizer:(UIPanGestureRecognizer *)recognizer {
    CGPoint touchPoint = [recognizer locationInView:self.view];
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            _initialOffset = CGPointMake(touchPoint.x - _pipView.center.x, touchPoint.y - _pipView.center.y);
            break;
        case UIGestureRecognizerStateChanged:
            [_pipView setCenter:CGPointMake(touchPoint.x - _initialOffset.x, touchPoint.y - _initialOffset.y)];
            break;
        case UIGestureRecognizerStateEnded: case UIGestureRecognizerStateCancelled: {
            CGFloat decelerationRate = UIScrollViewDecelerationRateNormal;
            CGPoint velocity = [recognizer velocityInView:self.view];
            CGPoint projectedPosition = CGPointMake(
                    _pipView.center.x + [self projectWithInitialVelocity:velocity.x decelerationRate:decelerationRate],
                    _pipView.center.y + [self projectWithInitialVelocity:velocity.y decelerationRate:decelerationRate]);
            CGPoint nearestCornerPosition = [self nearestCornerToPoint:projectedPosition];
            CGVector relativeInitialVelocity = CGVectorMake(
                    [self relativeVelocityForVelocity:velocity.x fromCurrentValue:_pipView.center.x toTargetValue:nearestCornerPosition.x],
                    [self relativeVelocityForVelocity:velocity.y fromCurrentValue:_pipView.center.y toTargetValue:nearestCornerPosition.y]);
            UISpringTimingParameters *timingParameters = [[UISpringTimingParameters alloc] initWithDamping:1.0 response:0.4 initialVelocity:relativeInitialVelocity];
            UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:0.0 timingParameters:timingParameters];
            __weak typeof(self) weakSelf = self;
            [animator addAnimations:^{
                [weakSelf.pipView setCenter:nearestCornerPosition];
            }];
            [animator startAnimation];
            break;
        }
        default:
            break;
    }
}

/// Distance traveled after decelerating to zero velocity at a constant rate.
- (CGFloat)projectWithInitialVelocity:(CGFloat)initialVelocity decelerationRate:(CGFloat)decelerationRate {
    return (initialVelocity / 1000) * decelerationRate / (1 - decelerationRate);
}

/// Finds the position of the nearest corner to the given point.
- (CGPoint)nearestCornerToPoint:(CGPoint)point {
    CGFloat minDistance = CGFLOAT_MAX;
    CGPoint closestPosition = CGPointZero;
    for (NSValue *position in _pipPositions) {
        CGFloat distance  = distanceBetweenPipPoints([position CGPointValue], point);
        if (distance < minDistance) {
            closestPosition = [position CGPointValue];
            minDistance = distance;
        }
    }
    return closestPosition;
}

/// Calculates the relative velocity needed for the initial velocity of the animation.
- (CGFloat)relativeVelocityForVelocity:(CGFloat)velocity fromCurrentValue:(CGFloat)currentValue toTargetValue:(CGFloat)targetValue {
    if (currentValue - targetValue == 0) { return 0; }
    return velocity / (targetValue - currentValue);
}

@end
