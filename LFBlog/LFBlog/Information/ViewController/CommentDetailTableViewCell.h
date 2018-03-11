//
//  CommentDetailTableViewCell.h
//  HEMS
//
//  Created by 王力丰 on 2017/11/6.
//  Copyright © 2017年 杭州天丽科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommentDetailTableViewCellDelegate<NSObject>
-(void)thumbAction:(BOOL)thumbState andCommentId:(NSString *)commentId;
@end

@interface CommentDetailTableViewCell : UITableViewCell
//评论的ID序列
@property (nonatomic, strong) NSString *commentId;
//左侧的头像
@property (nonatomic, strong) UIImageView *avatar;
//顶部的帐号名称Label
@property (nonatomic, strong) UILabel *accountLabel;
//中间的评论详情
@property (nonatomic, strong) UILabel *commentDetail;
//中间下面的事件Label
@property (nonatomic, strong) UILabel *timeLabel;
//右下角的点赞数量
@property (nonatomic, strong) UILabel *thumbNum;
//右下角的点赞图标
@property (nonatomic, strong) UIButton *thumbIcon;
//右下角的点赞按钮
@property (nonatomic, strong) UIButton *thumbButton;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, assign) BOOL thumbState;

@property (nonatomic, assign) id delegate;

-(void)setCommmentDetailWithText:(NSString*)text;



@end
