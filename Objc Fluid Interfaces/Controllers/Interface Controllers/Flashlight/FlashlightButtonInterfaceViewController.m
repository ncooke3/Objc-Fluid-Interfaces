//
//  FlashlightButtonInterfaceViewController.m
//  Objc Fluid Interfaces
//
//  Created by Nicholas Cooke on 3/13/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "FlashlightButtonInterfaceViewController.h"

@interface FlashlightButtonInterfaceViewController ()

@property (nonatomic) FlashlightButton *flashlightButton;

@end


@implementation FlashlightButtonInterfaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _flashlightButton = [[FlashlightButton alloc] init];
    _flashlightButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_flashlightButton];
    [[_flashlightButton.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor] setActive:YES];
    [[_flashlightButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor] setActive:YES];
    
}


@end
