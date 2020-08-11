//
//  AlignmentViewController.m
//  PinterestDemo
//
//  Created by 苏沫离 on 2018/9/8.
//  Copyright © 2020 苏沫离. All rights reserved.
//
#define HeaderIdentifer @"CollectionSectionHeaderView"

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

#pragma mark - response click

- (void)rightBarButtonItemClick:(UIButton *)sender{
    YLCollectionAlignmentLayout *flowLayout = (YLCollectionAlignmentLayout *)self.collectionView.collectionViewLayout;
    if ([sender.titleLabel.text isEqualToString:@"右对齐"]) {
        [sender setTitle:@"左对齐" forState:UIControlStateNormal];
        flowLayout.cellAlignmentType = YLCollectionAlignmentLeft;
    }else if ([sender.titleLabel.text isEqualToString:@"左对齐"]){
        [sender setTitle:@"默认" forState:UIControlStateNormal];
        flowLayout.cellAlignmentType = YLCollectionAlignmentDefault;
    }else if ([sender.titleLabel.text isEqualToString:@"默认"]){
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
    return self.dataArray[indexPath.row].alignmentTitleSize;
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    CollectionSectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifer forIndexPath:indexPath];
    return headerView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionAlignmentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(CollectionAlignmentCell.class) forIndexPath:indexPath];
    cell.itemLable.text = self.dataArray[indexPath.row].title;
    return cell;
}

#pragma mark - public method

- (void)reloadData:(NSMutableArray<DataModel *> *)dataArray{
    self.dataArray = dataArray;
    [self.collectionView reloadData];
}

#pragma mark - setter and getter

- (UIButton *)rightButton{
    if (_rightButton == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitleColor:UIColor.redColor forState:UIControlStateNormal];
        [button setTitle:@"右对齐" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(rightBarButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightButton = button;
    }
    return _rightButton;
}

- (NSMutableArray<DataModel *> *)dataArray{
    if(_dataArray == nil){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil){
        YLCollectionAlignmentLayout *flowLayout = [[YLCollectionAlignmentLayout alloc] init];
        flowLayout.alignmentDelegate = self;
        flowLayout.cellAlignmentType = YLCollectionAlignmentRight;
        flowLayout.minimumLineSpacing = 16;//行间距
        flowLayout.minimumInteritemSpacing = 16;//列间距
            
    
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) collectionViewLayout:flowLayout];
        _collectionView.contentInset = UIEdgeInsetsMake(12, 12, 12, 12);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[CollectionAlignmentCell class] forCellWithReuseIdentifier:NSStringFromClass(CollectionAlignmentCell.class)];
        [_collectionView registerClass:CollectionSectionHeaderView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifer];

    }
    return _collectionView;
}

@end
