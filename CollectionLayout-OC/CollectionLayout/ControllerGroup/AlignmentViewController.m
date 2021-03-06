//
//  AlignmentViewController.m
//  PinterestDemo
//
//  Created by 苏沫离 on 2018/9/8.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#define CellIdentifer @"CollectionAlignmentCell"

#import "AlignmentViewController.h"
#import "CollectionAlignmentCell.h"
#import "YLCollectionAlignmentLayout.h"
#import "CollectionSectionHeaderView.h"

@interface AlignmentViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource,YLCollectionAlignmentLayoutDelegate>
@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *rightButton;
@end

@implementation AlignmentViewController

#pragma mark - life cycyle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
}

#pragma mark - response click

- (void)rightBarButtonItemClick:(UIButton *)sender{
    YLCollectionAlignmentLayout *flowLayout = (YLCollectionAlignmentLayout *)self.collectionView.collectionViewLayout;
    if ([sender.titleLabel.text isEqualToString:@"右对齐"]) {
        [sender setTitle:@"左对齐" forState:UIControlStateNormal];
        flowLayout.cellAlignmentType = YLCollectionAlignmentLeft;
    }else if ([sender.titleLabel.text isEqualToString:@"左对齐"]){
        [sender setTitle:@"右对齐" forState:UIControlStateNormal];
        flowLayout.cellAlignmentType = YLCollectionAlignmentRight;
    }
}

#pragma mark - YLAlignmentFlowLayoutDelegate

-(CGSize)collectionViewElementOfKind:(NSString *)elementOfKind referenceSizeInSection:(NSInteger)section{
    if ([elementOfKind isEqualToString:UICollectionElementKindSectionHeader]) {
        return CGSizeMake(CGRectGetWidth(UIScreen.mainScreen.bounds), 172 / 375.0 * CGRectGetWidth(UIScreen.mainScreen.bounds));
    }
    return CGSizeZero;
}

- (CGSize)collectionViewSizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return DataModel.shareDemoData[indexPath.row].alignmentTitleSize;
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
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
    CollectionAlignmentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifer forIndexPath:indexPath];
    cell.itemLable.text = DataModel.shareDemoData[indexPath.row].title;
    return cell;
}

#pragma mark - setter and getter

- (UIButton *)rightButton{
    if (_rightButton == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitleColor:UIColor.redColor forState:UIControlStateNormal];
        [button setTitle:@"左对齐" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(rightBarButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightButton = button;
    }
    return _rightButton;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil){
        YLCollectionAlignmentLayout *flowLayout = [[YLCollectionAlignmentLayout alloc] init];
         flowLayout.alignmentDelegate = self;
         flowLayout.cellAlignmentType = YLCollectionAlignmentLeft;
         flowLayout.minimumLineSpacing = 16;//行间距
         flowLayout.minimumInteritemSpacing = 16;//列间距
         flowLayout.sectionInset = UIEdgeInsetsMake(0, 12, 20, 12);

        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) collectionViewLayout:flowLayout];
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor whiteColor];
        [collectionView registerClass:[CollectionAlignmentCell class] forCellWithReuseIdentifier:CellIdentifer];
        [collectionView registerClass:CollectionSectionHeaderView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionSectionHeaderIdentifer];
        [collectionView registerClass:CollectionSectionFooterView.class forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kCollectionSectionFooterIdentifer];
        _collectionView = collectionView;
    }

    return _collectionView;
}

@end
