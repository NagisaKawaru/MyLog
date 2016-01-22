//
//  HomePageCell.m
//  MyLog
//
//  Created by 杨利嘉 on 16/1/19.
//  Copyright © 2016年 杨利嘉. All rights reserved.
//

#import "HomePageCell.h"

#import "StoryModel.h"
#define GAP 10

@interface HomePageCell ()

@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)UILabel *mulPicLabel;


@end
@implementation HomePageCell


-(void)setModel:(StoryModel *)model
{
    _model=model;
    
    [self.iconImageView sd_setImageWithURL:[model.images firstObject]];
    
    self.label.text=model.title;
    if (model.multipic) {
        [self.iconImageView addSubview:self.mulPicLabel];
    }
}


#pragma mark =========懒加载=======
-(UIImageView*)iconImageView
{
    if (!_iconImageView) {
        _iconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(GAP, GAP, 130, 130*4/5)];
        
        [self.contentView addSubview:_iconImageView];
        
    }
    return _iconImageView;
    
}
-(UILabel*)label
{
    if (!_label) {
        _label=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+GAP, GAP, SCREEN_SIZE.width-CGRectGetWidth(self.iconImageView.frame)-GAP*2, 120)];
        _label.font=[UIFont systemFontOfSize:18];
        _label.textColor=[UIColor blackColor];
        _label.numberOfLines=0;
        
//        _label.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
        
        [self.contentView addSubview:_label];
        
    }
    return _label;
}
-(UILabel*)mulPicLabel
{
    if (!_mulPicLabel) {
        _mulPicLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.iconImageView.frame)-20, CGRectGetHeight(self.iconImageView.frame)-10, 20, 10)];
        _mulPicLabel.text=@"多图";
        _mulPicLabel.textColor=[UIColor whiteColor];
        _mulPicLabel.backgroundColor=[UIColor redColor];
        _mulPicLabel.font=[UIFont systemFontOfSize:8];
        
    }
    return _mulPicLabel;
}

@end
