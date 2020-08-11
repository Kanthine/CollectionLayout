//
//  AlignmentViewController.h
//  PinterestDemo
//
//  Created by 苏沫离 on 2020/8/10.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
///左对齐、右对齐
@class DataModel;
@interface AlignmentViewController : UIViewController
@property (nonatomic ,strong) NSMutableArray<DataModel *> *dataArray;
@end



NS_ASSUME_NONNULL_END
