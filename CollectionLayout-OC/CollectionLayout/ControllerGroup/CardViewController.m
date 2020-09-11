//
//  CardViewController.m
//  CollectionLayout
//
//  Created by 苏沫离 on 2020/8/11.
//  Copyright © 2020 苏沫离. All rights reserved.
//
#define CellIdentifer @"CollectionCardCell"

#import "CardViewController.h"
#import "DataModel.h"
#import "CollectionCardCell.h"
#import "YLCollectionCardLayout.h"

@interface CardViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic ,strong) NSMutableArray<NSNumber *> *indexArray;
@property (nonatomic ,strong) NSMutableArray<DataModel *> *dataArray;
@property (nonatomic ,strong) UICollectionView *collectionView;

@end

@implementation CardViewController

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
    NSInteger count = self.dataArray.count;
    [self.indexArray removeAllObjects];
    for (int i = 0; i < 100; i++) {
        for (int j = 0; j < count; j++) {
            [self.indexArray addObject:@(j)];
        }
    }
    // 定位到 第50组(中间那组)
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:100 / 2 * count inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

#pragma mark - UICollectionViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint pointInView = [self.view convertPoint:self.collectionView.center toView:self.collectionView];
    NSIndexPath *indexPathNow = [self.collectionView indexPathForItemAtPoint:pointInView];
    NSInteger index = indexPathNow.row % self.dataArray.count;
    
    // 动画停止, 重新定位到 第50组(中间那组) 模型
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:100 / 2 * self.dataArray.count + index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.indexArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifer forIndexPath:indexPath];
    NSInteger index = self.indexArray[indexPath.row].integerValue;
    DataModel *model = self.dataArray[index];
    model.index = index;
    cell.model = model;
    return cell;
}

#pragma mark - getter and setter

- (NSMutableArray<NSNumber *> *)indexArray{
    if (_indexArray == nil) {
        _indexArray = [NSMutableArray array];
    }
    return _indexArray;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        YLCollectionCardLayout *layout = [[YLCollectionCardLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        CGRect frame;
        if (layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
            frame = self.view.bounds;
            layout.itemSize = CGSizeMake(CGRectGetWidth(UIScreen.mainScreen.bounds) - 40.0, CGRectGetWidth(UIScreen.mainScreen.bounds));
        }else{
            layout.itemSize = CGSizeMake(CGRectGetWidth(UIScreen.mainScreen.bounds) - 160.0, CGRectGetWidth(UIScreen.mainScreen.bounds) - 120);
            frame = CGRectMake(0, 100, CGRectGetWidth(self.view.bounds),  CGRectGetWidth(self.view.bounds));
        }
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        [collectionView registerClass:CollectionCardCell.class forCellWithReuseIdentifier:CellIdentifer];
        collectionView.backgroundColor = UIColor.clearColor;
        _collectionView = collectionView;
    }
    return _collectionView;
}
@end
