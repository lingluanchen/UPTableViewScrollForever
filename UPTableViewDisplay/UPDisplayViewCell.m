//
//  UPDisplayViewCell.m
//  UPTableViewDisplay
//
//  Created by wust_LiTao on 2016/12/5.
//  Copyright © 2016年 李锦民. All rights reserved.
//

#import "UPDisplayViewCell.h"

#define textFont [UIFont boldSystemFontOfSize:14]
static const CGFloat imgMargin = 5.0;

@interface UPDisplayViewCell ()
@property(nonatomic, strong)UIView *lineView;
@property(nonatomic, strong)UIView *showTextView;
@end

@implementation UPDisplayViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)CellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UPDisplayViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UPDisplayCellID];
    if (cell == nil) {
        
        cell = [[UPDisplayViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UPDisplayCellID];
    }
    
    return cell;
}

//添加分割线
-(void)setFrame:(CGRect)frame{
    
    //frame.origin.y = frame.origin.y + 1;
    //frame.size.height = frame.size.height - 1;
    [super setFrame:frame];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor lightGrayColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //添加背景图
        self.backView = [[UIView alloc]init];
        self.backView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backView];
        
        //添加头像
        self.iconImgView = [[UIImageView alloc]init];
        self.iconImgView.layer.cornerRadius = imgMargin * 2;
        self.iconImgView.layer.masksToBounds = YES;
        [self.backView addSubview:self.iconImgView];
        
        //添加分割线
        self.lineView = [[UIView alloc]init];
        self.lineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.lineView];
        
        //添加文字
        self.showTextView = [[UIView alloc]init];
        self.showTextView.clipsToBounds = YES;
        [self.backView addSubview:self.showTextView];
        
        self.textTitleLab = [[UILabel alloc]init];
        self.textTitleLab.font = textFont;
        self.textTitleLab.textColor = [UIColor whiteColor];
        self.textTitleLab.textAlignment = NSTextAlignmentLeft;
        [self.showTextView addSubview:self.textTitleLab];
    }
    
    return self;
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.backView.center = self.contentView.center;
    self.backView.bounds = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    
    CGFloat iconImgWH = self.backView.bounds.size.height - 2 * imgMargin;
    self.iconImgView.frame = CGRectMake(imgMargin * 2, imgMargin, iconImgWH, iconImgWH);
    
    self.lineView.frame = CGRectMake(0, self.contentView.bounds.size.height - 1, self.contentView.bounds.size.width, 1);
    
    self.showTextView.frame = CGRectMake(CGRectGetMaxX(self.iconImgView.frame) + imgMargin, 0, self.contentView.frame.size.width - CGRectGetMaxX(self.iconImgView.frame) - imgMargin * 3, self.contentView.frame.size.height);
    
    //开启文字移动动画
    [self startTextAnimation];
}

-(void)startTextAnimation{
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = textFont;
    CGSize textSize = [self.textTitleLab.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
    self.textTitleLab.frame = CGRectMake(0, 0, textSize.width, self.showTextView.bounds.size.height);

    CGFloat moveDis = textSize.width - self.showTextView.bounds.size.width;
    if (moveDis > 0) {
        
        CAKeyframeAnimation *moveAnima = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        moveAnima.values = @[@(0),@(-moveDis),@(0)];
        moveAnima.repeatCount = MAXFLOAT;
        moveAnima.duration = moveDis * 0.08;
        [self.textTitleLab.layer addAnimation:moveAnima forKey:@"moveText"];
    }
}

@end
