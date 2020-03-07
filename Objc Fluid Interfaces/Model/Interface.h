//
//  Interface.h
//  Objc Fluid Interfaces
//
//  Created by Nicholas Cooke on 3/7/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "InterfaceViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface Interface : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) UIImage *icon;
@property (nonatomic) UIColor *color;
@property (nonatomic) InterfaceViewController *type;

@end

NS_ASSUME_NONNULL_END
