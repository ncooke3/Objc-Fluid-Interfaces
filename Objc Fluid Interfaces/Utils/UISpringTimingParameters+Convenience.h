//
//  UISpringTimingParameters+Convenience.h
//  Objc Fluid Interfaces
//
//  Created by Nicholas Cooke on 3/16/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISpringTimingParameters (Convenience)

/// A design-friendly way to create a spring timing curve.
///
/// - Parameters:
///   - damping: The 'bounciness' of the animation. Value must be between 0 and 1.
///   - response: The 'speed' of the animation.
///   - initialVelocity: The vector describing the starting motion of the property. Optional, default is `.zero`.
- (instancetype)initWithDamping:(CGFloat)damping response:(CGFloat)response initialVelocity:(CGVector)initialVelocity;

@end

