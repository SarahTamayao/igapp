//
//  profileCell.h
//  instagramapp
//
//  Created by Laura Yao on 7/8/21.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@import Parse;


NS_ASSUME_NONNULL_BEGIN

@interface profileCell : UICollectionViewCell
@property (nonatomic, strong) Post *post;
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;

@end

NS_ASSUME_NONNULL_END
