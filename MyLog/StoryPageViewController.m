//
//  StoryPageViewController.m
//  MyLog
//
//  Created by 杨利嘉 on 1/21/16.
//  Copyright © 2016 杨利嘉. All rights reserved.
//

#import "StoryPageViewController.h"

#define BaseURL @"http://news-at.zhihu.com/api/4/news/"

#import "StoryPageModel.h"
#import "StoryModel.h"

@interface StoryPageViewController ()<UIScrollViewDelegate,UIWebViewDelegate>

@property(nonatomic,strong)UIImageView *backImageView;
@property(nonatomic,strong)UILabel *titleLable;
@property(nonatomic,strong)UILabel *picLabel;

@property(nonatomic,strong)UIWebView *webView;


@end

@implementation StoryPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=YES;
    
    

    
    [self loadData];
    
}
-(void)loadData
{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",BaseURL,self.model.ID];
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSString *htmlString=responseObject[@"body"];
//        NSAttributedString *attHtmlStr=[[NSAttributedString alloc]initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        StoryPageModel *model=[[StoryPageModel alloc]initWithDictionary:responseObject error:nil];
        
        [self.backImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
        
        self.titleLable.text=model.title;
        self.picLabel.text=model.image_source;
        
        
        
        [self.webView loadHTMLString:model.body baseURL:nil];
        [self.view addSubview:self.webView];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
#pragma mark ===================懒加载==========================
-(UIImageView*)backImageView
{
    if (!_backImageView) {
        _backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, -20, SCREEN_SIZE.width, SCREEN_SIZE.width*440/640)];
//        _backImageView.backgroundColor=[UIColor grayColor];
        
        [self.view addSubview:_backImageView];
    }
    return _backImageView;
}
-(UILabel*)titleLable
{
    if (!_titleLable) {
        _titleLable=[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetHeight(self.backImageView.frame)-80, SCREEN_SIZE.width-10*3, 60)];
        _titleLable.numberOfLines=0;
        _titleLable.textAlignment=NSTextAlignmentLeft;
        _titleLable.textColor=[UIColor whiteColor];
        _titleLable.font=[UIFont systemFontOfSize:21];
//        _titleLable.backgroundColor=[UIColor blackColor];
        [self.backImageView addSubview:_titleLable];
    }
    return _titleLable;
}
-(UILabel*)picLabel
{
    if (!_picLabel) {
        _picLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_SIZE.width/2, CGRectGetHeight(self.backImageView.frame)-30, SCREEN_SIZE.width/2, 20)];
        _picLabel.textAlignment=NSTextAlignmentRight;
        _picLabel.textColor=[UIColor whiteColor];
        
        [self.backImageView addSubview:_picLabel];
    }
    return _picLabel;
}
-(UIWebView*)webView
{
    if (!_webView) {
        _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.backImageView.frame), SCREEN_SIZE.width, SCREEN_SIZE.height-CGRectGetHeight(self.backImageView.frame)+20)];
        _webView.delegate=self;
        _webView
        [self.view addSubview:_webView];
    }
    return _webView;
}
#pragma mark ===================重写父类手势================
-(void)swipped:(UISwipeGestureRecognizer *)sgr
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

@end
