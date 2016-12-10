//
//  UPScrollViewBar.m
//  UPTableViewDisplay
//
//  Created by wust_LiTao on 2016/12/3.
//  Copyright © 2016年 李锦民. All rights reserved.
//

#import "UPScrollViewBar.h"

#define selectedBtnFont [UIFont boldSystemFontOfSize:16]
#define normalBtnFont [UIFont boldSystemFontOfSize:14]
#define selectedBtntextColor [UIColor purpleColor]
#define normalBtntextColor [UIColor whiteColor]

static const CGFloat btnMargin = 4.0;

@interface UPScrollViewBar()<UIScrollViewDelegate>
@property(nonatomic, strong)UIScrollView *scrollBackView;
@property(nonatomic, strong)UILabel *bottomLab;
@property(nonatomic, strong)UIButton *lastBtn;
@property(nonatomic, assign)CGFloat lastBtnW;
@end

@implementation UPScrollViewBar

+(instancetype)creatScrollBar{
    
    return [[self alloc]init];
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = CGRectMake(0, 0, ScreenW, scrollViewBarH);
        [self initScrollView];
        
        //监听srollview的滚动，移动按钮到相应的位置
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(titleMoved:) name:UPButtonNeedMove object:nil];
    }
    
    return self;
}

-(void)titleMoved:(NSNotification *)notify{
    
    UIButton *moveBtn = notify.userInfo[@"moveBtn"];
    [self moveBtn:moveBtn];
}

-(void)initScrollView{
    
    self.scrollBackView = [[UIScrollView alloc]initWithFrame:self.bounds];
    self.scrollBackView.backgroundColor = [UIColor lightGrayColor];
    self.scrollBackView.showsHorizontalScrollIndicator = NO;
    self.scrollBackView.delegate = self;
    [self addSubview:self.scrollBackView];
}

-(void)setDataArr:(NSArray *)dataArr{
    
    _dataArr = dataArr;
    [self addBtnInScrollView];
}

-(void)addBtnInScrollView{
    
    self.bottomLab = [[UILabel alloc]init];
    self.bottomLab.backgroundColor = selectedBtntextColor;

    CGFloat btnY = 0;
    int btnH = scrollViewBarH;
    for (int i = 0; i < self.dataArr.count; ++i) {
        
        //获取文字的宽度,根据文字的宽度设置按钮的宽度
        CGSize textSize = [self getTextSize:self.dataArr[i]];
        CGFloat textW = textSize.width;
        self.lastBtnW = textW + 2 * btnMargin;
        btnY = btnY + textW + 2 * btnMargin;
      
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnY - self.lastBtnW, 0, textW + 2 * btnMargin, btnH);
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitle:self.dataArr[i] forState:UIControlStateNormal];
        if (i == 0) {//初始化时默认第一个按钮被选中
            
            self.bottomLab.frame = CGRectMake(0, btnH - 2, textW + 2 * btnMargin, 2);
            [self.scrollBackView addSubview:self.bottomLab];
            
            [btn setTitleColor:selectedBtntextColor forState:UIControlStateNormal];
            btn.titleLabel.font = selectedBtnFont;
            self.lastBtn = btn;
        }else{
            
            [btn setTitleColor:normalBtntextColor forState:UIControlStateNormal];
            btn.titleLabel.font = normalBtnFont;
        }
        [btn addTarget:self action:@selector(moveBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        //设置scrollView的contentSize，使其滚动
        [self.scrollBackView addSubview:btn];
        self.scrollBackView.contentSize = CGSizeMake(CGRectGetMaxX(btn.frame), 0);
    }
}

-(void)moveBtn:(UIButton *)btn{
    
    CGPoint offset = self.scrollBackView.contentOffset;
    offset.x = btn.center.x - ScreenW / 2;
    
    if (offset.x + ScreenW >= self.scrollBackView.contentSize.width) {//处理scrollView右边部分
        
        offset.x = self.scrollBackView.contentSize.width - ScreenW;
        [self.scrollBackView setContentOffset:offset animated:YES];
    }else if(offset.x <= 0){//处理scrollView左边部分
        
        offset.x = 0;
        [self.scrollBackView setContentOffset:offset animated:YES];
    }else{
        
        [self.scrollBackView setContentOffset:offset animated:YES];
    }
    
    //移动bottomLab,并重新设置bottomLab的位置和长度以及按钮的文字颜色和大小
    [UIView animateWithDuration:bottomLabMoveTime animations:^{
        
        CGPoint bottomLabCenter = self.bottomLab.center;
        bottomLabCenter.x = btn.center.x;
        self.bottomLab.center = bottomLabCenter;
        
        CGSize bottomLabSize = self.bottomLab.bounds.size;
        CGFloat scaleW = btn.bounds.size.width / bottomLabSize.width;
        self.bottomLab.transform = CGAffineTransformMakeScale(scaleW, 1.0);

        [self.lastBtn setTitleColor:normalBtntextColor forState:UIControlStateNormal];
        self.lastBtn.titleLabel.font = normalBtnFont;
        [btn setTitleColor:selectedBtntextColor forState:UIControlStateNormal];
        btn.titleLabel.font = selectedBtnFont;
    }];
    self.lastBtn = btn;
   
    //响应了点击按钮的代理
    if ([self.delegate respondsToSelector:@selector(didClickBtn:)]) {
        
        [self.delegate didClickBtn:btn];
    }
}

//获取字符串的长度
-(CGSize)getTextSize:(NSString *)text{
    
    
    NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = selectedBtnFont;
    
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:option attributes:attrs context:nil].size;
    return textSize;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
