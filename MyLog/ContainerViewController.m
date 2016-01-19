//
//  ContainerViewController.m
//  MyLog
//
//  Created by 杨利嘉 on 16/1/19.
//  Copyright © 2016年 杨利嘉. All rights reserved.
//

#import "ContainerViewController.h"

@interface ContainerViewController ()

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor orangeColor];
    
    [self.view addSubview:[self.childViewControllers[0] view]];
    
    NSLog(@"%lu",self.childViewControllers.count);
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(rightSwip:) name:@"rightSwip" object:nil];
    
}

-(void)rightSwip:(NSNotification*)noti
{
 
    [UIView animateWithDuration:0.5 animations:^{
        UIView *view=[self.childViewControllers[0] view];
        view.userInteractionEnabled=YES;
        
        view.center=CGPointMake(SCREEN_SIZE.width*3/4, SCREEN_SIZE.height/2);
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.5 animations:^{
        UIView *view=[self.childViewControllers[0] view];
        view.userInteractionEnabled=YES;
        
        view.center=CGPointMake(SCREEN_SIZE.width/2, SCREEN_SIZE.height/2);
        
    }];
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
