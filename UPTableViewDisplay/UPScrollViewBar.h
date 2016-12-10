//
//  UPScrollViewBar.h
//  UPTableViewDisplay
//
//  Created by wust_LiTao on 2016/12/3.
//  Copyright © 2016年 李锦民. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UPScrollViewBar;
@protocol  UPScrollViewBarDelegate <NSObject>

-(void)didClickBtn:(UIButton *)clickBtn;
@end

@interface UPScrollViewBar : UIView
@property(nonatomic, weak)id<UPScrollViewBarDelegate> delegate;
@property(nonatomic, strong)NSArray *dataArr;
+(instancetype)creatScrollBar;
@end
