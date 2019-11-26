//
//  SINPagerConfig.m
//  SINPagerViewController
//
//  Created by wf on 2019/11/19.
//  Copyright © 2019 sohu. All rights reserved.
//

#import "SINPagerConfig.h"

static SINPagerConfig *cofig = nil;

@implementation SINPagerConfig

+ (instancetype)defaultConfig; {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cofig = [[SINPagerConfig alloc] init];
    });
    return cofig;
}

-(void)setSelecteTabTxtFont:(UIFont *)selecteTabTxtFont {
    _selecteTabTxtFont = selecteTabTxtFont;
}

@end
