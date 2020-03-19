//
//  RotationInterfaceViewController.m
//  Objc Fluid Interfaces
//
//  Created by Nicholas Cooke on 3/13/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "RotationInterfaceViewController.h"

@interface RotationInterfaceViewController ()

@property (nonatomic) GradientView *rotationView;
@property (nonatomic) CGFloat originalRotation;

@end

@implementation RotationInterfaceViewController

- (GradientView *)rotationView {
    if (!_rotationView) {
        _rotationView = [[GradientView alloc] init];
        _rotationView.translatesAutoresizingMaskIntoConstraints = NO;
        _rotationView.topColor = [UIColor colorWithRed:1.00 green:0.16 blue:0.65 alpha:1.00];
        _rotationView.bottomColor = [UIColor colorWithRed:0.47 green:0.20 blue:0.81 alpha:1.00];
        
    }
    return _rotationView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.rotationView];
    [[_rotationView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor] setActive:YES];
    [[_rotationView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor] setActive:YES];
    [[_rotationView.widthAnchor constraintEqualToConstant:300] setActive:YES];
    [[_rotationView.heightAnchor constraintEqualToConstant:300] setActive:YES];
    
    UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotatedWithRotationRecognizer:)];
    [_rotationView addGestureRecognizer:rotationRecognizer];

}


#pragma mark - Handlers

- (void)rotatedWithRotationRecognizer:(UIRotationGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            _originalRotation = atan2(_rotationView.transform.b, _rotationView.transform.a);
            _rotationView.transform = CGAffineTransformMakeRotation(_originalRotation + recognizer.rotation);
            break;
        }
        case UIGestureRecognizerStateChanged: {
            _rotationView.transform = CGAffineTransformMakeRotation(_originalRotation + recognizer.rotation);
            break;
        }
        case UIGestureRecognizerStateEnded: case UIGestureRecognizerStateCancelled: {
            CGFloat velocity = recognizer.velocity;
            CGFloat decelerationRate = UIScrollViewDecelerationRateFast;
            CGFloat projectedRotation = recognizer.rotation + [self projectWithInitialVelocity:velocity withDecelerationRate:decelerationRate];
            CGFloat nearestAngle = [self closestAngleTo:projectedRotation];
            CGFloat relativeInitialVelocity = [self relativeVelocityForVelocity:velocity from:recognizer.rotation to:nearestAngle];
            UISpringTimingParameters *timingParameters = [[UISpringTimingParameters alloc] initWithDamping:0.8 response:0.4 initialVelocity:CGVectorMake(relativeInitialVelocity, 0)];
            UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:0 timingParameters:timingParameters];
            __weak typeof(self) weakSelf = self;
            [animator addAnimations:^{
                weakSelf.rotationView.transform = CGAffineTransformMakeRotation(weakSelf.originalRotation + nearestAngle);
            }];
            [animator startAnimation];
            break;
        }
        default:
            break;
    }
}

/// Distance traveled after decelerating to zero velocity at a constant rate.
- (CGFloat)projectWithInitialVelocity:(CGFloat)initialVelocity withDecelerationRate:(CGFloat)decelerationRate {
    return (initialVelocity / 1000) * decelerationRate / (1 - decelerationRate);
}

-(CGFloat)closestAngleTo:(CGFloat)angle {
    CGFloat divisor = M_PI / 2;
    CGFloat remainder = fmodf(angle, divisor); // could be a problem...
    CGFloat newAngle = 0;
    if (remainder >= 0) {
        if (remainder >= divisor / 2) {
            newAngle = angle + divisor - remainder;
        } else {
        newAngle = remainder == 0 ? angle : angle - remainder;
        }
    } else {
        if (remainder <= -divisor / 2) {
            newAngle = angle - divisor - remainder;
        } else {
            newAngle = angle - remainder;
        }
    }
    
    if (newAngle > M_PI) { newAngle = M_PI; }
    if (newAngle < -M_PI) { newAngle = -M_PI; }
    
    return newAngle;
}

- (CGFloat)relativeVelocityForVelocity:(CGFloat)velocity from:(CGFloat)currentValue to:(CGFloat)targetValue {
    if (currentValue - targetValue == 0) { return 0; }
    return velocity / (targetValue - currentValue);
}



@end
