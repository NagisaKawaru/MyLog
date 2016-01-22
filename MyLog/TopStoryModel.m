//
//  TopStoryModel.m
//  MyLog
//
//  Created by 杨利嘉 on 1/22/16.
//  Copyright © 2016 杨利嘉. All rights reserved.
//

#import "TopStoryModel.h"

@implementation TopStoryModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{
                                                     @"id":@"ID"
                                                     }];
}

@end

