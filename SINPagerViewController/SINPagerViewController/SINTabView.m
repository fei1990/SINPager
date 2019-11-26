//
//  SINTabView.m
//  SINPagerViewController
//
//  Created by wf on 2019/11/19.
//  Copyright © 2019 sohu. All rights reserved.
//

#import "SINTabView.h"
#import "SINTabFlowLayout.h"
#import "SINTabTextCell.h"

#define lineSize CGSizeMake(20, 2)

@interface SINTabView ()

@property (nonatomic, strong) SINTabFlowLayout *flowLayout;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic) NSInteger currentIndex;

@end

@implementation SINTabView

- (SINTabFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[SINTabFlowLayout alloc] init];
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.delegate = (id<UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>)self;
        _collectionView.dataSource = (id<UICollectionViewDataSource>)self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[SINTabTextCell class] forCellWithReuseIdentifier:@"channelTabTextCell"];
    }
    return _collectionView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - lineSize.height, lineSize.width, lineSize.height)];
        _lineView.backgroundColor = [UIColor purpleColor];
    }
    return _lineView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.defaultTabTxtColor = [UIColor blackColor];
        self.selecteTabTxtColor = [UIColor magentaColor];
        self.defaultTabTxtFont = [UIFont systemFontOfSize:15];
        self.selecteTabTxtFont = self.defaultTabTxtFont;
        
        self.backgroundColor = UIColor.whiteColor;
        self.collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        [self addSubview:self.collectionView];
        [self.collectionView addSubview:self.lineView];
        self.backgroundColor = UIColor.yellowColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - public
- (void)setLineViewCenterWithIndex:(NSInteger)index animate:(BOOL)animate {
    UICollectionViewLayoutAttributes *attr = self.flowLayout.attributes[[NSString stringWithFormat:@"%ld", index]];
    if (attr) {
        if (animate) {
            [UIView animateWithDuration:0.3 animations:^{
                CGPoint center = self.lineView.center;
                center.x = attr.center.x;
                self.lineView.center = center;
            }];
        }else {
            CGPoint center = self.lineView.center;
            center.x = attr.center.x;
            self.lineView.center = center;
        }
    }
}

- (void)reloadChannelData {
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
}

- (void)insertChannelWithIndex:(NSInteger)index {
    if (index <= self.currentIndex) {
        self.currentIndex += 1;
    }
    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
//    [self scrollTabItemToIndexPath:index animated:YES];
    [self.collectionView layoutIfNeeded];
}

- (void)deleteChannel:(NSArray *)indexPaths {
    if (indexPaths.count > 0) {
        [self.collectionView deleteItemsAtIndexPaths:indexPaths];
        [self.collectionView layoutIfNeeded];
    }
    
}

- (void)moveChannelWithIndex:(NSInteger)index toIndexPath:(NSInteger)toIndex callback:(void(^)(NSInteger cIndex))completion {
    
    //当前的频道对象，用于判断当前频道是否需要移动
    SINChannelModel *currentModel = self.channelModels[self.currentIndex];
    
    NSMutableArray *tmpChannels = [self.channelModels mutableCopy];
    
    SINChannelModel *model = tmpChannels[index];
    
    [tmpChannels removeObjectAtIndex:index];
    
    [tmpChannels insertObject:model atIndex:toIndex];
    self.channelModels = [tmpChannels mutableCopy];
    
    [self.collectionView moveItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] toIndexPath:[NSIndexPath indexPathForItem:toIndex inSection:0]];
    [self.collectionView layoutIfNeeded];
    
    NSInteger tmpIndex = [self.channelModels indexOfObject:currentModel];
     
    if (self.currentIndex != tmpIndex) {
        self.currentIndex = tmpIndex;
        [self scrollTabItemToIndexPath:self.currentIndex animated:YES];
        [self setLineViewCenterWithIndex:self.currentIndex animate:YES];
        
        !completion ?: completion(self.currentIndex);
    }
    
}

- (void)scrollTabItemToIndexPath:(NSInteger)index animated:(BOOL)animated {
    if (self.channelModels && index < self.channelModels.count) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
        
        id<SINTabCellProtocol> lastCell = (id<SINTabCellProtocol>)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
        
        id<SINTabCellProtocol> currCell = (id<SINTabCellProtocol>)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        
        lastCell.textLabel.textColor = [SINPagerConfig defaultConfig].defaultTabTxtColor;
        currCell.textLabel.textColor = [SINPagerConfig defaultConfig].selecteTabTxtColor;
        
        self.currentIndex = index;
    }
}

