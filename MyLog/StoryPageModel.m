//
//  StoryPageModel.m
//  MyLog
//
//  Created by 杨利嘉 on 16/1/25.
//  Copyright © 2016年 杨利嘉. All rights reserved.
//

#import "StoryPageModel.h"

@implementation StoryPageModel


+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"ID"}];
}
@end
