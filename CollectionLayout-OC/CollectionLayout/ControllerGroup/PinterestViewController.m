//
//  PinterestViewController.m
//  PinterestDemo
//
//  Created by 苏沫离 on 2020/8/10.
//  Copyright © 2020 苏沫离. All rights reserved.
//
#define CellIdentifer @"PinterestCollectionCell"


#import "PinterestViewController.h"
#import "PinterestCollectionCell.h"
#import "YLCollectionPinterestLayout.h"
#import "CollectionSectionHeaderView.h"

@interface PinterestViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource,
YLCollectionPinterestLayoutDelegate>
@property (nonatomic ,strong) UICollectionView *collectionView;

@end

@implementation PinterestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.collectionView];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
}

#pragma mark - YLCollectionViewLayoutDelegate

-(CGSize)YLLayout:(YLCollectionPinterestLayout *)layout elementOfKind:(NSString *)elementOfKind referenceSizeInSection:(NSInteger)section{
    if ([elementOfKind isEqualToString:UICollectionElementKindSectionHeader]) {
        return CGSizeMake(CGRectGetWidth(UIScreen.mainScreen.bounds), 172 / 375.0 * CGRectGetWidth(UIScreen.mainScreen.bounds));
    }
    return CGSizeMake(CGRectGetWidth(UIScreen.mainScreen.bounds), 0.1);
}

- (CGFloat)YLLayout:(YLCollectionPinterestLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth{
    DataModel *model = DataModel.shareDemoData[indexPath.row];
    return [model cellHeightByWidth:itemWidth];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return DataModel.shareDemoData.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        CollectionSectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionSectionHeaderIdentifer forIndexPath:indexPath];
        return headerView;
    }
    CollectionSectionFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kCollectionSectionFooterIdentifer forIndexPath:indexPath];
    return footerView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PinterestCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifer forIndexPath:indexPath];
    cell.model = DataModel.shareDemoData[indexPath.row];
    return cell;
}

#pragma mark - getter and setter

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        YLCollectionPinterestLayout *layout = [[YLCollectionPinterestLayout alloc] init];
        CGFloat width = (CGRectGetWidth(UIScreen.mainScreen.bounds) - 16 * 2.0 - 12) / 2.0;
        layout.itemSize = CGSizeMake(width, 123 / 165.0 * width + 24);
        layout.delegate = self;

        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        [collectionView registerClass:CollectionSectionHeaderView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionSectionHeaderIdentifer];
        [collectionView registerClass:CollectionSectionFooterView.class forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kCollectionSectionFooterIdentifer];
        [collectionView registerClass:PinterestCollectionCell.class forCellWithReuseIdentifier:CellIdentifer];
        collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView = collectionView;
    }
    return _collectionView;
}

@end
