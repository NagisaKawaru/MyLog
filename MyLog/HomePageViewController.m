//
//  HomePageViewController.m
//  MyLog
//
//  Created by 杨利嘉 on 16/1/19.
//  Copyright © 2016年 杨利嘉. All rights reserved.
//

#import "HomePageViewController.h"
#import "StoryPageViewController.h"
#import "StoryModel.h"
#import "TopStoryModel.h"
#import "HomePageModel.h"
#import "HomePageCell.h"
#import "TopStoryView.h"
#import "MJRefresh.h"

#define Home_NetRequest @"http://news.at.zhihu.com/api/4/news/"
@interface HomePageViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    NSInteger _page;
    BOOL _isRefreshing;
    NSInteger _sectionNum;
    int _lastContentOffSet;
    BOOL _isUp;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,copy)NSString *dateString;
@property(nonatomic,copy)NSString *urlString;
@property(nonatomic,strong)NSMutableArray *dateRecordSource;

@property(nonatomic,strong)NSMutableArray *sectionDataSource;


@property(nonatomic,strong)UILabel *sectionTitleLabel;

@property(nonatomic,strong)TopStoryView *headerView;
@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
  
    [self formulateNavigationBar];
    [self.view addSubview:self.tableView];
    
    self.dateString=@"latest";
    NSDateFormatter *dataFormatter=[[NSDateFormatter alloc]init];
    [dataFormatter setDateFormat:@"yyyyMMdd"];
    
    
    _page=[[dataFormatter stringFromDate:[NSDate date]] integerValue];
    self.urlString=[NSString stringWithFormat:@"%@%@",Home_NetRequest,self.dateString];
  
    [self loadData];
}

#pragma mark ===============NavigationBar按钮选项=====================
-(void)formulateNavigationBar
{
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(navigationItemClicked:)];

    
}


-(void)navigationItemClicked:(UINavigationItem*)item
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"rightSwip" object:nil];
}


#pragma mark ========================数据加载========================


-(void)loadData
{
    [self loadTopData];
    [self loadDataWithString:self.urlString];
}
-(void)loadTopData
{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    [manager GET:self.urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self paraseTopStoryData:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----------->top 加载失败%@",error);
    }];
}
-(void)loadDataWithString:(NSString*)urlStr
{
    
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self parseMainData:responseObject];
        [self doneLoadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"------------->%@",error);
    }];
    

}
-(void)paraseTopStoryData:(NSDictionary*)data
{
    NSArray *allData=data[@"top_stories"];
    
    NSMutableArray *topStoryArr=[[NSMutableArray alloc]init];
    for (NSDictionary *dict in allData) {
        TopStoryModel *model=[[TopStoryModel alloc]initWithDictionary:dict error:nil];
        
        [topStoryArr addObject:model];
    }

    [self.headerView setTopStoryViewData:topStoryArr clickBack:^(TopStoryModel *model) {
        NSLog(@"===============>");
    }];
}
-(void)doneLoadData
{
    [self.tableView.mj_header endRefreshing];
    
    [self.tableView.mj_footer endRefreshing];
    
    [self.tableView reloadSectionIndexTitles];
}

-(void)parseMainData:(NSDictionary*)data
{
    
    HomePageModel *model=[[HomePageModel alloc]initWithDictionary:data error:nil];
    
    [self.dateRecordSource addObject:model];
    
    NSArray *allData=data[@"stories"];
    
    
   
    NSMutableArray *mulArr=[[NSMutableArray alloc]init];
    for (NSDictionary *dict in allData) {
        StoryModel *model=[[StoryModel alloc]initWithDictionary:dict error:nil];
        
        [mulArr addObject:model];
    }
    [self.sectionDataSource addObject:mulArr];
    [self.tableView reloadData];

}

#pragma mark ==================刷新集成==============================

-(void)addRefreshControl
{
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        
        //    [self loadData];
    }];
    self.tableView.mj_header=header;
    
    MJRefreshAutoNormalFooter *footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        
        
        self.dateString=[NSString stringWithFormat:@"before/%lu",_page--];
        
        NSString *urlStr=[NSString stringWithFormat:@"%@%@",Home_NetRequest,self.dateString];
        
        
        [self loadDataWithString:urlStr];
    }];
    self.tableView.mj_footer=footer;
    
    
}

#pragma mark========================UIScrollViewDelegate====================
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _lastContentOffSet=self.tableView.contentOffset.y;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<_lastContentOffSet) {
        _isUp=NO;
    }else{
        _isUp=YES;
    }
}






#pragma mark =================UITableViewDelegate============
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoryPageViewController *storyVC=[[StoryPageViewController alloc]init];
    
    storyVC.allStoryArr=self.sectionDataSource[indexPath.section];
    storyVC.model=self.sectionDataSource[indexPath.section][indexPath.row];
    
    [self.navigationController pushViewController:storyVC animated:YES];
    
}
-(void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{

    if (_isUp==YES) {
        
        NSString *string;
        if (section==0) {
         string=@"最新の新闻";
        }else{
            HomePageModel *model=self.dateRecordSource[section];
            string=model.date;
        }
        self.navigationItem.title=string;
    }

}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if (_isUp==NO) {
        NSString *string;
        if (section==0) {
            string=@"最新の新闻";
        }else if(section==1){
            string=@"最新の新闻";
           
        }else{
            HomePageModel *model=self.dateRecordSource[section-1];
            string=model.date;
        }
        self.navigationItem.title=string;

        
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionDataSource.count;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0,0 , SCREEN_SIZE.width, 50)];
    
    NSString *string;
    if (section==0) {
       string= @"最新の新闻";
    }else{

        HomePageModel*model=self.dateRecordSource[section];

        string= model.date;
    }
    label.text=string;
    label.font=[UIFont systemFontOfSize:18];
    label.textAlignment=NSTextAlignmentCenter;
    return label;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.sectionDataSource[section] count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomePageCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[HomePageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }


        self.dataSource=self.sectionDataSource[indexPath.section];
        
        StoryModel *model=self.dataSource[indexPath.row];
        cell.model=model;
        return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}


#pragma mark ===============懒加载=========

-(UILabel*)sectionTitleLabel
{

    if (!_sectionTitleLabel) {
        _sectionTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 50)];
        _sectionTitleLabel.textAlignment=NSTextAlignmentCenter;
        _sectionTitleLabel.backgroundColor=[UIColor grayColor];
    }
    return _sectionTitleLabel;
}
-(UITableView*)tableView
{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.tableHeaderView=self.headerView;
        
        [self addRefreshControl];
        
    }
    return _tableView;
}

-(NSMutableArray*)dataSource
{
    if (!_dataSource) {
        _dataSource=[[NSMutableArray alloc]init];
        
    }
    return _dataSource;
}
-(NSMutableArray*)sectionDataSource
{
    if (!_sectionDataSource) {
        _sectionDataSource=[[NSMutableArray alloc]init];
        
    }
    return _sectionDataSource;
}
-(NSMutableArray*)dateRecordSource
{
    if (!_dateRecordSource) {
        _dateRecordSource=[[NSMutableArray alloc]init];
        
    }
    return _dateRecordSource;
}

-(TopStoryView*)headerView
{
    if (!_headerView) {
        _headerView =[[TopStoryView alloc]init];
    }
    return _headerView;
}
@end
