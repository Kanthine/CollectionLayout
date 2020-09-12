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




@interface YLSheetView : UIView

@property (nonatomic ,strong) UIButton *coverButton;
@property (nonatomic ,strong) UIView *contentView;
@property (nonatomic ,strong) UIButton *cancelButton;
@property (nonatomic ,strong) NSArray<NSString *> *itemArray;
@property (nonatomic ,copy) void(^didSelectedBlock)(YLCollectionTransitionType transitionType,NSString *item);

+ (void)showWithHandle:(void(^)(YLCollectionTransitionType transitionType,NSString *item))handle;

@end

@implementation YLSheetView

+ (void)showWithHandle:(void(^)(YLCollectionTransitionType transitionType,NSString *item))handle{
    YLSheetView *sheet = [[YLSheetView alloc] init];
    sheet.didSelectedBlock = handle;
    [sheet show];
}

- (instancetype)init{
    self = [super init];
    if (self){
        self.frame = UIScreen.mainScreen.bounds;
        [self addSubview:self.coverButton];
        [self addSubview:self.contentView];
    }
    return self;
}

#pragma mark - public method

- (void)show{
    [UIApplication.sharedApplication.delegate.window addSubview:self];
    self.contentView.transform = CGAffineTransformMakeTranslation(0,CGRectGetHeight(self.contentView.bounds));
    self.coverButton.alpha = 0;
    [UIView animateWithDuration:0.20 animations:^{
        self.coverButton.alpha = 1.0;
        self.contentView.transform = CGAffineTransformIdentity;
    }];
}

- (void)dismissButtonClick{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.coverButton.alpha = 0;
        weakSelf.contentView.transform = CGAffineTransformMakeTranslation(0,CGRectGetHeight(weakSelf.contentView.bounds));
    } completion:^(BOOL finished) {
        [weakSelf.coverButton removeFromSuperview];
        weakSelf.coverButton = nil;
        [weakSelf.contentView removeFromSuperview];
        weakSelf.contentView = nil;
        [weakSelf removeFromSuperview];
    }];
}

- (void)handleButtonClick:(UIButton *)sender{
    if (self.didSelectedBlock) {
        self.didSelectedBlock(sender.tag,self.itemArray[sender.tag]);
    }
    [self dismissButtonClick];
}

#pragma mark - getter and setter

- (UIButton *)coverButton{
    if (_coverButton == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [button addTarget:self action:@selector(dismissButtonClick) forControlEvents:UIControlEventTouchUpInside];
        button.frame = UIScreen.mainScreen.bounds;
        _coverButton = button;
    }
    return _coverButton;
}

- (NSArray<NSString *> *)itemArray{
    if (_itemArray == nil) {
        _itemArray = @[@"None",@"Cube",@"Cover",@"Open",
                       @"Pan",@"Card",@"Parallax",@"CrossFade",
                       @"RotateInOut",@"ZoomInOut",];
    }
    return _itemArray;
}

- (UIView *)contentView{
    if (_contentView == nil) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), 124)];
        view.backgroundColor = UIColor.whiteColor;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), 30)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"Transition Type";
        label.textColor = UIColor.blackColor;
        label.font = [UIFont systemFontOfSize:15];
        [view addSubview:label];

        [self.itemArray enumerateObjectsUsingBlock:^(NSString * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = idx;
            [button addTarget:self action:@selector(handleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(12, 30 + 40 * idx, CGRectGetWidth(view.bounds) - 12 * 2.0, 40);
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:[UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1.0] forState:UIControlStateNormal];
            [button setTitle:[NSString stringWithFormat:@"YLCollectionTransition%@",item] forState:UIControlStateNormal];
            [view addSubview:button];
        }];
            
        
        CGFloat height = 30 + 40 * self.itemArray.count + 34;
        view.frame = CGRectMake(0, CGRectGetHeight(UIScreen.mainScreen.bounds) - height, CGRectGetWidth(UIScreen.mainScreen.bounds), height);
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10,10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = view.bounds;
        maskLayer.path = maskPath.CGPath;
        view.layer.mask = maskLayer;
        _contentView = view;
    }
    return _contentView;
}

@end






@interface TransitionAnimationViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation TransitionAnimationViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];

    self.view.backgroundColor = [[UIColor colorWithPatternImage:[UIImage imageNamed:@"CardBack"]] colorWithAlphaComponent:0.9];
    [self.view addSubview:self.collectionView];
}

#pragma mark - response click

- (void)rightBarButtonItemClick:(UIButton *)sender{
    YLCollectionTransitionAnimationLayout *flowLayout = (YLCollectionTransitionAnimationLayout *)self.collectionView.collectionViewLayout;
    
    [YLSheetView showWithHandle:^(YLCollectionTransitionType transitionType, NSString *item) {
        [sender setTitle:item forState:UIControlStateNormal];
        flowLayout.transitionType = transitionType;
    }];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return DataModel.shareDemoData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionTransitionAnimationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifer forIndexPath:indexPath];
    DataModel *model = DataModel.shareDemoData[indexPath.row];
    model.index = indexPath.row;
    cell.model = model;
    return cell;
}

#pragma mark - getter and setter

- (UIButton *)rightButton{
    if (_rightButton == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        button.frame = CGRectMake(0, 0, 80, 40);
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitleColor:UIColor.redColor forState:UIControlStateNormal];
        [button setTitle:@"Cube" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(rightBarButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightButton = button;
    }
    return _rightButton;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        CGFloat itemWidth = CGRectGetWidth(self.view.bounds);
        CGFloat itemHeight = CGRectGetHeight(self.view.bounds) - 120;
        YLCollectionTransitionAnimationLayout *layout = [[YLCollectionTransitionAnimationLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.transitionType = YLCollectionTransitionCube;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, itemWidth, itemHeight) collectionViewLayout:layout];
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
