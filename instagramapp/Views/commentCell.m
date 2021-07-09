//
//  commentCell.m
//  instagramapp
//
//  Created by Laura Yao on 7/9/21.
//

#import "commentCell.h"
#import "Comment.h"
#import <Parse/Parse.h>
#import "DateTools.h"

@implementation commentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setComment:(Comment *)comment{
    _comment = comment;
    self.commentText.text = comment[@"comment"];
    self.username.text = comment.author[@"username"];
    
    NSDate *date = comment.createdAt;
    NSString *timePost = date.shortTimeAgoSinceNow;
    self.timestamp.text = timePost;
    self.profilePic.layer.cornerRadius = 25;
    self.profilePic.layer.masksToBounds = YES;
    
    self.profilePic.file = comment.author[@"profilePic"];
    [self.profilePic loadInBackground];
    
}

@end
