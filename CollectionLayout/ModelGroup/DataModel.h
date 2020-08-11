//
//  DataModel.h
//  PinterestDemo
//
//  Created by 苏沫离 on 2020/8/10.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

///假数据
@interface DataModel : NSObject
@property (nonatomic ,strong) NSString *title;
@property (nonatomic, strong) NSString *detaile;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) NSInteger index;
+ (void)creatDemoData:(void(^)(NSMutableArray<DataModel *> *array))dataBlock;
@end

///左对齐/右对齐
@interface DataModel (Alignment)
@property (nonatomic ,assign) CGSize alignmentTitleSize;
@end


///瀑布流
@interface DataModel (Pinterest)
@property (nonatomic, assign) CGFloat detaileHeight;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, assign) CGFloat cellHeight;
- (CGFloat)cellHeightByWidth:(CGFloat)width;
@end

NS_ASSUME_NONNULL_END
