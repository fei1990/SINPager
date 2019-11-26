//
//  SINPagerViewController.m
//  SINPagerViewController
//
//  Created by wf on 2019/11/19.
//  Copyright © 2019 sohu. All rights reserved.
//

#import "SINPagerViewController.h"
#import "SINTabView.h"
#import "ViewController1.h"

@interface SINPagerViewController ()

@property (nonatomic, strong) UIScrollView *pagerView;       //容器

@property (nonatomic, strong) NSMutableDictionary *pagerVcs;  //controller集合 key为当前索引，value为当前controller

@property (nonatomic) NSUInteger nums;  //controller的数量

@property (nonatomic, strong) NSMutableArray *tmpChannelModels;

@property (nonatomic) NSInteger currentIndex;  //记录当前page

@property (nonatomic, assign) CGFloat lastContentOffset;  //记录偏移量，用来判断滑动方向

@end

@implementation SINPagerViewController

-(NSMutableArray *)tmpChannelModels {
    if (!_tmpChannelModels) {
        _tmpChannelModels = [NSMutableArray array];
        for (int i = 0; i < 23; i ++) {
            SINChannelModel *model = [[SINChannelModel alloc]init];
            model.cid = i + 1;
            model.title = [NSString stringWithFormat:@"搜狐%d", i + 10];
            [_tmpChannelModels addObject:model];
        }
    }
    return _tmpChannelModels;
}

- (NSMutableDictionary *)pagerVcs {
    if (!_pagerVcs) {
        _pagerVcs = [NSMutableDictionary dictionary];
    }
    return _pagerVcs;
}

-(SINTabView *)tabView {
    if (!_tabView) {
        _tabView = [[SINTabView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.view.frame), CGRectGetWidth([UIScreen mainScreen].bounds), 40)];
        __weak typeof(self) weakSelf = self;
        _tabView.clickTabItem = ^(NSInteger index) {
            UIViewController *vc = [weakSelf viewControllerForIndex:index];
            if (!vc) {
                [weakSelf showViewControllerForIndex:index];
            }
            
            [weakSelf.tabView setLineViewCenterWithIndex:index animate:YES];
            [weakSelf scrollToIndex:index animated:NO];
        
            if ([weakSelf.delegate respondsToSelector:@selector(didSelecteTabItem:tabView:)]) {
                [weakSelf.delegate didSelecteTabItem:index tabView:weakSelf.tabView];
            }
            
        };
    }
    return _tabView;
}

- (UIScrollView *)pagerView {
    if (!_pagerView) {
        _pagerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tabView.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(self.tabView.frame))];
        _pagerView.delegate = (id<UIScrollViewDelegate>)self;
        _pagerView.backgroundColor = [UIColor whiteColor];
        _pagerView.pagingEnabled = YES;
        _pagerView.alwaysBounceVertical = NO;
        _pagerView.alwaysBounceHorizontal = NO;
        _pagerView.bounces = NO;
//        _pagerView.showsVerticalScrollIndicator = NO;
//        _pagerView.showsHorizontalScrollIndicator = NO;
    }
    return _pagerView;
}

#pragma mark - setter
- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
//    self.tabView.selectedChannel = currentIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc] initWithTitle:@"add1" style:UIBarButtonItemStylePlain target:self action:@selector(add1)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"add" style:UIBarButtonItemStylePlain target:self action:@selector(add)];
    self.navigationItem.rightBarButtonItems = @[rightItem1, rightItem];
    
    self.delegate = self;
    
    self.dataSource = self;
    
    [self.view addSubview:self.tabView];
    
    [self.view addSubview:self.pagerView];
    
    [self reloadData];

    [self scrollToIndex:3 animated:NO];
    
}

- (void)add {
    
    SINChannelModel *model = [[SINChannelModel alloc] init];
    model.cid = 24;
    model.title = @"搜狐34443";
    [self insertChannel:model insertIndex:0];
    
}

- (void)add1 {
//    [self scrollToIndex:0 animated:NO];
//    [self deleteChannelWithIndex:3];
    [self moveChannelWithIndex:5 toIndex:2];
}

#pragma mark -
- (void)scrollToIndex:(NSUInteger)index animated:(BOOL)animated {
    self.currentIndex = index;
    [self.pagerView setContentOffset:CGPointMake(CGRectGetWidth(self.pagerView.frame) * index, 0) animated:animated];
    UIViewController *vc = [self viewControllerForIndex:index];
    if (!vc) {
        [self showViewControllerForIndex:index];
    }
    [self.tabView scrollTabItemToIndexPath:index animated:YES];
}

