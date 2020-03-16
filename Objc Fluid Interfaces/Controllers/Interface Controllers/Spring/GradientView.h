//
//  GradientView.h
//  Objc Fluid Interfaces
//
//  Created by Nicholas Cooke on 3/16/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GradientView : UIView

@property (nonatomic) UIColor *topColor;
@property (nonatomic) UIColor *bottomColor;
@property (nonatomic) CGFloat cornerRadius;

@end

NS_ASSUME_NONNULL_END
