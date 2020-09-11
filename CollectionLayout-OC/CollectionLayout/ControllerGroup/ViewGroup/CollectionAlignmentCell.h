//
//  CollectionAlignmentCell.h
//  PinterestDemo
//
//  Created by 苏沫离 on 2018/9/8.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

NS_ASSUME_NONNULL_BEGIN

/** 水平对齐
 */
@interface CollectionAlignmentCell : UICollectionViewCell
@property (nonatomic ,strong) UILabel *itemLable;
@property (nonatomic ,strong) CALayer *backLayer;
@end

NS_ASSUME_NONNULL_END



