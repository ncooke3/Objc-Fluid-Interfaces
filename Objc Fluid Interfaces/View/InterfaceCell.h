//
//  InterfaceCell.h
//  Objc Fluid Interfaces
//
//  Created by Nicholas Cooke on 3/15/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InterfaceCell : UICollectionViewCell

@property (nonatomic) NSString *title;
@property (nonatomic) UIImage *image;

+ (NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END
