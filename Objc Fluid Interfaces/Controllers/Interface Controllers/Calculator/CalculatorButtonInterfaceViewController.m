//
//  CalculatorButtonInterfaceViewController.m
//  Objc Fluid Interfaces
//
//  Created by Nicholas Cooke on 3/13/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "CalculatorButtonInterfaceViewController.h"

@interface CalculatorButtonInterfaceViewController ()

@property (nonatomic) CalculatorButton *calculatorButton;

@end

@implementation CalculatorButtonInterfaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Autolayout Button
    self.calculatorButton = CalculatorButton.new;
    self.calculatorButton.value = 9;
    [self.view addSubview:self.calculatorButton];
    self.calculatorButton.translatesAutoresizingMaskIntoConstraints = NO;
    [[self.calculatorButton.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor] setActive:YES];
    [[self.calculatorButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor] setActive:YES];
    
    
    // Programmatic Layout Button
//    self.calculatorButton = [[CalculatorButton alloc] initWithFrame:CGRectMake(0, 0, 75.0, 75.0)];
//    self.calculatorButton.value = 9;
//    [self.view addSubview:self.calculatorButton];
//    self.calculatorButton.translatesAutoresizingMaskIntoConstraints = NO;
//    [[self.calculatorButton.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor] setActive:YES];
//    [[self.calculatorButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor] setActive:YES];
    
}



@end
