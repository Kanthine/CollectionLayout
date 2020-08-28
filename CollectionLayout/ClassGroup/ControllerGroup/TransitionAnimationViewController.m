//
//  TransitionAnimationViewController.m
//  CollectionLayout
//
//  Created by 苏沫离 on 2020/8/28.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#define CellIdentifer @"CollectionTransitionAnimationCell"

#import "TransitionAnimationViewController.h"
#import "DataModel.h"
#import "CollectionTransitionAnimationCell.h"
#import "YLCollectionTransitionAnimationLayout.h"

@interface TransitionAnimationViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic ,strong) NSMutableArray<DataModel *> *dataArray;
@property (nonatomic ,strong) UICollectionView *collectionView;

@end

@implementation TransitionAnimationViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [[UIColor colorWithPatternImage:[UIImage imageNamed:@"CardBack"]] colorWithAlphaComponent:0.9];
    [self.view addSubview:self.collectionView];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}

#pragma mark - public method

- (void)reloadData:(NSMutableArray<DataModel *> *)dataArray{
    self.dataArray = dataArray;
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionTransitionAnimationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifer forIndexPath:indexPath];
    DataModel *model = self.dataArray[indexPath.row];
    model.index = indexPath.row;
    cell.model = model;
    return cell;
}

#pragma mark - getter and setter

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        YLCollectionTransitionAnimationLayout *layout = [[YLCollectionTransitionAnimationLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 40);
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.pagingEnabled = YES;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        [collectionView registerClass:CollectionTransitionAnimationCell.class forCellWithReuseIdentifier:CellIdentifer];
        collectionView.backgroundColor = UIColor.clearColor;
        _collectionView = collectionView;
    }
    return _collectionView;
}
@end
