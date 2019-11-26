//
//  ViewController.m
//  SINPagerViewController
//
//  Created by wf on 2019/11/19.
//  Copyright © 2019 sohu. All rights reserved.
//

#import "ViewController.h"
#import "SINTabView.h"
#import "SINPagerViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
//    SINTabView *tabView = [[SINTabView alloc] initWithFrame:({
//        CGRect rect = CGRectMake(0, 150, CGRectGetWidth([UIScreen mainScreen].bounds), 40);
//        rect;
//    })];
//
//    NSMutableArray *arr = [NSMutableArray array];
//    for (int i = 0; i < 23; i ++) {
//        SINChannelModel *model = [[SINChannelModel alloc]init];
//        model.cid = i + 1;
//        model.title = [NSString stringWithFormat:@"搜狐%d", i + 10];
//        [arr addObject:model];
//    }
//    tabView.channelModels = arr;
//
//    tabView.selecteTabTxtFont = [UIFont systemFontOfSize:15];
//    tabView.defaultTabTxtColor = [UIColor redColor];
    
//    SINPagerConfig *config = [[SINPagerConfig alloc] init];
//    config.defaultTabTxtFont = [UIFont systemFontOfSize:15];
//    config.selecteTabTxtFont = [UIFont systemFontOfSize:15];
//    tabView.config = config;
    
//    [self.view addSubview:tabView];
    
}

- (IBAction)btnAction:(id)sender {
    
    SINPagerViewController *pagerVc = [[SINPagerViewController alloc] init];
    [self.navigationController pushViewController:pagerVc animated:YES];
    
}

@end
