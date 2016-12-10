//
//  UPTableViewDisplay.m
//  UPTableViewDisplay
//
//  Created by wust_LiTao on 2016/12/3.
//  Copyright © 2016年 李锦民. All rights reserved.
//

#import "UPTableViewDisplay.h"
#import "UPDisplayViewCell.h"
#import "UPTableViewInterceptor.h"

@interface UPTableViewDisplay()<UITableViewDataSource,
                                UITableViewDelegate>

@property(nonatomic, strong)UPTableViewInterceptor *dataSourceInterceptor;
@property(nonatomic, assign)NSInteger actualRows;
@property(nonatomic, assign)BOOL firstLoad;
@end
@implementation UPTableViewDisplay

- (UPTableViewInterceptor *)dataSourceInterceptor {
    
    if (!_dataSourceInterceptor) {
        _dataSourceInterceptor = [[UPTableViewInterceptor alloc]init];
        _dataSourceInterceptor.middleMan = self;
    }
    return _dataSourceInterceptor;
}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    self = [super initWithFrame:frame style:style];
    if (self) {
    
        self.firstLoad = YES;
        self.rowHeight = (ScreenH - scrollViewBarH) / showCellCount;
        self.showsVerticalScrollIndicator = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

-(void)layoutSubviews{
    
    [self scrollCellForever];
    [self changeCellFrame];
    [super layoutSubviews];
}

-(void)scrollCellForever{
    
    CGPoint contentOffset  = self.contentOffset;
    
    //当UITableView滑到最顶部，并准备向下滑动
    if (contentOffset.y < 0.0) {
        
        contentOffset.y = self.contentSize.height / 3.0;
    //当UITableView滑到最底部，并准备向上滑动
    }else if (contentOffset.y >= (self.contentSize.height - self.bounds.size.height)) {
        
        contentOffset.y = self.contentSize.height / 3.0 - self.bounds.size.height;
    }
    [self setContentOffset: contentOffset];
}

-(void)changeCellFrame{
    
    NSArray *cells = [self visibleCells];
    CGFloat centerY = self.contentOffset.y + self.bounds.size.height / 2;
    
    for (UPDisplayViewCell *cell in cells) {
        
        //设置cell的缩放大小
        //CGFloat scale = (1 - ABS(cell.center.y - centerY) / self.bounds.size.height) * 1.05;
        CGFloat scale = 1 - ((ABS(cell.center.y - centerY) / self.bounds.size.height / showCellCount)) * 3.0;
        cell.backView.transform = CGAffineTransformMakeScale(scale, scale);
        
        //设置cell的颜色
        CGFloat distance = ABS(cell.center.y - centerY);
        if (distance > self.rowHeight) {
            
            cell.contentView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.0];
        }else{
            
            CGFloat alpha = ABS(1.0 - distance / self.rowHeight);
            cell.contentView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:alpha];
        }
        
    }
}

#pragma mark - DataSource Delegate Setter/Getter Override
- (void)setDataSource:(id<UITableViewDataSource>)dataSource {
    
    self.dataSourceInterceptor.receiver = dataSource;
    [super setDataSource:(id<UITableViewDataSource>)self.dataSourceInterceptor];
}

-(void)setDelegate:(id<UITableViewDelegate>)delegate{
    
    self.dataSourceInterceptor.receiver = delegate;
    [super setDelegate:(id<UITableViewDelegate>)self.dataSourceInterceptor];
}

#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    self.actualRows = [self.dataSourceInterceptor.receiver tableView:tableView numberOfRowsInSection:section];
    return self.actualRows * 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSIndexPath * actualIndexPath = [NSIndexPath indexPathForRow:indexPath.row % self.actualRows inSection:indexPath.section];
    return [self.dataSourceInterceptor.receiver tableView:tableView cellForRowAtIndexPath:actualIndexPath];
}

#pragma UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld",indexPath.row);
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.firstLoad) {
        
        UPDisplayViewCell *displayCell = (UPDisplayViewCell *)cell;
        int displayCellCenterY = displayCell.center.y;
        if (displayCellCenterY == (int)(self.frame.size.height / 2)) {//表示为中间的cell
            
            [self insertSubview:displayCell atIndex:self.subviews.count - 1];
        }else if (displayCellCenterY == (int)(self.frame.size.height / 2 - self.rowHeight)){//表示是第二个cell
            
            [self insertSubview:displayCell atIndex:self.subviews.count - 2];
        }
        
        //添加展开动画
        int moveDis = displayCell.center.y - self.bounds.size.height / 2;
        if (moveDis != 0) {
            
            CABasicAnimation *moveCellAnima = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
            moveCellAnima.fromValue = [NSNumber numberWithFloat:-moveDis];
            moveCellAnima.toValue = [NSNumber numberWithFloat:0.0];
            moveCellAnima.duration = 0.7;
            moveCellAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            [displayCell.layer addAnimation:moveCellAnima forKey:@"moveCellAnima"];
        }
        
    }
}

#pragma UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //取消cell加载动画
    self.firstLoad = NO;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self scrollCell:scrollView];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self scrollCell:scrollView];
}

-(void)scrollCell:(UIScrollView *)scrollView{
    
    CGPoint offset = scrollView.contentOffset;
    int moveCount = round(offset.y / self.rowHeight);
    offset.y = self.rowHeight * moveCount;
    
    //去除cell的滚动惯性
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setContentOffset:offset animated:YES];
    });
}

@end
