//
//  StoryPageViewController.h
//  MyLog
//
//  Created by 杨利嘉 on 1/21/16.
//  Copyright © 2016 杨利嘉. All rights reserved.
//

#import "BaseViewController.h"

@class StoryModel;

@interface StoryPageViewController : BaseViewController

@property(nonatomic,strong)NSArray *allStoryArr;
@property(nonatomic,strong)StoryModel *model;

@end
