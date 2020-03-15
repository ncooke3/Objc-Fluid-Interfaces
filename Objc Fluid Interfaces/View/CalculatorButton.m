//
//  CalculatorButton.m
//  Objc Fluid Interfaces
//
//  Created by Nicholas Cooke on 3/13/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "CalculatorButton.h"

@interface CalculatorButton ()

@property (nonatomic) UILabel *label;
@property (nonatomic) UIViewPropertyAnimator *animator;
@property (nonatomic) UIColor *normalColor;
@property (nonatomic) UIColor *highlightedColor;

@end


@implementation CalculatorButton

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _value = 0;
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:36.0 weight:UIFontWeightRegular];
        _label.textColor = UIColor.whiteColor;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.translatesAutoresizingMaskIntoConstraints = NO;
        _animator = [UIViewPropertyAnimator new];
        _normalColor = UIColor.darkGrayColor;
        _highlightedColor = UIColor.lightGrayColor;
        
        self.backgroundColor = _normalColor;
        
        [self addSubview:_label];
        [[_label.centerXAnchor constraintEqualToAnchor:self.centerXAnchor] setActive:YES];
        [[_label.centerYAnchor constraintEqualToAnchor:self.centerYAnchor] setActive:YES];
        [_label setText:@"0"];
        [_label sizeToFit];
        
        [self addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
        [self addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchDragExit | UIControlEventTouchCancel];
        
    }
    return self;
}


# pragma mark - Overrides

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.layer setCornerRadius:self.bounds.size.width / 2];
}


- (CGSize)intrinsicContentSize {
    return CGSizeMake(75.0, 75.0);
}


# pragma mark - Custom Setters

- (void)setValue:(NSInteger)value {
    _value = value;
    _label.text = [NSString stringWithFormat:@"%li", _value];
}


# pragma mark - Handlers

- (void)touchDown {
    [self.animator stopAnimation:YES];
    self.backgroundColor = _highlightedColor;
}

- (void)touchUp {
    self.animator = [[UIViewPropertyAnimator alloc] initWithDuration:0.5 curve:UIViewAnimationCurveEaseOut animations:^{
        self.backgroundColor = self.normalColor;
    }];
    [self.animator startAnimation];
}


@end