- (void)insertChannel:(SINChannelModel *)channelModel insertIndex:(NSInteger)index {
    
    NSMutableArray *tmpChannels = [self.tabView.channelModels mutableCopy];
    if (index <= tmpChannels.count) {
        [tmpChannels insertObject:channelModel atIndex:index];
        self.tabView.channelModels = [tmpChannels mutableCopy];
        [self.tabView insertChannelWithIndex:index];
        
        ///更新pagerView的 contentSize
        self.nums = self.tabView.channelModels.count;
        [self.pagerView setContentSize:CGSizeMake(CGRectGetWidth(self.pagerView.frame) * self.nums, CGRectGetHeight(self.pagerView.bounds))];
        
        //如果需要，改变lineView的frame
        if (index <= self.currentIndex) {
            //如果插入的频道在当前频道之前，当前频道对应的index需要往后移动一位
            self.currentIndex += 1;
            [self.tabView setLineViewCenterWithIndex:self.currentIndex animate:YES];
            [self.pagerView setContentOffset:CGPointMake(CGRectGetWidth(self.pagerView.frame) * self.currentIndex, 0) animated:NO];
        }
        
        //改变已经加载的vc的frame
        [self resetViewControllerFrameAfterIndex:index isInsertOrDelete:YES];
        //更新pagerVcs中vc对应的index
        [self updatePagerVcsAfterIndex:index isInsertOrDelete:YES];
        
    }

}

- (void)deleteChannelWithIndex:(NSInteger)index {
    NSMutableArray *tmpChannels = [self.tabView.channelModels mutableCopy];
    if (index < tmpChannels.count) {
        [tmpChannels removeObjectAtIndex:index];
        self.tabView.channelModels = [tmpChannels mutableCopy];
        [self.tabView deleteChannel:@[[NSIndexPath indexPathForItem:index inSection:0]]];
        
        self.nums = self.tabView.channelModels.count;
        [self.pagerView setContentSize:CGSizeMake(CGRectGetWidth(self.pagerView.frame) * self.nums, CGRectGetHeight(self.pagerView.bounds))];
        
        //如果需要，改变lineView的frame
        if (index <= self.currentIndex) {
            if (index == 0 && self.currentIndex == 0) {
                self.currentIndex = 0;
            }else {
                //如果删除的频道在当前频道之前，当前频道对应的index需要往前移动一位
                self.currentIndex -= 1;
            }
            [self.tabView setLineViewCenterWithIndex:self.currentIndex animate:YES];
            [self.pagerView setContentOffset:CGPointMake(CGRectGetWidth(self.pagerView.frame) * self.currentIndex, 0) animated:NO];
        }
        
        [self.tabView scrollTabItemToIndexPath:self.currentIndex animated:NO];
        
        //remove controller
        UIViewController *vc = [self viewControllerForIndex:index];
        if (vc) {
            [self.pagerVcs removeObjectForKey:[NSString stringWithFormat:@"%ld", (long)index]];
            [vc willMoveToParentViewController:nil];
            [vc.view removeFromSuperview];
            [vc removeFromParentViewController];
        }
        
        //改变已经加载的vc的frame
        [self resetViewControllerFrameAfterIndex:index isInsertOrDelete:NO];
        //更新pagerVcs中vc对应的index
        [self updatePagerVcsAfterIndex:index isInsertOrDelete:NO];
        
        //如果currentIndex对应的vc没有加载，则需要调用一次DataSource 获取新的vc
        UIViewController *cVc = [self viewControllerForIndex:self.currentIndex];
        if (!cVc) {
            [self showViewControllerForIndex:self.currentIndex];
        }
        
    }
}

- (void)moveChannelWithIndex:(NSInteger)index toIndex:(NSInteger)toIndex {
    
    if ((index != toIndex) && (index >= 0 && index < self.tabView.channelModels.count) && (toIndex > 0 && toIndex < self.tabView.channelModels.count)) {
        __weak typeof(self) weakSelf = self;
        [self.tabView moveChannelWithIndex:index toIndexPath:toIndex callback:^(NSInteger cIndex) {
            
            [weakSelf moveViewControllerFromIndex:index toIndex:toIndex];
            weakSelf.currentIndex = cIndex;
            [weakSelf.pagerView setContentOffset:CGPointMake(CGRectGetWidth(self.pagerView.frame) * self.currentIndex, 0) animated:NO];
        }];
        
    }
    
}

