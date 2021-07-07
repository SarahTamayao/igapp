//
//  DetailsViewController.m
//  instagramapp
//
//  Created by Laura Yao on 7/7/21.
//

#import "DetailsViewController.h"
#import "DateTools.h"
@import Parse;

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *postView;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *caption;
@property (weak, nonatomic) IBOutlet UILabel *timeStamp;

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
    [self.postView loadInBackground];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
