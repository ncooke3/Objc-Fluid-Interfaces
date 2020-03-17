//
//  SliderView.h
//  Objc Fluid Interfaces
//
//  Created by Nicholas Cooke on 3/16/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SliderMovedBlock)(CGFloat value); // do i need a param name?
typedef void(^SliderFinishedBlock)(void);

@interface SliderView : UIView

@property (nonatomic) NSString *title;
@property (nonatomic) CGFloat value;
@property (nonatomic) CGFloat minValue;
@property (nonatomic) CGFloat maxValue;

@property (nonatomic, copy) SliderMovedBlock sliderMovedAction;
@property (nonatomic, copy) SliderFinishedBlock sliderFinishedMovingAction;


@end

NS_ASSUME_NONNULL_END
