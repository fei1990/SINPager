//
//  SINTabCellProtocol.h
//  SINPagerViewController
//
//  Created by wf on 2019/11/19.
//  Copyright © 2019 sohu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class SINChannelModel;
@protocol SINTabCellProtocol <NSObject>

@optional
@property (nonatomic, strong, readonly) UILabel *textLabel;

@property (nonatomic, strong) UIColor *textColor;

@required
- (void)setupChannelModel:(SINChannelModel *)model;

@end

NS_ASSUME_NONNULL_END
