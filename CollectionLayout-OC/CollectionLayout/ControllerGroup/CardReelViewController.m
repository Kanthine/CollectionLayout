//
//  CardReelViewController.m
//  CollectionLayout
//
//  Created by 苏沫离 on 2020/8/12.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#define CellIdentifer @"CollectionCardCell"

#import "CardReelViewController.h"
#import "DataModel.h"
#import "CollectionCardCell.h"
#import "YLCollectionReelLayout.h"

@interface CardReelViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic ,strong) UICollectionView *collectionView;

@end

@implementation CardReelViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [[UIColor colorWithPatternImage:[UIImage imageNamed:@"CardBack"]] colorWithAlphaComponent:0.9];
    [self.view addSubview:self.collectionView];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return DataModel.shareDemoData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifer forIndexPath:indexPath];
    DataModel *model = DataModel.shareDemoData[indexPath.row];
    model.index = indexPath.row;
    cell.model = model;
    return cell;
}

#pragma mark - getter and setter

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        YLCollectionReelLayout *layout = [[YLCollectionReelLayout alloc] init];
        layout.itemSize = CGSizeMake(200, 240);
        layout.radius = 500;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds),  CGRectGetWidth(self.view.bounds)) collectionViewLayout:layout];
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
