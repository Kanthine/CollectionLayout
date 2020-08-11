//
//  PinterestCollectionCell.h
//  CollectionLayout
//
//  Created by 苏沫离 on 2020/8/11.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PinterestCollectionCell : UICollectionViewCell
@property (nonatomic ,strong) DataModel *model;
@end

NS_ASSUME_NONNULL_END
