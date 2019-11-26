//
//  SINPagerViewController.h
//  SINPagerViewController
//
//  Created by wf on 2019/11/19.
//  Copyright © 2019 sohu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SINChannelModel.h"
#import "SINTabView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SINPagerViewControllerDataSource <NSObject>

@required
- (NSArray <SINChannelModel *>*)channelModelsInTabView:(SINTabView *)tabView;

- (NSUInteger)numberOfViewControllersInPagerView:(UIScrollView *)pagerView;

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index inPageView:(UIScrollView *)pagerView;

@end

@protocol SINPagerViewControllerDelegate <NSObject>

@optional
- (void)viewControllerWillDisplay:(UIViewController *)viewController atIndex:(NSUInteger)index inPagerView:(UIScrollView *)pagerView;

- (void)viewControllerDidEndDisplay:(UIViewController *)viewController atIndex:(NSUInteger)index inPagerView:(UIScrollView *)pagerView;

- (void)didSelecteTabItem:(NSInteger)index tabView:(SINTabView *)tabView;

@end

@interface SINPagerViewController : UIViewController<SINPagerViewControllerDelegate, SINPagerViewControllerDataSource>

@property (nonatomic, weak) id<SINPagerViewControllerDataSource> dataSource;

@property (nonatomic, weak) id<SINPagerViewControllerDelegate> delegate;

@property (nonatomic, strong) SINTabView *tabView;

///滚动到第几页
- (void)scrollToIndex:(NSUInteger)index animated:(BOOL)animated;

/// 插入频道
/// @param channelModel 要插入的频道
/// @param index 插入的位置
- (void)insertChannel:(SINChannelModel *)channelModel insertIndex:(NSInteger)index;

///删除频道
- (void)deleteChannelWithIndex:(NSInteger)index;

///移动频道
- (void)moveChannelWithIndex:(NSInteger)index toIndex:(NSInteger)toIndex;

@end

NS_ASSUME_NONNULL_END
