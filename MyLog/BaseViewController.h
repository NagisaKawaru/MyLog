//
//  BaseViewController.h
//  MyLog
//
//  Created by 杨利嘉 on 16/1/19.
//  Copyright © 2016年 杨利嘉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

-(void)addGestureRecognizer;

-(void)swipped:(UISwipeGestureRecognizer*)sgr;
@end
