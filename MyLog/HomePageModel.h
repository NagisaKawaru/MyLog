//
//  HomePageModel.h
//  MyLog
//
//  Created by 杨利嘉 on 16/1/19.
//  Copyright © 2016年 杨利嘉. All rights reserved.
//

#import <JSONModel/JSONModel.h>
//#import "StoryModel.h"
//#import "TopStoryModel.h"
@interface HomePageModel : JSONModel
@property(nonatomic,copy)NSString *date;
//@property(nonatomic,strong)NSArray *<Optional>stories;
//@property(nonatomic,strong)NSArray *<Optional>top_stories;
@end
