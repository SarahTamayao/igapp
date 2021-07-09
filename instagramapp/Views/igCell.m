//
//  igCell.m
//  instagramapp
//
//  Created by Laura Yao on 7/6/21.
//

#import "igCell.h"
#import "DateTools.h"
#import <Parse/Parse.h>

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
    self.postImageViw.file = post[@"image"];
    NSDate *date = post.createdAt;
    NSString *timePost = date.timeAgoSinceNow;
    self.postTime.text = timePost;
    BOOL favorited = [self.post.likes containsObject:[PFUser currentUser].username];
    if(favorited){
        [self.likeButton setImage:[UIImage imageNamed:@"like-button-red.png"] forState:UIControlStateNormal];
    }
    else{
        [self.likeButton setImage:[UIImage imageNamed:@"like-button.png"] forState:UIControlStateNormal];
    }
    [self.postImageViw loadInBackground];
}
- (IBAction)likeAction:(id)sender {
    if(self.post.likes){
        BOOL favorited = [self.post.likes containsObject:[PFUser currentUser][@"username"]];
        if(favorited){
            [self.post.likes removeObject:[PFUser currentUser][@"username"]];
            [self.likeButton setImage:[UIImage imageNamed:@"like-button.png"] forState:UIControlStateNormal];
            [self updatelikes];
        }
        else{
            [self.post.likes addObject:[PFUser currentUser][@"username"]];
            [self.likeButton setImage:[UIImage imageNamed:@"like-button-red.png"] forState:UIControlStateNormal];
            [self updatelikes];
        }
    }
    else{
        self.post.likes = [[NSMutableArray alloc] initWithObjects:[PFUser currentUser].username, nil];
        [self.likeButton setImage:[UIImage imageNamed:@"like-button-red.png"] forState:UIControlStateNormal];
        NSLog(@"%@",self.post.likes);
        [self updatelikes];
    }
}
-(void) updatelikes{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:self.post.objectId
                                 block:^(PFObject *post, NSError *error) {
        if(error==nil){
            NSLog(@"success");
            post[@"likes"] = [[NSArray alloc] initWithArray:self.post.likes];
            [post saveInBackground];
        }
        else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];

}

@end
