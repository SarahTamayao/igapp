//
//  Comment.m
//  instagramapp
//
//  Created by Laura Yao on 7/9/21.
//

#import "Comment.h"
#import <Parse/Parse.h>

@implementation Comment
@dynamic author;
@dynamic objectId;
@dynamic post;
@dynamic comment;
@dynamic createdAt;

+ (nonnull NSString *)parseClassName {
    return @"Comment";
}
+ (void) postComment: (NSString * _Nullable )comment withPost: (Post * _Nullable )post withCompletion: (PFBooleanResultBlock  _Nullable)completion{
    Comment *newComment = [Comment new];
    newComment.comment = comment;
    newComment.post = post;
    newComment.author = [PFUser currentUser];
    newComment.createdAt = [NSDate date];
    
    [newComment saveInBackgroundWithBlock: completion];
    
}

@end
