//
//  UPTableViewController.m
//  UPTableViewDisplay
//
//  Created by wust_LiTao on 2016/12/5.
//  Copyright © 2016年 李锦民. All rights reserved.
//

#import "UPTableViewController.h"
#import "UPTableViewDisplay.h"
#import "UPDisplayViewCell.h"

@interface UPTableViewController ()<UITableViewDataSource,
                                    UITableViewDelegate>

@property(nonatomic, strong)NSMutableArray *iconImgsArr;
@property(nonatomic, strong)NSArray *textArr;
@end

@implementation UPTableViewController

-(NSMutableArray *)iconImgsArr{
    
    if (_iconImgsArr == nil) {
        
        _iconImgsArr = [NSMutableArray array];
        
        for (int i = 0; i < 7; ++i) {
            
            UIImage *iconImg = [UIImage imageNamed:[NSString stringWithFormat:@"00%d",i+1]];
            [self.iconImgsArr addObject:iconImg];
        }
    }
    
    return _iconImgsArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textArr = [NSArray arrayWithObjects:@"\"死是现实的延续、生是梦的结束、喜欢我吗?\"",@"\"你知道雪为什么是白色的吗？\"",@"\"我早已闭上了双眼，我的目的只有在黑暗中才能实现.\"",@"\"樱花下落的速度，依旧是秒速五厘米.\"",@"\"错的不是我，是这个世界.\"",@"\"镜子里显示出来的永远不是真实的自己.\"",@"\"雪化之后是什么呢？是春天吧!\"", nil];
    
    UPTableViewDisplay *displayTableView = [[UPTableViewDisplay alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - scrollViewBarH) style:UITableViewStylePlain];
    displayTableView.dataSource = self;
    displayTableView.delegate = self;
    
    [self.view addSubview:displayTableView];

}

#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.iconImgsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UPDisplayViewCell *cell = [UPDisplayViewCell CellWithTableView:tableView cellForRowAtIndexPath:indexPath];
    cell.iconImgView.image = self.iconImgsArr[indexPath.row];
    cell.textTitleLab.text = self.textArr[indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
