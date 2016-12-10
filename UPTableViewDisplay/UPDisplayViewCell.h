//
//  UPDisplayViewCell.h
//  UPTableViewDisplay
//
//  Created by wust_LiTao on 2016/12/5.
//  Copyright © 2016年 李锦民. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UPDisplayViewCell : UITableViewCell
@property(nonatomic, strong)UIView *backView;
@property(nonatomic, strong)UIImageView *iconImgView;
@property(nonatomic, strong)UILabel *textTitleLab;

+(instancetype)CellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
