//
//  StoryPageViewController.m
//  MyLog
//
//  Created by 杨利嘉 on 1/21/16.
//  Copyright © 2016 杨利嘉. All rights reserved.
//

#import "StoryPageViewController.h"

@interface StoryPageViewController ()

@end

@implementation StoryPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=YES;
}

-(void)swipped:(UISwipeGestureRecognizer *)sgr
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
