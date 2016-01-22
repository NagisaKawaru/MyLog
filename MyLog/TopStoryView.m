//
//  TopStoryView.m
//  MyLog
//
//  Created by 杨利嘉 on 1/22/16.
//  Copyright © 2016 杨利嘉. All rights reserved.
//

#import "TopStoryView.h"

#import "TopStoryModel.h"


#define Time_Duration 10

#define Base_Tag 110
@interface TopStoryView ()<UIScrollViewDelegate>
{
    NSArray *_allData;
    void(^_clickAction)(TopStoryModel*);
}

@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)UIPageControl *pageControl;
@end


@implementation TopStoryView


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame=CGRectMake(0, 0, SCREEN_SIZE.width, CGRectGetMaxY(self.scrollView.frame));
    }
    return self;
}

-(void)setTopStoryViewData:(NSArray *)allData clickBack:(void (^)(TopStoryModel *))click
{
    
    for (UIView *subView in self.scrollView.subviews) {
        [subView removeFromSuperview];
    }

    _allData=allData;
    _clickAction=click;

    self.pageControl.numberOfPages=allData.count;
    for (int i=0; i<allData.count+2; i++) {
        TopStoryModel *model;
        if (i==0) {
            model=allData.lastObject;
        }else if (i==allData.count+1) {
            model=allData.firstObject;
        }else{
            model=allData[i-1];
        }
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_SIZE.width*i, 0, SCREEN_SIZE.width, CGRectGetHeight(self.scrollView.frame))];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
        
        imageView.userInteractionEnabled=YES;
        
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
        
        imageView.tag=Base_Tag+i;
        
       
//        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.pageControl.frame)-self.pageControl.frame.size.height-10-40, SCREEN_SIZE.width-20, 50)];
//        label.textAlignment=NSTextAlignmentLeft;
//        label.numberOfLines=0;
//        label.text=model.title;
//        label.textColor=[UIColor whiteColor];
//        label.font=[UIFont systemFontOfSize:18];
//        [imageView addSubview:label];
        
        [self.scrollView addSubview:imageView];
        
        
        
        self.scrollView.contentSize=CGSizeMake(CGRectGetMaxX(imageView.frame), 0);
        
    }
    
    self.scrollView.contentOffset=CGPointMake(SCREEN_SIZE.width, 0);
    
    [self.timer performSelector:@selector(setFireDate:) withObject:[NSDate distantPast] afterDelay:Time_Duration];
    
    [self bringSubviewToFront:self.pageControl];

}
-(void)tapAction:(UIGestureRecognizer*)tap
{
    NSInteger index=tap.view.tag-Base_Tag;
    TopStoryModel *model=[_allData objectAtIndex:index];
    
    if (_clickAction) {
        _clickAction(model);
    }

}

#pragma mark=========循环滚动相关====================

//// 开始拖动的时候, 暂停计时器
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    [self.timer setFireDate:[NSDate distantFuture]];
//}
//
//// 停止拖动的时候, 继续计时器
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    [self.timer setFireDate:[NSDate distantPast]];
//}

// 减速完成, 手动滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self pageControlWithContentOffset:scrollView.contentOffset.x];
}
//
// 动画滚动完成
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    [self pageControlWithContentOffset:scrollView.contentOffset.x];
}

// 循环滚动相关
- (void)pageControlWithContentOffset:(CGFloat)x {
    
    // 获取当前分页
    NSInteger page = x / SCREEN_SIZE.width;
    
    if (page == 0) {
        // 跳转到最后一个需要显示的图片的位置, 即 arr.count
        [self.scrollView setContentOffset:CGPointMake(SCREEN_SIZE.width * _allData.count, 0) animated:NO];
        self.pageControl.currentPage = _allData.count-1;
    }
    else if (page == _allData.count + 1) {
        // 跳转到第一个需要显示的图片的位置, 即1
        [self.scrollView setContentOffset:CGPointMake(SCREEN_SIZE.width, 0) animated:NO];
        self.pageControl.currentPage = 0;
    }
    else {
        self.pageControl.currentPage = page - 1;
        
    }
}

- (void)runAction {
    CGFloat x = self.scrollView.contentOffset.x;
    NSInteger currentPage=x/SCREEN_SIZE.width;
    [self.scrollView setContentOffset:CGPointMake((currentPage+1)*SCREEN_SIZE.width, 0) animated:YES];
}
#pragma mark===================懒加载=========================

-(UIScrollView*)scrollView
{
    if (!_scrollView) {
        _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.width*440/640)];
        _scrollView.delegate=self;
        _scrollView.pagingEnabled=YES;
        
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

-(UIPageControl*)pageControl
{
    if (!_pageControl) {
        _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(SCREEN_SIZE.width/2-100, CGRectGetHeight(self.scrollView.frame)-30, 200, 30)];
        
        [self addSubview:_pageControl];
        
    }
    return _pageControl;
}
-(NSTimer*)timer
{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:Time_Duration target:self selector:@selector(runAction) userInfo:nil repeats:YES];
        [_timer setFireDate:[NSDate distantFuture]];
        
        //
//        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}
@end
