//
//  ViewController.m
//  OPAnnotation
//
//  Created by 温杰 on 2018/8/31.
//  Copyright © 2018年 温杰. All rights reserved.
//

#import "ViewController.h"
#import "OPHead.h"
#import "OPFirstViewController.h"
#import "OPTwoViewController.h"
#import "OPThirdViewController.h"
#import "OPFourViewController.h"
#import "OPVCAnnotion.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray  *datasource;
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   UITableView * table= [[UITableView alloc]initWithFrame: [UIScreen mainScreen].bounds style:0];
    table.delegate = self;
    table.dataSource = self;
    self.datasource = [NSMutableArray array];
    [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"vc"];
//    [self.datasource addObject:[[OPFirstViewController alloc]init]];
//    [self.datasource addObject:[[OPTwoViewController alloc]init]];
//     [self.datasource addObject:[[OPThirdViewController alloc]init]];
//     [self.datasource addObject:[[OPFourViewController alloc]init]];
    
   NSSet * set =  [OPVCAnnotion getVCWithType:@"UI"];
    for (Class cls in set) {
        [self.datasource addObject:[[cls.class alloc]init]];
    }
    
    [self.view addSubview:table];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"vc"];
    if (cell) {
        cell.textLabel.text = NSStringFromClass([[self.datasource objectAtIndex:indexPath.row] class]);
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self presentViewController:[self.datasource objectAtIndex:indexPath.row] animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
