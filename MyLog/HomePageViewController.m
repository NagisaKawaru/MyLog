//
//  HomePageViewController.m
//  MyLog
//
//  Created by 杨利嘉 on 16/1/19.
//  Copyright © 2016年 杨利嘉. All rights reserved.
//

#import "HomePageViewController.h"

#import "StoryModel.h"
#import "HomePageCell.h"

#import "MJRefresh.h"

#define Home_NetRequest @"http://news.at.zhihu.com/api/4/news/"
@interface HomePageViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _page;
    BOOL _isRefreshing;
    NSInteger _sectionNum;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,copy)NSString *dateString;
@property(nonatomic,copy)NSString *urlString;

@property(nonatomic,strong)NSMutableArray *sectionDataSource;
@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self formulateNavigationBar];
    [self.view addSubview:self.tableView];
    
//    NSDateFormatter *dataFormatter=[[NSDateFormatter alloc]init];
//    [dataFormatter setDateFormat:@"yyyyMMdd"];
//    
//    
//    _page=[[dataFormatter stringFromDate:[NSDate date]] integerValue];
//
//    self.dateString=[NSString stringWithFormat:@"%lu",_page];
    self.dateString=@"latest";
    NSDateFormatter *dataFormatter=[[NSDateFormatter alloc]init];
    [dataFormatter setDateFormat:@"yyyyMMdd"];
    
    
    _page=[[dataFormatter stringFromDate:[NSDate date]] integerValue];
    self.urlString=[NSString stringWithFormat:@"%@%@",Home_NetRequest,self.dateString];
    _sectionNum=1;
    [self loadData];
}



-(void)formulateNavigationBar
{
   
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(navigationItemClicked:)];
    self.navigationItem.title=@"首页";
//    self.navigationController.navigationItem.
    
}
-(void)navigationItemClicked:(UINavigationItem*)item
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"rightSwip" object:nil];
}



-(void)loadData
{
    
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    

    
    
    [manager GET:self.urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self parseMainData:responseObject];
        
        [self doneLoadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"------------->%@",error);
    }];
    

}
-(void)doneLoadData
{
    [self.tableView.mj_header endRefreshing];
    
    [self.tableView.mj_footer endRefreshing];
    
    [self.tableView reloadData];
}

-(void)parseMainData:(NSDictionary*)data
{
    NSArray *allData=data[@"stories"];
    
    [self.dataSource removeAllObjects];
    for (NSDictionary *dict in allData) {
        StoryModel *model=[[StoryModel alloc]initWithDictionary:dict error:nil];
        
        [self.dataSource addObject:model];
    }
    [self.sectionDataSource addObject:self.dataSource];
    [self.tableView reloadData];

}





#pragma mark =================UITableViewDelegate============
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionDataSource.count;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel * label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"hehe%lu",_page];
    label.userInteractionEnabled = YES;
    label.tag = 100 + section;
    return label;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
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
//    if (self.sectionDataSource.count==1) {
//        StoryModel *model=self.dataSource[indexPath.row];
//        cell.model=model;
//    }else if(self.sectionDataSource.count>1){
        self.dataSource=self.sectionDataSource[indexPath.section];
        
        StoryModel *model=self.dataSource[indexPath.row];
        cell.model=model;
//    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

-(void)addRefreshControl
{
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        
        [self loadData];
    }];
    self.tableView.mj_header=header;
    
    MJRefreshAutoNormalFooter *footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        
        
            self.dateString=[NSString stringWithFormat:@"before/%lu",_page--];
        
        self.urlString=[NSString stringWithFormat:@"%@%@",Home_NetRequest,self.dateString];
        NSLog(@"%lu",_page);
        _sectionNum++;
        [self loadData];
    }];
    self.tableView.mj_footer=footer;
    
    
}

#pragma mark ===============懒加载=========
-(UITableView*)tableView
{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        
        
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
@end
