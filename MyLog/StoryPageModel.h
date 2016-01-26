//
//  StoryPageModel.h
//  MyLog
//
//  Created by 杨利嘉 on 16/1/25.
//  Copyright © 2016年 杨利嘉. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface StoryPageModel : JSONModel


@property(nonatomic,copy)NSString *body;
@property(nonatomic,copy)NSString *image_source;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *image;
@property(nonatomic,copy)NSString *share_url;
//@property(nonatomic,copy)NSString *js
@property(nonatomic,copy)NSString *ga_prefix;
@property(nonatomic,strong)NSNumber *type;
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,strong)NSArray *css;
@property(nonatomic,strong)NSArray<Optional> *recommenders;
@end

//"body": "<div class=\"main-wrap content-wrap\">\n<div class=\"he
//"image_source": "Taki Steve / CC BY",
//"title": "春节快到了，家里备上这些常用药会比较安心",
//"image": "http://pic4.zhimg.com/e2d88c9f3720f706a6c3f7c3ab5abedb.jpg",
//"share_url": "http://daily.zhihu.com/story/7778552",
//"js": [],
//"ga_prefix": "012511",
//"type": 0,
//"id": 7778552,
//"css": []