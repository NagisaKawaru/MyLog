//
//  BaseViewController.m
//  MyLog
//
//  Created by 杨利嘉 on 16/1/19.
//  Copyright © 2016年 杨利嘉. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor grayColor];
    
    [self addGestureRecognizer];
}

-(void)addGestureRecognizer
{
    UISwipeGestureRecognizer *sgr=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipped:)];
    sgr.direction=UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:sgr];
    
    

}
-(void)swipped:(UISwipeGestureRecognizer*)sgr
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"rightSwip" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
