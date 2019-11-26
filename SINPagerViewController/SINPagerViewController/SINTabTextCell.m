//
//  SINTabBaseCell.m
//  SINPagerViewController
//
//  Created by wf on 2019/11/19.
//  Copyright © 2019 sohu. All rights reserved.
//

#import "SINTabTextCell.h"
#import "SINChannelModel.h"
#import "SINPagerConfig.h"

@interface SINTabTextCell ()

@end

@implementation SINTabTextCell

- (UILabel *)txtLbl {
    if (!_txtLbl) {
        _txtLbl = ({
            UILabel *lbl = [[UILabel alloc] initWithFrame:({
                CGRect rect = CGRectZero;
                rect;
            })];
            lbl.font = [SINPagerConfig defaultConfig].selecteTabTxtFont;
            lbl.textColor = [SINPagerConfig defaultConfig].defaultTabTxtColor;
            lbl.textAlignment = NSTextAlignmentCenter;
//            lbl.backgroundColor = [UIColor cyanColor];
            lbl;
        });
    }
    return _txtLbl;
}

- (UIView *)textLabel {
    return _txtLbl;
}

- (UIColor *)textColor {
    return _txtLbl.textColor;
}

- (void)setTextColor:(UIColor *)textColor {
    _txtLbl.textColor = textColor;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        self.txtLbl.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.txtLbl];
        
//        self.backgroundColor = UIColor.redColor;
        
//        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.txtLbl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:verGap];
//        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.txtLbl attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:horGap];
//        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.txtLbl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-verGap];
//        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.txtLbl attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-horGap];
//        [self.txtLbl addConstraints:@[top, left, bottom, right]];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.txtLbl.frame = CGRectMake(horGap, verGap, CGRectGetWidth(self.frame) - 2 * horGap, CGRectGetHeight(self.frame) - 2 * verGap);
}

- (void)setupChannelModel:(SINChannelModel *)model {
    self.txtLbl.text = model.title;
}

@end
