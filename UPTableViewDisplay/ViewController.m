//
//  ViewController.m
//  UPTableViewDisplay
//
//  Created by wust_LiTao on 2016/12/3.
//  Copyright © 2016年 李锦民. All rights reserved.
//

#import "ViewController.h"
#import "UPScrollViewBar.h"
#import "UPTableViewController.h"

@interface ViewController ()<UPScrollViewBarDelegate,
                             UIScrollViewDelegate>

@property(nonatomic, strong)UIScrollView *backScrollView;
@property(nonatomic, strong)NSArray *dataArr;
@property(nonatomic, strong)NSMutableArray *btnArrM;
@end

@implementation ViewController

-(NSMutableArray *)btnArrM{
    
    if (_btnArrM == nil) {
        
        _btnArrM = [NSMutableArray array];
    }
    
    return _btnArrM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dataArr = [NSArray arrayWithObjects:@"火影忍者",@"死神",@"约会大作战",@"海贼王",@"刀剑神域",@"夏目友人帐", nil];
    [self initView];
    [self addChildController];
}

-(void)initView{
    
    UPScrollViewBar *scrollBar = [UPScrollViewBar creatScrollBar];
    scrollBar.dataArr = _dataArr;
    scrollBar.delegate = self;
    [self.view addSubview:scrollBar];
    
    self.backScrollView = [[UIScrollView alloc]init];
    self.backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(scrollBar.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(scrollBar.frame))];
    self.backScrollView.showsHorizontalScrollIndicator = NO;
    self.backScrollView.pagingEnabled = YES;
    self.backScrollView.delegate = self;
    [self.view addSubview:self.backScrollView];
    self.backScrollView.contentSize = CGSizeMake(self.dataArr.count * ScreenW, 0);
    
    //获取所有的按钮,默认第一个按钮被选择
    for (id view in scrollBar.subviews.firstObject.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            
            [self.btnArrM addObject:view];
        }
    }
}

-(void)addChildController{
    
    for (int i = 0; i < self.dataArr.count; ++i) {
        
        UPTableViewController *tableViewDisplay = [[UPTableViewController alloc]init];
        [self addChildViewController:tableViewDisplay];
    }
    
    //默认显示第0个控制器
    [self scrollViewDidEndScrollingAnimation:self.backScrollView];
}

#pragma UPScrollViewBarDelegate
-(void)didClickBtn:(UIButton *)clickBtn{
    
    //点击结束后显示相应的控制器
    [self scrollViewDidEndScrollingAnimation:self.backScrollView];
    
    //移动backScrollView的位置
    CGPoint offset = self.backScrollView.contentOffset;
    offset.x = [self.btnArrM indexOfObject:clickBtn] * ScreenW;
    [self.backScrollView setContentOffset:offset animated:YES];
}

#pragma UIScrollViewDelegate
//通过代码setContentOffset:animated:让scrollView滚动完毕后，就会调用这个方法
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    int index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    UIViewController *willShowChildVc = self.childViewControllers[index];
    if (willShowChildVc.isViewLoaded) return;
    
    //添加子控制器的view到scrollView
    willShowChildVc.view.frame = CGRectMake(index * scrollView.bounds.size.width, 0, scrollView.bounds.size.width, scrollView.bounds.size.height);
    [scrollView addSubview:willShowChildVc.view];
}

//人为拖曳就会调用这个方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    //滑动结束后显示相应的控制器
    [self scrollViewDidEndScrollingAnimation:scrollView];

    //获取移动backScrollView后对应的按钮，并将其对应的按钮移动到相应的位置
    int index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    NSMutableDictionary *useInfo = [NSMutableDictionary dictionary];
    useInfo[@"moveBtn"] = self.btnArrM[index];
    [[NSNotificationCenter defaultCenter] postNotificationName:UPButtonNeedMove object:nil userInfo:useInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden{
    
    return YES;
}

@end
