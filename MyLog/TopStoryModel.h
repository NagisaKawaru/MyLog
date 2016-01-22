//
//  TopStoryModel.h
//  MyLog
//
//  Created by 杨利嘉 on 1/22/16.
//  Copyright © 2016 杨利嘉. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface TopStoryModel : JSONModel

@property(nonatomic,copy)NSString *image;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *ga_prefix;




@end


//"image": "http://pic3.zhimg.com/57ef925fdee8923305cb8b79cfb0c0a6.jpg",
//"type": 0,
//"id": 7782189,
//"ga_prefix": "012214",
//"title": "被吐槽「丑出新高度