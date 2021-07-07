//
//  igCell.h
//  instagramapp
//
//  Created by Laura Yao on 7/6/21.
//

#import <UIKit/UIKit.h>
#import "Post.h"
//#import <ParseUIConstants.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface igCell : UITableViewCell
//@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *postUsername;
@property (weak, nonatomic) IBOutlet UILabel *postCaption;
@property (weak, nonatomic) IBOutlet PFImageView *postImageViw;
@property (nonatomic, strong) Post *post;

@end

NS_ASSUME_NONNULL_END