#pragma mark - private method
- (void)reloadData {
    
    if ([self.dataSource respondsToSelector:@selector(channelModelsInTabView:)]) {
        self.tabView.channelModels = [[self.dataSource channelModelsInTabView:self.tabView]copy];
        [self.tabView reloadChannelData];
    }
    
    if ([self.dataSource respondsToSelector:@selector(numberOfViewControllersInPagerView:)]) {
        self.nums = [self.dataSource numberOfViewControllersInPagerView:self.pagerView];
        NSAssert(self.nums == self.tabView.channelModels.count, @"viewController的数量必须与channel item相等");
        [self.pagerView setContentSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) * self.nums, CGRectGetHeight(self.pagerView.bounds))];
    }
    
}

- (UIViewController  * _Nullable)viewControllerForIndex:(NSUInteger)index {
    NSString *indexStr = [NSString stringWithFormat:@"%lu", index];
    return self.pagerVcs[indexStr];
}

///移动vc
- (void)moveViewControllerFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    
    NSArray *filterArr = [self getRangeKeyArrFronIndex:fromIndex toIndex:toIndex];
    
    //更新frame
    for (NSString *key in filterArr) {
        UIViewController *vc = [self viewControllerForIndex:key.integerValue];
        if (vc) {
            CGRect rect = vc.view.frame;
            if (fromIndex == key.integerValue) {
                rect.origin.x = CGRectGetWidth(self.pagerView.frame) * toIndex;
            }else {
                if (fromIndex > toIndex) {
                    rect.origin.x += CGRectGetWidth(self.pagerView.frame);
                }else {
                    rect.origin.x -= CGRectGetWidth(self.pagerView.frame);
                }
            }
            vc.view.frame = rect;
        }
    }
    
    NSMutableDictionary *tmpDic = [self.pagerVcs mutableCopy];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    //更新key
    for (NSString *key in filterArr) {
        UIViewController *vc = tmpDic[key];
        NSInteger aKey;
        if (fromIndex == key.integerValue) {
            aKey = toIndex;
        }else {
            if (fromIndex > toIndex) {
                aKey = key.integerValue + 1;
            }else {
                aKey = key.integerValue - 1;
            }
        }
        
        dic[[NSString stringWithFormat:@"%ld", aKey]] = vc;
        [tmpDic removeObjectForKey:key];
    }
    [tmpDic addEntriesFromDictionary:dic];
    
    self.pagerVcs = [tmpDic mutableCopy];
    
}

///获取一个范围内的inde的key 数组
- (NSArray *)getRangeKeyArrFronIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    NSInteger minIndex = MIN(fromIndex, toIndex);
    NSInteger maxIndex = MAX(fromIndex, toIndex);
    return [self.pagerVcs.allKeys filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if ([evaluatedObject isKindOfClass:[NSString class]]) {
            NSString *str = (NSString *)evaluatedObject;
            NSComparisonResult result1 = ([str compare:[NSString stringWithFormat:@"%ld", minIndex]] == NSOrderedDescending) || ([str compare:[NSString stringWithFormat:@"%ld", minIndex]] == NSOrderedSame);
            NSComparisonResult result2 = ([str compare:[NSString stringWithFormat:@"%ld", maxIndex]] == NSOrderedAscending) || ([str compare:[NSString stringWithFormat:@"%ld", maxIndex]] == NSOrderedSame);
            return result1 && result2;
        }
        return NO;
    }]];
}

///获取比指定index大的key 数组
- (NSArray *)getUpperKeyArrWithIndex:(NSInteger)index {
    return [self.pagerVcs.allKeys filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if ([evaluatedObject isKindOfClass:[NSString class]]) {
            NSString *str = (NSString *)evaluatedObject;
            return ([str compare:[NSString stringWithFormat:@"%ld", index]] == NSOrderedDescending) || ([str compare:[NSString stringWithFormat:@"%ld", index]] == NSOrderedSame);
        }
        return NO;
    }]];
}

///index：插入或删除的位置，flag：插入YES   删除NO
- (void)resetViewControllerFrameAfterIndex:(NSInteger)index isInsertOrDelete:(BOOL)flag {
    
    NSArray *filterArr = [self getUpperKeyArrWithIndex:index];
    
    for (NSString *key in filterArr) {
        UIViewController *vc = [self viewControllerForIndex:key.integerValue];
        if (vc) {
            CGRect rect = vc.view.frame;
            if (flag) {
                rect.origin.x += CGRectGetWidth(self.pagerView.frame);
            }else {
                rect.origin.x -= CGRectGetWidth(self.pagerView.frame);
            }
            vc.view.frame = rect;
        }
    }
    
}

