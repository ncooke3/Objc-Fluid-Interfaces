//
//  GradientView.m
//  Objc Fluid Interfaces
//
//  Created by Nicholas Cooke on 3/16/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "GradientView.h"

@interface GradientView ()

@property (nonatomic) CAGradientLayer *gradientLayer;

@end


@implementation GradientView

# pragma mark - Custom Getters/Setters

- (void)setTopColor:(UIColor *)topColor {
    _topColor = topColor;
    [self updateGradientColors];
}

- (void)setBottomColor:(UIColor *)bottomColor {
    _bottomColor = bottomColor;
    [self updateGradientColors];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self layoutSubviews];
}

- (CAGradientLayer *)gradientLayer {
    if (_gradientLayer == nil) {
        _gradientLayer = [[CAGradientLayer alloc] init];
        _gradientLayer.colors = @[(id)_topColor.CGColor, (id)_bottomColor.CGColor];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(0, 1);
    }
    return _gradientLayer;
}


#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _topColor = UIColor.whiteColor;
        _bottomColor = UIColor.blackColor;
        [self.layer addSublayer:self.gradientLayer];
    }
    return self;
}


# pragma mark - Overrides

- (void)layoutSubviews {
    [super layoutSubviews];
    [_gradientLayer setFrame:self.bounds];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:_cornerRadius ? _cornerRadius : self.bounds.size.width * 0.2];
    maskLayer.path = bezierPath.CGPath;
    self.layer.mask = maskLayer;
}


#pragma mark - Utility

- (void)updateGradientColors {
    _gradientLayer.colors = @[(id)_topColor.CGColor, (id)_bottomColor.CGColor];
}



@end
