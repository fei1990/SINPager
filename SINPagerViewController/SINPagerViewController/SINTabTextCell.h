//
//  SINTabBaseCell.h
//  SINPagerViewController
//
//  Created by wf on 2019/11/19.
//  Copyright © 2019 sohu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SINTabCellProtocol.h"

static CGFloat const horGap = 5;

static CGFloat const verGap = 5;

NS_ASSUME_NONNULL_BEGIN

static struct {
    
    UIColor *defaultTabTxtColor;
    UIColor *selecteTabTxtColor;
    
    UIFont *defaultTabTxtFont;
    UIFont *selecteTabTxtFont;
    
}_configFlags;

@interface SINTabTextCell : UICollectionViewCell<SINTabCellProtocol>

@property (nonatomic, strong) UILabel *txtLbl;

@end

NS_ASSUME_NONNULL_END
