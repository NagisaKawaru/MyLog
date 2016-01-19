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
@interface HomePageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self formulateNavigationBar];
    [self.view addSubview:self.tableView];
    
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
    
    [manager GET:NEWESTMESSAGE parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self parseMainData:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"------------->%@",error);
    }];

}

-(void)parseMainData:(NSDictionary*)data
{
    NSArray *allData=data[@"stories"];
    
    for (NSDictionary *dict in allData) {
        StoryModel *model=[[StoryModel alloc]initWithDictionary:dict error:nil];
        
        [self.dataSource addObject:model];
    }
    [self.tableView reloadData];

}





#pragma mark =================UITableViewDelegate============
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"EVA%lu号机",section];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomePageCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[HomePageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    StoryModel *model=self.dataSource[indexPath.row];
    cell.model=model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}


#pragma mark ===============懒加载=========
-(UITableView*)tableView
{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        
        
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
@end
