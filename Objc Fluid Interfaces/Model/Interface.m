//
//  Interface.m
//  Objc Fluid Interfaces
//
//  Created by Nicholas Cooke on 3/7/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "Interface.h"

@implementation Interface

- (instancetype)initWithName:(NSString *)name
                        icon:(UIImage *)icon
                       color:(UIColor *)color
                        type:(InterfaceViewController *) type {
    self = [super init];
    if (self) {
        _name = name;
        _icon = icon;
        _color = color;
        _type = type;
    }
    return self;
}



+ (NSArray<Interface *> *)all {
    Interface *calculatorButton = [[Interface alloc] initWithName:@"Calculator Button"
                                                             icon:[UIImage imageNamed:@"icon_calc"]
                                                            color:[UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.0]
                                                             type:CalculatorButtonInterfaceViewController.self];
    
    Interface *springAnimations = [[Interface alloc] initWithName:@"Spring Animations"
                                                             icon:[UIImage imageNamed:@"icon_spring"]
                                                            color:[UIColor colorWithRed:0.49 green:0.79 blue:0.95 alpha:1.0]
                                                             type:SpringInterfaceViewController.self];

    Interface *flashlightButton = [[Interface alloc] initWithName:@"Flashlight Button"
                                                             icon:[UIImage imageNamed:@"icon_flash"]
                                                            color:[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0]
                                                             type:FlashlightButtonInterfaceViewController.self];
    
    Interface *rubberbanding = [[Interface alloc] initWithName:@"Rubberbanding"
                                                             icon:[UIImage imageNamed:@"icon_rubber"]
                                                            color:[UIColor colorWithRed:0.93 green:0.40 blue:0.35 alpha:1.0]
                                                             type:RubberbandingInterfaceViewController.self];
    
    Interface *accelerationPausing = [[Interface alloc] initWithName:@"Acceleration Pausing"
                                                                icon:[UIImage imageNamed:@"icon_acceleration"]
                                                            color:[UIColor colorWithRed:0.57 green:0.98 blue:0.60 alpha:1.0]
                                                             type:AccelerationInterfaceViewController.self];
    
    Interface *rewardingMomentum = [[Interface alloc] initWithName:@"Rewarding Momentum"
                                                             icon:[UIImage imageNamed:@"icon_momentum"]
                                                            color:[UIColor colorWithRed:0.50 green:0.70 blue:0.98 alpha:1.0]
                                                             type:MomentumInterfaceViewController.self];
    
    Interface *facetimePip = [[Interface alloc] initWithName:@"FaceTime PiP"
                                                             icon:[UIImage imageNamed:@"icon_pip"]
                                                            color:[UIColor colorWithRed:0.95 green:0.94 blue:0.36 alpha:1.0]
                                                             type:PipInterfaceViewController.self];
    
    Interface *rotation = [[Interface alloc] initWithName:@"Rotation"
                                                             icon:[UIImage imageNamed:@"icon_rotation"]
                                                            color:[UIColor colorWithRed:0.92 green:0.27 blue:0.64 alpha:1.0]
                                                             type:RotationInterfaceViewController.self];
    
    return @[
        calculatorButton,
        springAnimations,
        flashlightButton,
        rubberbanding,
        accelerationPausing,
        rewardingMomentum,
        facetimePip,
        rotation,
    ];
    
}

@end

