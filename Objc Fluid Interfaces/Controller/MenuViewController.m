//
//  MenuViewController.m
//  Objc Fluid Interfaces
//
//  Created by Nicholas Cooke on 3/6/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "MenuViewController.h"


@interface MenuViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

# pragma mark Properties

@property (nonatomic) UICollectionView *collectionView;

@end



@implementation MenuViewController

# pragma mark Class Properties

static UIColor *_darkColor;

+ (UIColor *)darkColor { return [[UIColor alloc] initWithWhite:0.05 alpha:1.0]; }


#pragma mark - Init

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor: MenuViewController.darkColor];

    self.navigationController.navigationBar.topItem.title = @"Fluid Interfaces";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    [self configureCollectionView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    for (UICollectionViewCell *visibleCell in _collectionView.visibleCells) {
        [visibleCell setHighlighted:NO];
    }
    
}

#pragma mark - Handlers
- (void)configureCollectionView {
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:UICollectionViewFlowLayout.new];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView setBackgroundColor:UIColor.clearColor];
    [_collectionView setBounces:YES];
    [_collectionView setAlwaysBounceVertical:YES];
    [_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"cell"];
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_collectionView];
//    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:_collectionView
//                                                                  attribute:NSLayoutAttributeTop
//                                                                  relatedBy:NSLayoutRelationEqual
//                                                                     toItem:self.view.safeAreaLayoutGuide
//                                                                  attribute:NSLayoutAttributeTop
//                                                                 multiplier:1.0 constant:0.0];
//    [self.view addConstraint: constraint];
    
    [NSLayoutConstraint constraintWithItem:_collectionView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0 constant:0.0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_collectionView
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1.0 constant:0.0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_collectionView
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0 constant:0.0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_collectionView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0 constant:0.0].active = YES;
    

    
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *selectedCell = [collectionView cellForItemAtIndexPath:indexPath];
    if (!selectedCell) {
        return;
    }
    
    [selectedCell setHighlighted:YES];
    // choose interface from array
    // create interface view controller
    // set title of vc
    // push vc onto  navigationController
    // change navbar tintcolor to interface color
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    [cell setBackgroundColor:[UIColor.whiteColor colorWithAlphaComponent:0.1]];
    return cell;

}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width, 60);
}

@end


