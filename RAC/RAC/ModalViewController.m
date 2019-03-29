//
//  ModalViewController.m
//  RAC
//
//  Created by zlhj on 2019/3/28.
//  Copyright © 2019 zlhj. All rights reserved.
//

#import "ModalViewController.h"

@interface ModalViewController ()

@end

@implementation ModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)disMiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)dealloc{
    NSLog(@"%s",__func__);
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
