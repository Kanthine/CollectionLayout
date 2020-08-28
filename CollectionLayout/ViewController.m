//
//  ViewController.m
//  CollectionLayout
//
//  Created by 苏沫离 on 2020/8/11.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import "ViewController.h"
#import "CollectionAlignmentCell.h"

@interface UIViewController (Data)
- (void)reloadData:(NSMutableArray<DataModel *> *)dataArray;

@end

@implementation UIViewController (Data)
- (void)reloadData:(NSMutableArray<DataModel *> *)dataArray{}
@end


@interface ViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) NSMutableArray<NSDictionary<NSString * ,NSString *> *> *itemArray;
@property (nonatomic ,strong) NSMutableArray<DataModel *> *dataArray;
@end

@implementation ViewController

#pragma mark - life cycyle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Flow Layout";
    
    [self.view addSubview:self.collectionView];
    [DataModel creatDemoData:^(NSMutableArray<DataModel *> * _Nonnull array) {
        self.dataArray = array;
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.itemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionAlignmentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(CollectionAlignmentCell.class) forIndexPath:indexPath];
    cell.itemLable.text = self.itemArray[indexPath.row].allKeys.firstObject;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc = [[NSClassFromString(self.itemArray[indexPath.row].allValues.firstObject) alloc] init];
    vc.navigationItem.title = self.itemArray[indexPath.row].allKeys.firstObject;
    [self.navigationController pushViewController:vc animated:YES];
    [vc reloadData:self.dataArray];
}

#pragma mark - setter and getter

- (NSMutableArray<NSDictionary<NSString *,NSString *> *> *)itemArray{
    if(_itemArray == nil){
        _itemArray = [NSMutableArray array];
        [_itemArray addObject:@{@"左对齐/右对齐":@"AlignmentViewController"}];
        [_itemArray addObject:@{@"瀑布流":@"PinterestViewController"}];
        [_itemArray addObject:@{@"卡片覆盖效果":@"CardViewController"}];
        [_itemArray addObject:@{@"卡片轮转效果":@"CardReelViewController"}];
        [_itemArray addObject:@{@"过渡动画":@"TransitionAnimationViewController"}];
    }
    return _itemArray;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 16;//垂直间距
        flowLayout.itemSize = CGSizeMake(CGRectGetWidth(self.view.bounds) - 24, 44);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) collectionViewLayout:flowLayout];
        _collectionView.contentInset = UIEdgeInsetsMake(12, 12, 12, 12);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[CollectionAlignmentCell class] forCellWithReuseIdentifier:NSStringFromClass(CollectionAlignmentCell.class)];
    }
    return _collectionView;
}

@end
