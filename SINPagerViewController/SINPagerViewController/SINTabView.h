//
//  SINTabView.h
//  SINPagerViewController
//
//  Created by wf on 2019/11/19.
//  Copyright © 2019 sohu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SINPagerConfig.h"
#import "SINChannelModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SINTabView : UIView

@property (nonatomic, strong) UIFont *defaultTabTxtFont;
@property (nonatomic, strong) UIFont *selecteTabTxtFont;

@property (nonatomic, strong) UIColor *defaultTabTxtColor;
@property (nonatomic, strong) UIColor *selecteTabTxtColor;

@property (nonatomic, copy) void(^clickTabItem)(NSInteger index);

@property (nonatomic, strong) NSMutableArray <SINChannelModel *>*channelModels;

///刷新全部频道
- (void)reloadChannelData;

///插入指定频道
- (void)insertChannelWithIndex:(NSInteger)index;

///删除指定频道
- (void)deleteChannel:(NSArray *)indexPaths;

///移动频道
- (void)moveChannelWithIndex:(NSInteger)index toIndexPath:(NSInteger)toIndex callback:(void(^)(NSInteger cIndex))completion;

- (void)scrollTabItemToIndexPath:(NSInteger)index animated:(BOOL)animated;

- (void)moveLineWithRadio:(CGFloat)radio currentIndex:(NSInteger)currentIndex toIndex:(NSInteger)toIndex;

- (void)setLineViewCenterWithIndex:(NSInteger)index animate:(BOOL)animate;

@end

NS_ASSUME_NONNULL_END
