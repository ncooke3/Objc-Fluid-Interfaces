//
//  MomentumInterfaceViewController.m
//  Objc Fluid Interfaces
//
//  Created by Nicholas Cooke on 3/13/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "MomentumInterfaceViewController.h"

@interface MomentumInterfaceViewController ()

@property (nonatomic) GradientView *momentumView;
@property (nonatomic) UIView *handleView;
@property (nonatomic) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic) UIViewPropertyAnimator *animator;
@property (nonatomic) BOOL isOpen;
@property (nonatomic) CGFloat animationProgress;
@property (nonatomic) CGAffineTransform closedTransform;

@end


@implementation MomentumInterfaceViewController

- (GradientView *)momentumView {
    if (!_momentumView) {
        _momentumView = [[GradientView alloc] init];
        _momentumView.translatesAutoresizingMaskIntoConstraints = NO;
        _momentumView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
        _momentumView.topColor = [UIColor colorWithRed:0.38 green:0.66 blue:1.00 alpha:1.00];
        _momentumView.bottomColor = [UIColor colorWithRed:0.14 green:0.23 blue:0.82 alpha:1.00];
        _momentumView.cornerRadius = 30.0;
    }
    return _momentumView;
}

- (UIView *)handleView {
    if (!_handleView) {
        _handleView = [[UIView alloc] init];
        _handleView.translatesAutoresizingMaskIntoConstraints = NO;
        _handleView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        _handleView.layer.cornerRadius = 3.0;
    }
    return _handleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // printing out default property values
    
    [self.view addSubview:self.momentumView];

    [[_momentumView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor] setActive:YES];
    [[_momentumView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-8.0] setActive:YES];
    [[_momentumView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:80] setActive:YES];
    [[_momentumView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:80.0] setActive:YES];
    
    [_momentumView addSubview:self.handleView];
    [[_handleView.topAnchor constraintEqualToAnchor:_momentumView.topAnchor constant:10.0] setActive:YES];
    [[_handleView.widthAnchor constraintEqualToConstant:50.0] setActive:YES];
    [[_handleView.heightAnchor constraintLessThanOrEqualToConstant:5.0] setActive:YES];
    [[_handleView.centerXAnchor constraintEqualToAnchor:_momentumView.centerXAnchor] setActive:YES];

    
    _closedTransform = CGAffineTransformMakeTranslation(0, self.view.bounds.size.height * 0.6);
    _momentumView.transform = _closedTransform;
    
    _panRecognizer = [[InstantPanGestureRecognizer alloc] initWithTarget:self action:@selector(pannedWithRecognizer:)];
    [_momentumView addGestureRecognizer:_panRecognizer];

}

- (void)pannedWithRecognizer:(InstantPanGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            [self startAnimationIfNeeded];
            [_animator pauseAnimation];
            _animationProgress = _animator.fractionComplete;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGFloat fraction = -[recognizer translationInView:_momentumView].y / _closedTransform.ty;
            if (_isOpen) { fraction *= -1; }
            if (_animator.isReversed) { fraction *= -1; }
            _animator.fractionComplete = fraction + _animationProgress;
            break;
        }
        case UIGestureRecognizerStateEnded: case UIGestureRecognizerStateCancelled: {
            CGFloat yVelocity = [recognizer velocityInView:_momentumView].y;
            BOOL shouldClose = yVelocity > 0;
            if (yVelocity == 0) {
                [_animator continueAnimationWithTimingParameters:nil durationFactor:0];
                break;
            }
            if (_isOpen) {
                if (!shouldClose && !_animator.isReversed) { [_animator setReversed:!_animator.isReversed]; }
                if (shouldClose && _animator.isReversed) { [_animator setReversed:!_animator.isReversed]; }
            } else {
                if (shouldClose && !_animator.isReversed) { [_animator setReversed:!_animator.isReversed]; }
                if (!shouldClose && _animator.isReversed) { [_animator setReversed:!_animator.isReversed]; }
            }
            CGFloat fractionRemaining = 1 - _animator.fractionComplete;
            CGFloat distanceRemaining = fractionRemaining * _closedTransform.ty;
            if (distanceRemaining == 0) {
                [_animator continueAnimationWithTimingParameters:nil durationFactor:0];
                break;
            }
            CGFloat relativeVelocity = MIN(fabs(yVelocity), 30);
            UISpringTimingParameters *timingParameters = [[UISpringTimingParameters alloc] initWithDamping:0.8 response:0.3 initialVelocity:CGVectorMake(relativeVelocity, relativeVelocity)];
            CGFloat preferredDuration = [[UIViewPropertyAnimator alloc] initWithDuration:0 timingParameters:timingParameters].duration;
            CGFloat durationFactor = preferredDuration / _animator.duration;
            [_animator continueAnimationWithTimingParameters:timingParameters durationFactor:durationFactor];
            break;
        }
        default:
            break;
    }
}

- (void)startAnimationIfNeeded {
    if (_animator.isRunning) { return; }
    UISpringTimingParameters *timingParameters = [[UISpringTimingParameters alloc] initWithDamping:1.0 response:0.4 initialVelocity:CGVectorMake(0, 0)];
    _animator = [[UIViewPropertyAnimator alloc] initWithDuration:0 timingParameters:timingParameters];
    __weak typeof(self) weakSelf = self;
    [_animator addAnimations:^{
        weakSelf.momentumView.transform = weakSelf.isOpen ? weakSelf.closedTransform : CGAffineTransformIdentity;
    }];
    [_animator addCompletion:^(UIViewAnimatingPosition position) {
        if (position == UIViewAnimatingPositionEnd) { weakSelf.isOpen = !weakSelf.isOpen; }
    }];
    [_animator startAnimation];
}


@end
