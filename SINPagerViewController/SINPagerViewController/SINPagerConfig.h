//
//  SINPagerConfig.h
//  SINPagerViewController
//
//  Created by wf on 2019/11/19.
//  Copyright © 2019 sohu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SINPagerConfig : NSObject

@property (nonatomic, strong) UIFont *defaultTabTxtFont;
@property (nonatomic, strong) UIFont *selecteTabTxtFont;

@property (nonatomic, strong) UIColor *defaultTabTxtColor;
@property (nonatomic, strong) UIColor *selecteTabTxtColor;

+ (instancetype)defaultConfig;

@end

NS_ASSUME_NONNULL_END
