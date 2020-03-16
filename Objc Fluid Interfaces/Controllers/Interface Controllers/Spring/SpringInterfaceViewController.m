//
//  SpringInterfaceViewController.m
//  Objc Fluid Interfaces
//
//  Created by Nicholas Cooke on 3/15/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "SpringInterfaceViewController.h"


@interface SpringInterfaceViewController ()

@property (nonatomic) GradientView *springView;
@property (nonatomic) SliderView *dampingSliderView;
@property (nonatomic) SliderView *frequencySliderView;

@property (nonatomic) CGFloat dampingRatio;
@property (nonatomic) CGFloat frequencyResponse;
@property (nonatomic) CGFloat margin;

@property (nonatomic) UIViewPropertyAnimator *animator;

@end


@implementation SpringInterfaceViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dampingRatio = 0.5;
    _frequencyResponse = 1.0;
    _margin = 30;
    
    _animator = [[UIViewPropertyAnimator alloc] init];
    
    __weak typeof(self) weakSelf = self;
    
    // DAMPING SLIDER VIEW
    _dampingSliderView = [[SliderView alloc] init];
    _dampingSliderView.translatesAutoresizingMaskIntoConstraints = NO;
    _dampingSliderView.title = @"DAMPING (BOUNCINESS)";
    _dampingSliderView.minValue = 0.1;
    _dampingSliderView.maxValue = 1.0;
    _dampingSliderView.value = _dampingRatio;
    _dampingSliderView.sliderMovedAction = ^(CGFloat sliderValue) { weakSelf.dampingRatio = sliderValue; };
    _dampingSliderView.sliderFinishedMovingAction = ^{ [weakSelf resetAnimation]; };
    
    [self.view addSubview:_dampingSliderView];
    [[_dampingSliderView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:_margin] setActive:YES];
    [[_dampingSliderView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-_margin] setActive:YES];
    [[_dampingSliderView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor] setActive:YES];
    
    
    // FREQUENCY SLIDER VIEW
    _frequencySliderView = [[SliderView alloc] init];
    _frequencySliderView.translatesAutoresizingMaskIntoConstraints = NO;
    _frequencySliderView.title = @"RESPONSE (SPEED)";
    _frequencySliderView.minValue = 0.1;
    _frequencySliderView.maxValue = 2;
    _frequencySliderView.value = _frequencyResponse;
    _frequencySliderView.sliderMovedAction = ^(CGFloat sliderValue) { weakSelf.frequencyResponse = sliderValue; };
    _frequencySliderView.sliderFinishedMovingAction = ^{ [weakSelf resetAnimation]; };

    
    [self.view addSubview:_frequencySliderView];
    [[_frequencySliderView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:_margin] setActive:YES];
    [[_frequencySliderView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-_margin] setActive:YES];
    [[_frequencySliderView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:140] setActive:YES];
    
    
    // SPRING VIEW
    _springView = [[GradientView alloc] init];
    _springView.translatesAutoresizingMaskIntoConstraints = NO;
    _springView.topColor = [UIColor colorWithRed:0.39 green:0.80 blue:0.97 alpha:1.0];;
    _springView.bottomColor = [UIColor colorWithRed:0.21 green:0.62 blue:0.93 alpha:1.0];
    
    [self.view addSubview:_springView];
    [[_springView.heightAnchor constraintEqualToConstant:80.0] setActive:YES];
    [[_springView.widthAnchor constraintEqualToConstant:80.0] setActive:YES];
    [[_springView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:_margin] setActive:YES];
    [[_springView.bottomAnchor constraintEqualToAnchor:_dampingSliderView.topAnchor constant:-80] setActive:YES];
    
    
    [self animateView];
    
}

/// Repeatedly animates the view using the current `dampingRatio` and `frequencyResponse`.
- (void)animateView {
    UISpringTimingParameters *timingParameters = [[UISpringTimingParameters alloc] initWithDamping:_dampingRatio response:_frequencyResponse initialVelocity:CGVectorMake(0, 0)];
    _animator = [[UIViewPropertyAnimator alloc] initWithDuration:0 timingParameters:timingParameters];
    __weak typeof(self) weakSelf = self;
    [_animator addAnimations:^{
        CGFloat translation = self.view.bounds.size.width - 2 * self.margin - 80;
        weakSelf.springView.transform = CGAffineTransformMakeTranslation(translation, 0);
    }];
    [_animator addCompletion:^(UIViewAnimatingPosition _) {
        weakSelf.springView.transform = CGAffineTransformIdentity;
        [weakSelf animateView];
    }];
    [_animator startAnimation];
}

- (void)resetAnimation {
    [_animator stopAnimation:YES];
    _springView.transform = CGAffineTransformIdentity;
    [self animateView];
}

@end
