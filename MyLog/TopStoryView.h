//
//  TopStoryView.h
//  MyLog
//
//  Created by 杨利嘉 on 1/22/16.
//  Copyright © 2016 杨利嘉. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TopStoryModel;

@interface TopStoryView : UIView

-(void)setTopStoryViewData:(NSArray*)allData clickBack:(void(^)(TopStoryModel *model))click;

@end
