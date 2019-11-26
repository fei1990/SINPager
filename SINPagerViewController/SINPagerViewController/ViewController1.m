//
//  ViewController1.m
//  SINPagerViewController
//
//  Created by wf on 2019/11/20.
//  Copyright © 2019 sohu. All rights reserved.
//

#import "ViewController1.h"

@interface ViewController1 ()

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int R = (arc4random() % 256) ;
    int G = (arc4random() % 256) ;
    int B = (arc4random() % 256) ;
    
    self.view.backgroundColor = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1];
    
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 40)];
//    lbl.text = [NSString stringWithFormat:@"%d", arc4random() / 10000000];
    lbl.text = self.txtStr;
    [self.view addSubview:lbl];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
