//
//  AccelerationInterfaceViewController.m
//  Objc Fluid Interfaces
//
//  Created by Nicholas Cooke on 3/13/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "AccelerationInterfaceViewController.h"

@interface AccelerationInterfaceViewController ()

@property (nonatomic) UILabel *pauseLabel;
@property (nonatomic) GradientView *accelerationView;
@property (nonatomic) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic) UIImpactFeedbackGenerator *feedbackGenerator;
@property (nonatomic) CGFloat verticalOffset;
@property (nonatomic) CGPoint originalTouchPoint;

/// The number of past velocities to track.
@property (nonatomic) CGFloat numberOfVelocities;

/// The array of past velocities.
@property (nonatomic) NSArray<NSNumber *> *velocities;

/// Whether the view is considered paused.
@property (nonatomic) BOOL hasPaused;

@end



@implementation AccelerationInterfaceViewController

- (UILabel *)pauseLabel {
    if (!_pauseLabel) {
        _pauseLabel = [[UILabel alloc] init];
        _pauseLabel.text = @"PAUSED";
        _pauseLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightBold];
        _pauseLabel.textColor = UIColor.whiteColor;
        _pauseLabel.textAlignment = NSTextAlignmentCenter;
        _pauseLabel.translatesAutoresizingMaskIntoConstraints = false;
        _pauseLabel.alpha = 0;
    }
    return _pauseLabel;
}

- (GradientView *)accelerationView {
    if (!_accelerationView) {
        _accelerationView = [[GradientView alloc] init];
        _accelerationView.topColor = [UIColor colorWithRed:0.39 green:1.00 blue:0.56 alpha:1.0];
        _accelerationView.bottomColor = [UIColor colorWithRed:0.32 green:1.00 blue:0.92 alpha:1.0];
        _accelerationView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _accelerationView;
}

// When doing this, you must use self.velocities so this getter is triggered
- (NSArray<NSNumber *> *)velocities {
    return _velocities ? _velocities : [[NSArray alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _panRecognizer = [[UIPanGestureRecognizer alloc] init];
    _feedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
    _verticalOffset = 180;
    _originalTouchPoint = CGPointZero;
    
    _numberOfVelocities = 7;
    _hasPaused = NO;
    
    [self.view addSubview:self.pauseLabel];
    [[_pauseLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor] setActive:YES];
    [[_pauseLabel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:40.0] setActive:YES];
    
    [self.view addSubview:self.accelerationView];
    UIOffset offset = UIOffsetMake(0, _verticalOffset);
    [[_accelerationView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:offset.horizontal] setActive:YES];
    [[_accelerationView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:offset.vertical] setActive:YES];
    [[_accelerationView.widthAnchor constraintEqualToConstant:160] setActive:YES];
    [[_accelerationView.heightAnchor constraintEqualToConstant:160] setActive:YES];
    
    [_panRecognizer addTarget:self action:@selector(pannedWithRecognizer:)];
    
    [_accelerationView addGestureRecognizer:_panRecognizer];
    
}

- (CGFloat)offsetForTouchPoint:(CGPoint)touchPoint {
    CGFloat offset = touchPoint.y - _originalTouchPoint.y;
    if (offset > 0) {
        return powf(offset, 0.7);
    } else if (offset < -_verticalOffset * 2) {
        return -_verticalOffset * 2 - powf(-(offset + _verticalOffset * 2), 0.7);
    }
    return offset;
}

- (void)pannedWithRecognizer:(UIPanGestureRecognizer *)recognizer {
    CGPoint touchPoint = [recognizer locationInView:self.view];
    CGPoint velocity = [recognizer velocityInView:self.view];
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            _originalTouchPoint = touchPoint;
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            _accelerationView.transform = CGAffineTransformMakeTranslation(0, [self offsetForTouchPoint:touchPoint]);
            [self trackPauseWithVelocity:velocity.y offset:[self offsetForTouchPoint:touchPoint]];
            break;
        }
        case UIGestureRecognizerStateEnded: case UIGestureRecognizerStateCancelled:
        {
            UISpringTimingParameters *timingParameters = [[UISpringTimingParameters alloc] initWithDamping:0.8 response:0.3 initialVelocity:CGVectorMake(0, 0)];
            UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:0.0 timingParameters:timingParameters];
            __weak typeof(self) weakSelf = self;
            [animator addAnimations:^{
                weakSelf.accelerationView.transform = CGAffineTransformIdentity;
                weakSelf.pauseLabel.alpha = 0;
            }];
            [animator setInterruptible:YES];
            [animator startAnimation];
            _hasPaused = NO;
            break;
        }
        default:
            break;
    }
}


/// Tracks the most recent velocity values, and determines whether the change is great enough to be paused.
/// After calling this function, the result can be checked in the `hasPaused` property.
- (void)trackPauseWithVelocity:(CGFloat)velocity offset:(CGFloat)offset {
    // if the motion is paused, we are done
    if (_hasPaused) { return; }
    
    // update the array of most recent velocities
    if (self.velocities.count < _numberOfVelocities) {
        self.velocities = [self.velocities arrayByAddingObject:@(velocity)];
        return;
    } else {
        self.velocities = [self.velocities subarrayWithRange:NSMakeRange(1, _velocities.count - 1)]; // drop first?
        [self.velocities arrayByAddingObject:@(velocity)];
    }
    
    // enforce minimum velocity and offset
    if ((fabs(velocity) > 100) || (fabs(offset) < 50)) { return; }
    
    NSNumber *firstVelocity = [self.velocities firstObject];
    if (!firstVelocity) { return; }
    CGFloat firstRecordedVelocity = [firstVelocity floatValue];
    
    // if the majority of the velocity has been lost recently, we consider the motion to be paused
    if ((fabs(firstRecordedVelocity - velocity) / fabs(firstRecordedVelocity)) > 0.9) {
        _pauseLabel.alpha = 1;
        [_feedbackGenerator impactOccurred];
        _hasPaused = YES;
        self.velocities = NSArray.new;
    }
    
}


@end
