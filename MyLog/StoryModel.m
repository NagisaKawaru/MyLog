//
//  StoryModel.m
//  MyLog
//
//  Created by 杨利嘉 on 16/1/19.
//  Copyright © 2016年 杨利嘉. All rights reserved.
//

#import "StoryModel.h"

@implementation StoryModel


+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"ID"}];
}
@end
