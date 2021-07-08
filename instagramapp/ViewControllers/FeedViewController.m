//
//  FeedViewController.m
//  instagramapp
//
//  Created by Laura Yao on 7/6/21.
//

#import "FeedViewController.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"
//#import "AppDelegate.h"
#import "SceneDelegate.h"
#import "Post.h"
#import "igCell.h"
#import "DetailsViewController.h"

@interface FeedViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *postArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self fetchPosts];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview: self.refreshControl atIndex:0];
    
    self.isMoreDataLoading = false;
    CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    self.loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    self.loadingMoreView.hidden = true;
    [self.tableView addSubview:self.loadingMoreView];
        
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    self.tableView.contentInset = insets;
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"postHeader"];
        
    // Do any additional setup after loading the view.
}
- (void)fetchPosts{
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    //[query whereKey:@"likesCount" greaterThan:@100];
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.postArray = posts;
            /*for (NSDictionary *post in posts){
                NSLog(@"%@", post[@"caption"]);
            }*/
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}
- (void) loadMoreData:(NSInteger)count{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    //[query whereKey:@"likesCount" greaterThan:@100];
    query.limit = count;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.postArray = posts;
            self.isMoreDataLoading = false;
            [self.loadingMoreView stopAnimating];
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}
- (IBAction)logoutAction:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        if (error != nil){
            NSLog(@"Error");
        }
        else{
            SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            myDelegate.window.rootViewController = loginViewController;
        }
    }];
    
}
- (IBAction)composeAction:(id)sender {
    [self performSegueWithIdentifier:@"composeSegue" sender:nil];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.postArray.count;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    igCell *cell = (igCell *) [tableView dequeueReusableCellWithIdentifier:@"igCell" forIndexPath:indexPath];
    cell.post = (Post *)self.postArray[indexPath.section];
    [cell setPost:cell.post];
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *headerText = self.postArray[section][@"author"][@"username"];
    return [headerText lowercaseString];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    UIImage *myImage = [UIImage imageNamed:@"image_placeholder.png"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
    
    PFFileObject *userImageFile = self.postArray[section][@"author"][@"profilePic"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            imageView.image = [UIImage imageWithData:imageData];
        }
    }];
    
    UILabel *myLabel = [[UILabel alloc] init];
    [headerView addSubview:myLabel];
    [headerView addSubview:imageView];
    imageView.translatesAutoresizingMaskIntoConstraints = false;
    
    myLabel.translatesAutoresizingMaskIntoConstraints = false;
    
    //imageView.frame = CGRectMake(10,10,100,100);
    [imageView.widthAnchor constraintEqualToConstant:25].active = YES;
    [imageView.heightAnchor constraintEqualToConstant:25].active = YES;
    [imageView.leadingAnchor constraintEqualToAnchor:headerView.leadingAnchor constant:10].active = YES;
    //[imageView.topAnchor constraintEqualToAnchor:headerView.topAnchor constant:8].active = YES;
    [imageView.bottomAnchor constraintEqualToAnchor:headerView.bottomAnchor constant:-8].active = YES;
    
    [myLabel.leadingAnchor constraintEqualToAnchor:imageView.trailingAnchor constant:10].active = YES;
    //[myLabel.topAnchor constraintEqualToAnchor:headerView.topAnchor constant:8].active = YES;
    [myLabel.trailingAnchor constraintEqualToAnchor:headerView.trailingAnchor constant:-8].active = YES;
    [myLabel.bottomAnchor constraintEqualToAnchor:headerView.bottomAnchor constant:-8].active = YES;
    imageView.layer.cornerRadius = 25/2;
    imageView.layer.masksToBounds = YES;
    
    //myLabel.frame = CGRectMake(150, 10, 320, 20);
    myLabel.font = [UIFont boldSystemFontOfSize:18];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];

    
    return headerView;
}
/*- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;

    header.textLabel.textColor = [UIColor blackColor];
    header.textLabel.font = [UIFont boldSystemFontOfSize:18];
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
    header.textLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    //header.textLabel.textAlignment = NSTextAlignmentCenter;
}*/
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
     // Handle scroll behavior here
    if(!self.isMoreDataLoading){
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
               
               // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
            self.loadingMoreView.frame = frame;
            [self.loadingMoreView startAnimating];
                   
            [self loadMoreData:[self.postArray count]+20];
        }

    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"detailSegue"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Post *poster = (Post *)self.postArray[indexPath.section];
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.post = poster;
    }
}


@end
