//
//  CommentDetailTableViewCell.m
//  HEMS
//
//  Created by 王力丰 on 2017/11/6.
//  Copyright © 2017年 杭州天丽科技有限公司. All rights reserved.
//

#import "CommentDetailTableViewCell.h"

@implementation CommentDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


- (void)initLayuot {
    _avatar = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 50, 50)];
    _avatar.layer.cornerRadius = 25.f;
    _avatar.layer.masksToBounds = YES;
    [self addSubview:_avatar];
    _accountLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 20, SCREEN_WIDTH - 90, 20)];
    _accountLabel.font = [UIFont systemFontOfSize:15.f];
    _accountLabel.textColor = DEFAULT_BLUE_COLOR;
    [self addSubview:_accountLabel];
    _commentDetail = [[UILabel alloc]init];
    _commentDetail.font = [UIFont systemFontOfSize:15.f];
    [self addSubview:_commentDetail];
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.textColor = [UIColor lightGrayColor];
    _timeLabel.font = [UIFont systemFontOfSize:11.f];
    [self addSubview:_timeLabel];
    _thumbNum = [[UILabel alloc]init];
    _thumbNum.textColor = [UIColor lightGrayColor];
    _thumbNum.textAlignment = NSTextAlignmentRight;
    _thumbNum.font = [UIFont systemFontOfSize:11.f];
    [self addSubview:_thumbNum];
    _thumbIcon = [[UIButton alloc]init];
    [_thumbIcon addTarget:self action:@selector(thumb) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_thumbIcon];
    _thumbButton = [[UIButton alloc]init];
    [self addSubview:_thumbButton];
    
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    [self addSubview:_lineView];
}

//赋值 and 自动换行,计算出cell的高度
-(void)setCommmentDetailWithText:(NSString*)text{
    //获得当前cell高度
    CGRect frame = [self frame];
    //文本赋值
    self.commentDetail.text = text;
    //设置label的最大行数
    self.commentDetail.numberOfLines = 10;
    CGSize size = CGSizeMake(SCREEN_WIDTH - 90, 1000);
    CGRect labelRect = [self.commentDetail.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.f]} context:nil];
    self.commentDetail.frame = CGRectMake(70, 50, labelRect.size.width, labelRect.size.height);
    
    self.timeLabel.frame = CGRectMake(70, labelRect.size.height+ 50+5, 130, 20);
    self.thumbNum.frame = CGRectMake(SCREEN_WIDTH- 155, labelRect.size.height+ 50+5, 110, 20);
    self.thumbIcon.frame = CGRectMake(SCREEN_WIDTH - 40, labelRect.size.height+ 50, 20, 20);
    self.thumbButton.frame = CGRectMake(SCREEN_WIDTH - 160, labelRect.size.height +50, 160, 30);
    [self.thumbButton addTarget:self action:@selector(thumb) forControlEvents:UIControlEventTouchUpInside];
    self.lineView.frame = CGRectMake(20, labelRect.size.height + 80 - 0.5, SCREEN_WIDTH - 30, 0.5);
    //计算出自适应的高度
    frame.size.height = labelRect.size.height + 80;
    
    self.frame = frame;
}

- (void)thumb {
    [self.delegate thumbAction:self.thumbState andCommentId:self.commentId];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