///index：更新的位置  flag：如果是插入YES  删除NO
- (void)updatePagerVcsAfterIndex:(NSInteger)index isInsertOrDelete:(BOOL)flag {
    
    NSMutableDictionary *tmpDic = [self.pagerVcs mutableCopy];
    
    NSArray *filterArr = [self getUpperKeyArrWithIndex:index];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    for (NSString *key in filterArr) {
        UIViewController *vc = tmpDic[key];
        NSInteger aKey;
        if (flag) {
            aKey = key.integerValue + 1;
        }else {
            aKey = key.integerValue - 1;
        }
        dic[[NSString stringWithFormat:@"%ld", aKey]] = vc;
        [tmpDic removeObjectForKey:key];
    }
    [tmpDic addEntriesFromDictionary:dic];
    
    self.pagerVcs = [tmpDic mutableCopy];
    
}

- (void)saveViewControllerAtIndex:(NSUInteger)index viewController:(UIViewController *)vc {
    NSString *indexStr = [NSString stringWithFormat:@"%lu", index];
    self.pagerVcs[indexStr] = vc;
}

- (void)showViewControllerForIndex:(NSUInteger)index {
    if ([self.dataSource respondsToSelector:@selector(viewControllerAtIndex:inPageView:)]) {
        UIViewController *currentVc = [self.dataSource viewControllerAtIndex:index inPageView:self.pagerView];
        [self saveViewControllerAtIndex:index viewController:currentVc];
        [self addChildViewController:currentVc];
        currentVc.view.frame = CGRectMake(CGRectGetWidth(self.pagerView.frame) * index, 0, CGRectGetWidth(self.pagerView.frame), CGRectGetHeight(self.pagerView.frame));
        [self.pagerView addSubview:currentVc.view];
        //让该vc显示出来
        [currentVc didMoveToParentViewController:self];
    }
}

#pragma mark - SINPagerViewControllerDataSource
- (NSArray <SINChannelModel *>*)channelModelsInTabView:(SINTabView *)tabView {
    return self.tmpChannelModels;
}

- (NSUInteger)numberOfViewControllersInPagerView:(UIScrollView *)pagerView {
    return self.tmpChannelModels.count;
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index inPageView:(UIScrollView *)pagerView {
    ViewController1 *vc = [[ViewController1 alloc] init];
    vc.txtStr = [NSString stringWithFormat:@"%lu", index];
    return vc;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    CGFloat radio = scrollView.contentOffset.x / CGRectGetWidth(self.pagerView.frame);
    NSLog(@"%f", radio);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat radio = scrollView.contentOffset.x / CGRectGetWidth(self.pagerView.frame);
    
    if (self.lastContentOffset > scrollView.contentOffset.x) {
        // 向右滑动
        CGFloat flo = floor(radio);
        [self.tabView moveLineWithRadio:(1 - (radio - flo)) currentIndex:ceil(radio) toIndex:flo];
        
        if (scrollView.decelerating) {
            [self.tabView scrollTabItemToIndexPath:flo animated:YES];
        }
        
    } else if (self.lastContentOffset < scrollView.contentOffset.x) {
        // 向左滑动
        CGFloat cei = ceil(radio);
        [self.tabView moveLineWithRadio:(radio - floor(radio)) currentIndex:floor(radio) toIndex:cei];
        if (scrollView.decelerating) {
            [self.tabView scrollTabItemToIndexPath:cei animated:YES];
        }
    }
    self.lastContentOffset = scrollView.contentOffset.x;
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    CGFloat radio = scrollView.contentOffset.x / CGRectGetWidth(self.pagerView.frame);
    
    NSInteger nextIndex;
    
    CGPoint point = [scrollView.panGestureRecognizer translationInView:self.view];

    if (point.x > 0) {
        // 向右滑动
        nextIndex = floor(radio - 1);
    } else {
        // 向左滑动
        nextIndex = floor(radio + 1);
    }
    UIViewController *vc = [self viewControllerForIndex:nextIndex];
    if (!vc) {
        [self showViewControllerForIndex:nextIndex];
    }else {
        //将要展示出下一个vc回调
        if ([self.delegate respondsToSelector:@selector(viewControllerWillDisplay:atIndex:inPagerView:)]) {
            [self.delegate viewControllerWillDisplay:vc atIndex:nextIndex inPagerView:scrollView];
        }
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //前一个vc结束展示回调
    if ([self.delegate respondsToSelector:@selector(viewControllerDidEndDisplay:atIndex:inPagerView:)]) {
        [self.delegate viewControllerDidEndDisplay:[self viewControllerForIndex:self.currentIndex] atIndex:self.currentIndex inPagerView:scrollView];
    }
    
    int index = fabs(ceil(scrollView.contentOffset.x / CGRectGetWidth(self.pagerView.frame)));
    self.currentIndex = index;
    UIViewController *vc = [self viewControllerForIndex:index];
    if (!vc) {
        [self showViewControllerForIndex:index];
    }
}

@end
