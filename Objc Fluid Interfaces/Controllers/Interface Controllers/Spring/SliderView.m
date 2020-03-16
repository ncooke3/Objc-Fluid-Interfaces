//
//  SliderView.m
//  Objc Fluid Interfaces
//
//  Created by Nicholas Cooke on 3/16/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "SliderView.h"

@interface SliderView ()

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UISlider *slider;
@property (nonatomic) UILabel *valueLabel;

@end

@implementation SliderView

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = _title;
}

- (CGFloat)value {
    return _slider.value;
}

- (void)setValue:(CGFloat)value {
    _slider.value = value;
    _valueLabel.text = [NSString stringWithFormat:@"%.2f", value];
}

- (void)setMinValue:(CGFloat)minValue {
    _minValue = minValue;
    _slider.minimumValue = _minValue;
}

- (void)setMaxValue:(CGFloat)maxValue {
    _maxValue = maxValue;
    _slider.maximumValue = _maxValue;
}


#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.sliderFinishedMovingAction = ^(){}; // who knows?
        self.sliderMovedAction = ^(CGFloat floaty){ }; // who knows?
        
        _title = @"";
        _minValue = 0.0;
        _maxValue = 1.0;
        
        // configure titleLabel
        _titleLabel = [[UILabel alloc] init];
        [self addSubview:_titleLabel];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightBold];
        _titleLabel.textColor = UIColor.whiteColor;
        
        [[_titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor] setActive:YES];
        [[_titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor] setActive:YES];
        
        
        // configure slider
        _slider = [[UISlider alloc] init];
        [self addSubview:_slider];
        _slider.translatesAutoresizingMaskIntoConstraints = NO;
        [_slider addTarget:self action:@selector(sliderMoved:event:) forControlEvents:UIControlEventValueChanged];
        
        [[_slider.leadingAnchor constraintEqualToAnchor:self.leadingAnchor] setActive:YES];
        [[_slider.trailingAnchor constraintEqualToAnchor:self.trailingAnchor] setActive:YES];
        [[_slider.bottomAnchor constraintEqualToAnchor:self.bottomAnchor] setActive:YES];
        [[_slider.topAnchor constraintEqualToAnchor:_titleLabel.topAnchor constant:20.0] setActive:YES];
        
        
        // configure valueLabel
        _valueLabel = [[UILabel alloc] init];
        [self addSubview:_valueLabel];
        _valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _valueLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightBold];
        _valueLabel.textColor = UIColor.whiteColor;
        _valueLabel.text = @"0";
        
        [[_valueLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor] setActive:YES];
        [[_valueLabel.lastBaselineAnchor constraintEqualToAnchor:_titleLabel.lastBaselineAnchor] setActive:YES];

    }
    return self;
}


# pragma mark - Handlers

- (void)sliderMoved:(UISlider *)slider event:(UIEvent *)event {
    _valueLabel.text = [NSString stringWithFormat:@"%.2f", slider.value];
    self.sliderMovedAction(slider.value);
    if ([[event.allTouches anyObject] phase] == UITouchPhaseEnded) {
        self.sliderFinishedMovingAction();
    }

}


@end
