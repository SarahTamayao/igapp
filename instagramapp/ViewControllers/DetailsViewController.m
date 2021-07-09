//
//  DetailsViewController.m
//  instagramapp
//
//  Created by Laura Yao on 7/7/21.
//

#import "DetailsViewController.h"
#import "DateTools.h"
#import "CommentViewController.h"
@import Parse;

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *postView;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *caption;
@property (weak, nonatomic) IBOutlet UILabel *timeStamp;
@property (weak, nonatomic) IBOutlet PFImageView *profilePic;
@property (weak, nonatomic) IBOutlet UIButton *numberofComments;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *numberofLikes;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpView];
}
- (void) setUpView{
    self.caption.text = self.post[@"caption"];
    self.username.text = self.post[@"author"][@"username"];
    self.postView.file = self.post[@"image"];
    NSDate *date = self.post.createdAt;
    NSString *timePost = date.timeAgoSinceNow;
    self.timeStamp.text = timePost;
    NSString *endLike = @" others";
    NSString *beginLike = [self.post.likeCount stringValue];
    self.numberofLikes.text = [beginLike stringByAppendingString:endLike];
    NSString *beginCommentCount = @"View all ";
    NSString *endCommentCount = @" comments";
    NSString *midCC = [beginCommentCount stringByAppendingString:[self.post.commentCount stringValue]];
    [self.numberofComments setTitle:[midCC stringByAppendingString:endCommentCount] forState:UIControlStateNormal];
    BOOL favorited = [self.post.likes containsObject:[PFUser currentUser].username];
    if(favorited){
        [self.likeButton setImage:[UIImage imageNamed:@"like-button-red.png"] forState:UIControlStateNormal];
    }
    else{
        [self.likeButton setImage:[UIImage imageNamed:@"like-button.png"] forState:UIControlStateNormal];
    }
    self.profilePic.layer.cornerRadius = 25;
    self.profilePic.layer.masksToBounds = YES;
    
    self.profilePic.file = self.post.author[@"profilePic"];
    [self.profilePic loadInBackground];
    [self.postView loadInBackground];
    
}
- (IBAction)tapLike:(id)sender {
    if(self.post.likes){
        BOOL favorited = [self.post.likes containsObject:[PFUser currentUser][@"username"]];
        if(favorited){
            [self.post.likes removeObject:[PFUser currentUser][@"username"]];
            [self.likeButton setImage:[UIImage imageNamed:@"like-button.png"] forState:UIControlStateNormal];
            self.post.likeCount = [NSNumber numberWithInt:([self.post.likeCount intValue]-1)];
            [self updatelikes];
        }
        else{
            [self.post.likes addObject:[PFUser currentUser][@"username"]];
            [self.likeButton setImage:[UIImage imageNamed:@"like-button-red.png"] forState:UIControlStateNormal];
            self.post.likeCount = [NSNumber numberWithInt:([self.post.likeCount intValue]+1)];
            [self updatelikes];
        }
    }
    else{
        self.post.likes = [[NSMutableArray alloc] initWithObjects:[PFUser currentUser].username, nil];
        [self.likeButton setImage:[UIImage imageNamed:@"like-button-red.png"] forState:UIControlStateNormal];
        self.post.likeCount = @(1);
        [self updatelikes];
    }
}
- (IBAction)tapComment:(id)sender {
    [self performSegueWithIdentifier:@"showComment" sender:nil];
}
-(void) updatelikes{
    NSString *endLike = @" others";
    NSString *beginLike = [self.post.likeCount stringValue];
    self.numberofLikes.text = [beginLike stringByAppendingString:endLike];
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:self.post.objectId
                                 block:^(PFObject *post, NSError *error) {
        if(error==nil){
            NSLog(@"success");
            post[@"likes"] = [[NSArray alloc] initWithArray:self.post.likes];
            post[@"likeCount"] = self.post.likeCount;
            [post saveInBackground];
        }
        else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];

}
- (IBAction)viewComments:(id)sender {
    [self performSegueWithIdentifier:@"showComment" sender:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"showComment"]){
        CommentViewController *commentViewController = [segue destinationViewController];
        commentViewController.post = self.post;
    }
}


@end
