//
//  InterfaceCell.m
//  Objc Fluid Interfaces
//
//  Created by Nicholas Cooke on 3/15/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "InterfaceCell.h"

@interface InterfaceCell ()

@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UILabel *titleLabel;

@end


@implementation InterfaceCell

static NSString* _identifier = @"interfaceCell";

+ (NSString *)reuseIdentifier {
    return _identifier;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = _title;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    _imageView.image = _image;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = false;
        _titleLabel.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightSemibold];
        [self.contentView addSubview:_titleLabel];
        
        UIImageView *chevronImageView = [[UIImageView alloc] init];
        chevronImageView.tintColor = UIColor.darkGrayColor;
        [chevronImageView setImage:[[UIImage imageNamed:@"chevron"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        chevronImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:chevronImageView];
        
        [[chevronImageView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor] setActive:YES];
        [[chevronImageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20.0] setActive:YES];
        [[chevronImageView.leadingAnchor constraintEqualToAnchor:_titleLabel.trailingAnchor constant:20.0] setActive:YES];
        [[chevronImageView.widthAnchor constraintEqualToConstant:7.0] setActive:YES];
        [[chevronImageView.heightAnchor constraintEqualToConstant:13.0] setActive:YES];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.translatesAutoresizingMaskIntoConstraints = false;
        
        // jonathan, how to avoid this?
        [self.contentView addSubview:_imageView];
        
        [[_imageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:18.0] setActive:YES];
        [[_imageView.widthAnchor constraintEqualToConstant:40.0] setActive:YES];
        [[_imageView.heightAnchor constraintEqualToConstant:40.0] setActive:YES];
        [[_imageView.trailingAnchor constraintEqualToAnchor:_titleLabel.leadingAnchor constant:-20.0] setActive:YES];
        [[_imageView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor] setActive:YES];
        


        [[_titleLabel.leadingAnchor constraintEqualToAnchor:_imageView.trailingAnchor constant:20.0] setActive:YES];
        [[_titleLabel.trailingAnchor constraintEqualToAnchor:chevronImageView.leadingAnchor constant:-20.0] setActive:YES];
        [[_titleLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor] setActive:YES];
        
        self.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.1];
        
    }
    return self;
}

- (void) setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    self.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:highlighted ? 0.2 : 0.1];
}


@end