- (void)moveLineWithRadio:(CGFloat)radio currentIndex:(NSInteger)currentIndex toIndex:(NSInteger)toIndex {
    if (toIndex < self.channelModels.count && currentIndex < self.channelModels.count) {
        UICollectionViewLayoutAttributes *attribute = self.flowLayout.attributes[[NSString stringWithFormat:@"%lu", toIndex]];
        
        UICollectionViewLayoutAttributes *currentAttr = self.flowLayout.attributes[[NSString stringWithFormat:@"%lu", currentIndex]];
        
        CGPoint linePoint = self.lineView.center;
        linePoint.x = currentAttr.center.x + (attribute.center.x - currentAttr.center.x) * radio;
        self.lineView.center = linePoint;
        
        //修改textColor
        NSIndexPath *currIndexPath = [NSIndexPath indexPathForItem:currentIndex inSection:0];
        
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:toIndex inSection:0];
        
        id<SINTabCellProtocol> currCell = (id<SINTabCellProtocol>)[self.collectionView cellForItemAtIndexPath:currIndexPath];
        
        id<SINTabCellProtocol> nextCell = (id<SINTabCellProtocol>)[self.collectionView cellForItemAtIndexPath:nextIndexPath];
        
        if (radio > 0.65) {
            currCell.textLabel.textColor = [SINPagerConfig defaultConfig].defaultTabTxtColor;
            nextCell.textLabel.textColor = [SINPagerConfig defaultConfig].selecteTabTxtColor;
        }
    }
}

#pragma mark - setter
-(void)setDefaultTabTxtFont:(UIFont *)defaultTabTxtFont {
    _defaultTabTxtFont = defaultTabTxtFont;
    [SINPagerConfig defaultConfig].defaultTabTxtFont = defaultTabTxtFont;
}

-(void)setSelecteTabTxtFont:(UIFont *)selecteTabTxtFont {
    _selecteTabTxtFont = selecteTabTxtFont;
    [SINPagerConfig defaultConfig].selecteTabTxtFont = selecteTabTxtFont;
}

-(void)setDefaultTabTxtColor:(UIColor *)defaultTabTxtColor {
    _defaultTabTxtColor = defaultTabTxtColor;
    [SINPagerConfig defaultConfig].defaultTabTxtColor = defaultTabTxtColor;
}

-(void)setSelecteTabTxtColor:(UIColor *)selecteTabTxtColor {
    _selecteTabTxtColor = selecteTabTxtColor;
    [SINPagerConfig defaultConfig].selecteTabTxtColor = selecteTabTxtColor;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.channelModels.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    id<SINTabCellProtocol> cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"channelTabTextCell" forIndexPath:indexPath];
    
    NSAssert([cell conformsToProtocol:@protocol(SINTabCellProtocol)], @"cell 必须实现SINTabCellProtocol协议");
    
    if (self.currentIndex == indexPath.item) {
        cell.textColor = [SINPagerConfig defaultConfig].selecteTabTxtColor;
    }else {
        cell.textColor = [SINPagerConfig defaultConfig].defaultTabTxtColor;
    }
    
    SINChannelModel *model = self.channelModels[indexPath.row];
    
    [cell setupChannelModel:model];
    
    return (UICollectionViewCell *)cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    !self.clickTabItem ?: self.clickTabItem(indexPath.item);
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    SINChannelModel *model = self.channelModels[indexPath.row];
    CGFloat txtWidth = [self heightTextToFit:model.title];
    return CGSizeMake(txtWidth + horGap * 2, [SINPagerConfig defaultConfig].selecteTabTxtFont.lineHeight + verGap * 2);
}

- (CGFloat)heightTextToFit:(NSString *)str {
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [SINPagerConfig defaultConfig].selecteTabTxtFont}];
    UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, [SINPagerConfig defaultConfig].selecteTabTxtFont.lineHeight)];
    tempLabel.attributedText = attr;
    tempLabel.numberOfLines = 1;
    [tempLabel sizeToFit];
    CGSize size = tempLabel.frame.size;
    return size.width;
}

@end
