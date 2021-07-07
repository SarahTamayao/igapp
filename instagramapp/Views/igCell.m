//
//  igCell.m
//  instagramapp
//
//  Created by Laura Yao on 7/6/21.
//

#import "igCell.h"

@implementation igCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setPost:(Post *)post {
    _post = post;
    self.postCaption.text = post[@"caption"];
    self.postUsername.text = post[@"author"][@"username"];
    self.postImageViw.file = post[@"image"];
    [self.postImageViw loadInBackground];
}

@end
