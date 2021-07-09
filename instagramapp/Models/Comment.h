//
//  Comment.h
//  instagramapp
//
//  Created by Laura Yao on 7/9/21.
//

#import <Parse/Parse.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface Comment : PFObject <PFSubclassing>
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) Post *post;
@property (nonatomic,strong) NSDate *createdAt;

+ (void) postComment: (NSString * _Nullable )comment withPost: (Post * _Nullable )post withCompletion: (PFBooleanResultBlock  _Nullable)completion;
@end

NS_ASSUME_NONNULL_END
