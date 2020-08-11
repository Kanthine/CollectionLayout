//
//  CardViewController1.m
//  CollectionLayout
//
//  Created by 苏沫离 on 2020/8/11.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import "CardViewController1.h"

#import "DataModel.h"
#import "CollectionCardCell.h"

#import "iCarousel.h"

@interface CardViewController1 ()
<iCarouselDataSource, iCarouselDelegate,UINavigationControllerDelegate>

{
    iCarousel *_cardView;
}

@property (nonatomic ,strong) NSMutableArray<DataModel *> *dataArray;

@end

@implementation CardViewController1

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [[UIColor colorWithPatternImage:[UIImage imageNamed:@"CardBack"]] colorWithAlphaComponent:0.9];
    _cardView = [[iCarousel alloc]initWithFrame:CGRectMake(0, 20, CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetHeight(self.view.bounds) - 49 - 30)];
    _cardView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_cardView];
    
    _cardView.clipsToBounds = YES;
    _cardView.delegate = self;
    _cardView.dataSource = self;
    _cardView.type = iCarouselTypeCoverFlow;
    _cardView.vertical = YES;
    _cardView.bounces = NO;
    _cardView.scrollToItemBoundary = YES;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    _cardView.frame = self.view.bounds;
}
#pragma mark - public method

- (void)reloadData:(NSMutableArray<DataModel *> *)dataArray{
    self.dataArray = dataArray;
    [_cardView reloadData];
}

#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return self.dataArray.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(CollectionCardCell *)cell{
    if (cell == nil){
        cell = [[CollectionCardCell alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds) - 40.0, CGRectGetWidth(UIScreen.mainScreen.bounds))];
    }
    DataModel *model = self.dataArray[index];
    model.index = index;
    cell.model = model;
    return cell;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    if (option == iCarouselOptionSpacing){
        return value * 1.1;
    }else if (option == iCarouselOptionWrap){
        return 1;
    }
    return value;
}

@end
