//
//  MenuViewController.m
//  Objc Fluid Interfaces
//
//  Created by Nicholas Cooke on 3/6/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "MenuViewController.h"


@interface MenuViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic) UICollectionView *collectionView;

@end



@implementation MenuViewController

# pragma mark Class Properties

static UIColor *_darkColor;

+ (UIColor *)darkColor {
    if (_darkColor == nil) {
        _darkColor = [UIColor colorWithWhite:0.05 alpha:1.0];
    }
    return _darkColor;
}

static NSArray<Interface *> *_interfaces;

+ (NSArray<Interface *> *)interfaces { return [Interface all]; }


#pragma mark - Init

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor: MenuViewController.darkColor];
    
    self.navigationController.navigationBar.topItem.title = @"Objc Fluid Interfaces";
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
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    [_collectionView setBackgroundColor:UIColor.clearColor];
    [_collectionView setBounces:YES];
    [_collectionView setAlwaysBounceVertical:YES];
    [_collectionView registerClass:InterfaceCell.class forCellWithReuseIdentifier:InterfaceCell.reuseIdentifier];
    [_collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
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
    [selectedCell setHighlighted:YES];
    
    Interface *interface = MenuViewController.interfaces[indexPath.row];
    InterfaceViewController *viewController = [[[interface.type class] alloc] init];
    [viewController setTitle:interface.name];
    
    [self.navigationController pushViewController:viewController animated:YES];
    viewController.navigationController.navigationBar.tintColor = interface.color;
    
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return MenuViewController.interfaces.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    InterfaceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:InterfaceCell.reuseIdentifier forIndexPath:indexPath];
    
    Interface *interface = MenuViewController.interfaces[indexPath.row];
    
    cell.title = interface.name;
    cell.image = interface.icon;
    
    return cell;

}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width, 60);
}

@end


