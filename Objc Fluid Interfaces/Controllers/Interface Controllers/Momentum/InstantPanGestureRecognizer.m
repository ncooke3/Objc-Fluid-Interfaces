//
//  InstantPanGestureRecognizer.m
//  Objc Fluid Interfaces
//
//  Created by Nicholas Cooke on 3/19/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "InstantPanGestureRecognizer.h"

@implementation InstantPanGestureRecognizer

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.state = UIGestureRecognizerStateBegan;
}

@end
