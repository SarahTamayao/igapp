//
//  CommentViewController.m
//  instagramapp
//
//  Created by Laura Yao on 7/9/21.
//

#import "CommentViewController.h"
#import "Comment.h"
#import "commentCell.h"
#import <Parse/Parse.h>

@interface CommentViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *commentField;
@property (strong, nonatomic) NSArray *commentArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self fetchComments];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchComments) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview: self.refreshControl atIndex:0];
    // Do any additional setup after loading the view.
}
-(void)fetchComments{
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    
    [query orderByDescending:@"createdAt"];
    [query includeKeys:[[NSArray alloc] initWithObjects:@"author",@"post",nil]];
    [query whereKey:@"post" equalTo:self.post];
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray<Comment *> * _Nullable comments, NSError *error) {
        if (comments != nil) {
            // do something with the array of object returned by the call
            self.commentArray = comments;
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}
- (IBAction)commentBAction:(id)sender {
    [Comment postComment:self.commentField.text withPost:self.post withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(error==nil){
            NSLog(@"success");
            self.commentField.text = @"";
            self.post.commentCount =[NSNumber numberWithInt:([self.post.commentCount intValue]+1)];
            [self updateCommentCount];
            [self fetchComments];
        }
        else{
            NSLog(@"error");
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    commentCell *cell = (commentCell *) [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
    cell.comment = (Comment *)self.commentArray[indexPath.row];
    return cell;
}
-(void)updateCommentCount{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:self.post.objectId
                                 block:^(PFObject *post, NSError *error) {
        if(error==nil){
            NSLog(@"success");
            post[@"commentCount"] = self.post.commentCount;
            [post saveInBackground];
        }
        else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
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
