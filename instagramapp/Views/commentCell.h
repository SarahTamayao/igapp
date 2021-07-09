//
//  commentCell.h
//  instagramapp
//
//  Created by Laura Yao on 7/9/21.
//

#import <UIKit/UIKit.h>
//#import <Parse/Parse.h>
#import "Comment.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface commentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *commentText;
@property (weak, nonatomic) IBOutlet UILabel *timestamp;
@property (weak, nonatomic) IBOutlet PFImageView *profilePic;
@property (strong, nonatomic) Comment *comment;

@end

NS_ASSUME_NONNULL_END
