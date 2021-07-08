//
//  profileCell.m
//  instagramapp
//
//  Created by Laura Yao on 7/8/21.
//

#import "profileCell.h"

@implementation profileCell

- (void)setPost:(Post *)post {
    _post = post;
    self.profileImage.file = post[@"image"];
    [self.profileImage loadInBackground];
}

@end
