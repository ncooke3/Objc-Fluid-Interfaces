//
//  PipPositionView.m
//  Objc Fluid Interfaces
//
//  Created by Nicholas Cooke on 3/17/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "PipPositionView.h"

@interface PipPositionView ()

@property (nonatomic) CAShapeLayer *shapeLayer;
@property (nonatomic, readonly) CGFloat lineWidth;

@end


@implementation PipPositionView

- (CGFloat)lineWidth { return 2; }

- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [[CAShapeLayer alloc] init];
        _shapeLayer.strokeColor = [[UIColor colorWithWhite:0.3 alpha:1] CGColor];
        _shapeLayer.lineWidth = self.lineWidth;
    }
    return _shapeLayer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.layer addSublayer:self.shapeLayer];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _shapeLayer.frame = self.bounds;
    _shapeLayer.path = [[UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, self.lineWidth / 2, self.lineWidth / 2) cornerRadius:16.0] CGPath];
}

@end
