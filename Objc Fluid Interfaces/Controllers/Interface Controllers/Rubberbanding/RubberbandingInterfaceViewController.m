//
//  RubberbandingInterfaceViewController.m
//  Objc Fluid Interfaces
//
//  Created by Nicholas Cooke on 3/13/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "RubberbandingInterfaceViewController.h"

@interface RubberbandingInterfaceViewController ()

@property (nonatomic) GradientView *rubberView;
@property (nonatomic) UIPanGestureRecognizer *panGesture;
@property (nonatomic) CGPoint originalTouchPoint;
@property (nonatomic) BOOL rubberViewCanHorizontallyMove;

@end


@implementation RubberbandingInterfaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _rubberView = [[GradientView alloc] init];
    _rubberView.translatesAutoresizingMaskIntoConstraints = NO;
    _rubberView.topColor = [UIColor colorWithRed:1.00 green:0.36 blue:0.31 alpha:1.0];;
    _rubberView.bottomColor = [UIColor colorWithRed:1.00 green:0.79 blue:0.31 alpha:1.0];;
    [self.view addSubview:_rubberView];
    [[_rubberView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor] setActive:YES];
    [[_rubberView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor] setActive:YES];
    [[_rubberView.widthAnchor constraintEqualToConstant:160] setActive:YES];
    [[_rubberView.heightAnchor constraintEqualToConstant:160] setActive:YES];
    
    _panGesture = [[UIPanGestureRecognizer alloc] init];
    [_panGesture addTarget:self action:@selector(pannedWithRecognizer:)];
    [_rubberView addGestureRecognizer:_panGesture];
    
    _originalTouchPoint = CGPointZero;
    _rubberViewCanHorizontallyMove = NO;
    // TODO: add button or even a gesture to do this!
    //_rubberViewCanHorizontallyMove = YES;
    
}


#pragma mark - Handlers

- (void)pannedWithRecognizer:(UIPanGestureRecognizer *)recognizer {
    CGPoint touchPoint = [recognizer locationInView:self.view];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            _originalTouchPoint = touchPoint;
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            
            CGFloat offsetX = _rubberViewCanHorizontallyMove ? touchPoint.x - _originalTouchPoint.x : 0;
            offsetX = offsetX > 0 ? powf(offsetX, 0.7) : -powf(-offsetX, 0.7);
            
            CGFloat offsetY = touchPoint.y - _originalTouchPoint.y;
            offsetY = offsetY > 0 ? powf(offsetY, 0.7) : -powf(-offsetY, 0.7);
            
            _rubberView.transform = CGAffineTransformMakeTranslation(offsetX, offsetY);
            break;
        }
        case UIGestureRecognizerStateEnded: case UIGestureRecognizerStateCancelled:
        {
            UISpringTimingParameters *timingParameters = [[UISpringTimingParameters alloc] initWithDamping:0.6 response:0.3 initialVelocity:CGVectorMake(0, 0)];
            UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:0.0 timingParameters:timingParameters];
            __weak typeof(self) weakSelf = self;
            [animator addAnimations:^{
                weakSelf.rubberView.transform = CGAffineTransformIdentity;
            }];
            [animator setInterruptible:YES];
            [animator startAnimation];
            break;
        }
        default:
        {
            break;
        }
            
    }

}

@end
