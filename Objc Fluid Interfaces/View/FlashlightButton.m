//
//  FlashlightButton.m
//  Objc Fluid Interfaces
//
//  Created by Nicholas Cooke on 3/16/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "FlashlightButton.h"


CGFloat distanceBetweenPoints(CGPoint p1, CGPoint p2) {
    return sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2));
}


typedef NS_ENUM(NSUInteger, ForceState) {
    ForceStateReset,
    ForceStateActivated,
    ForceStateConfirmed,
};


@interface FlashlightButton ()


@property (nonatomic) UIImageView *imageView;

/// Whether the button is on or off.
@property (nonatomic) BOOL isOn;

/// The current state of the force press.
@property (nonatomic) ForceState forceState;

/// Whether the touch has exited the bounds of the button.
/// This is used to cancel touches that move outside of its bounds.
@property (nonatomic) BOOL touchExited;

@property (nonatomic) UIImpactFeedbackGenerator *activationFeedbackGenerator;
@property (nonatomic) UIImpactFeedbackGenerator *confirmationFeedbackGenerator;

@property (nonatomic) CGFloat minWidth;
@property (nonatomic) CGFloat maxWidth;

@property (nonatomic) UIColor *offColor;
@property (nonatomic) UIColor *onColor;

@property (nonatomic) UIImage *onImage;
@property (nonatomic) UIImage *offImage;

@property (nonatomic) CGFloat activationForce;
@property (nonatomic) CGFloat confirmationForce;
@property (nonatomic) CGFloat resetForce;

@end



@implementation FlashlightButton

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        _isOn = NO;
        _forceState = ForceStateReset;
        _touchExited = NO;

        _activationFeedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        _confirmationFeedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];

        _minWidth = 50.0;
        _maxWidth = 92.0;

        _offColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        _onColor = [UIColor colorWithWhite:0.95 alpha:1.0];

        _onImage = [UIImage imageNamed:@"flashlight_on"];
        _offImage = [UIImage imageNamed:@"flashlight_off"];

        _activationForce = 0.50;
        _confirmationForce = 0.49;
        _resetForce = 0.40;

        _imageView = [[UIImageView alloc] init];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO; // hime?
        _imageView.image = _offImage;
        _imageView.tintColor = UIColor.whiteColor;

        [self addSubview:_imageView];
        [[_imageView.topAnchor constraintEqualToAnchor:self.topAnchor] setActive:YES];
        [[_imageView.leftAnchor constraintEqualToAnchor:self.leftAnchor] setActive:YES];
        [[_imageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor] setActive:YES];
        [[_imageView.rightAnchor constraintEqualToAnchor:self.rightAnchor] setActive:YES];
        
        self.backgroundColor = _offColor;
        
    }
    return self;
}


#pragma mark - Overrides

- (CGSize)intrinsicContentSize {
    return CGSizeMake(_minWidth, _minWidth);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = self.bounds.size.width / 2;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    _touchExited = NO;
    [self touchMoved:[[touches allObjects] firstObject]];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    [self touchMoved:[[touches allObjects] firstObject]];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self touchEnded:[[touches allObjects] firstObject]];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [self touchEnded:[[touches allObjects] firstObject]];
}


# pragma Utility

- (void)touchMoved:(UITouch *)touch {
    if (!touch) { return; }
    if (_touchExited) { return; }
    
    CGFloat cancelDistance = _minWidth / 2 + 20;
    
    CGFloat distance = distanceBetweenPoints([touch locationInView:self], CGPointMake(self.bounds.origin.x + self.bounds.size.width / 2, self.bounds.origin.y + self.bounds.size.height / 2));
    if (distance >= cancelDistance) {
        // the touch has moved outside of the bounds of the button
        _touchExited = YES;
        _forceState = ForceStateReset;
        [self animateToRest];
        return;
    }
    
    CGFloat force = touch.force / touch.maximumPossibleForce;
    CGFloat scale = 1 + (_maxWidth / _minWidth - 1) * force; // TODO: play around this..why?
    
    // update the button's size and color
    self.transform = CGAffineTransformMakeScale(scale, scale);
    if (!_isOn) { self.backgroundColor = [UIColor colorWithWhite:0.2 - force * 0.2 alpha:1.0]; }

    // TODO: understand why this stuff is the way it is!
    switch (_forceState) {
        case ForceStateReset:
            if (force >= _activationForce) {
                _forceState = ForceStateActivated;
                [_activationFeedbackGenerator impactOccurred];
            }
            break;
        case ForceStateActivated:
            if (force <= _confirmationForce) {
                _forceState = ForceStateConfirmed;
                [self FI_activate];
            }
            break;
        case ForceStateConfirmed:
            if (force <= _resetForce) {
                _forceState = ForceStateReset;
            }
            break;
    }
    
}

- (void)touchEnded:(UITouch *)touch {
    if (_touchExited) { return; }
    if (_forceState == ForceStateActivated) { [self FI_activate]; }
    _forceState = ForceStateReset;
    [self animateToRest];
}

- (void)FI_activate {
    _isOn = !_isOn;
    _imageView.image = _isOn ? _onImage : _offImage;
    _imageView.tintColor = _isOn ? UIColor.blackColor : UIColor.whiteColor;
    self.backgroundColor = _isOn ? _onColor : _offColor;
    [_confirmationFeedbackGenerator impactOccurred];
}

- (void)animateToRest {
    UISpringTimingParameters *timingParameters = [[UISpringTimingParameters alloc] initWithDamping:0.4 response:0.2 initialVelocity:CGVectorMake(0, 0)];
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:0.0 timingParameters:timingParameters];
    [animator addAnimations:^{
        self.transform = CGAffineTransformMakeScale(1, 1);
        self.backgroundColor = self.isOn ? self.onColor : self.offColor;
    }];
    [animator setInterruptible:YES];
    [animator startAnimation];
}


@end
