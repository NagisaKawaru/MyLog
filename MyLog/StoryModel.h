//
//  StoryModel.h
//  MyLog
//
//  Created by 杨利嘉 on 16/1/19.
//  Copyright © 2016年 杨利嘉. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@protocol StoryModel <NSObject>



@end
@interface StoryModel : JSONModel

@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *ga_prefix;
@property(nonatomic,strong)NSArray *images;

@end
