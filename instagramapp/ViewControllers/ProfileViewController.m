//
//  ProfileViewController.m
//  instagramapp
//
//  Created by Laura Yao on 7/7/21.
//

#import "ProfileViewController.h"
#import "Post.h"
#import <Parse/Parse.h>
#import "profileCell.h"
#import "DetailsViewController.h"


@interface ProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) NSArray *postsArray;
@property (weak, nonatomic) IBOutlet PFImageView *profilePic;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getUser];
    [self fetchPosts];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self settheProfile];
        
    self.username.text = self.author.username;
    UITapGestureRecognizer *photoTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapPhoto:)];
    [self.profilePic addGestureRecognizer:photoTapGestureRecognizer];
    [self.profilePic setUserInteractionEnabled:YES];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 15;
    CGFloat itemWidth = (self.collectionView.frame.size.width/3)-15;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.collectionView insertSubview: self.refreshControl atIndex:0];
}
- (void) getUser{
    if (self.author == nil){
        self.author = [PFUser currentUser];
    }
}
- (void) settheProfile{
    self.profilePic.layer.cornerRadius = 40;
    self.profilePic.layer.masksToBounds = YES;
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" equalTo:self.author.objectId];
    PFUser *user = [query findObjects][0];
    self.profilePic.file = user[@"profilePic"];
    [self.profilePic loadInBackground];
    
}
- (void)fetchPosts{
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query whereKey:@"author" equalTo:self.author];
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.postsArray = posts;
            for (NSDictionary *post in posts){
                NSLog(@"%@", post[@"caption"]);
            }
            [self.collectionView reloadData];
            [self.refreshControl endRefreshing];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}
- (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
 
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}
- (void)sendProfile:(NSString *)objectID withImage:(PFFileObject *)image{
    PFQuery *query = [PFUser query];

    // Retrieve the object by id
    [query getObjectInBackgroundWithId:objectID
                                 block:^(PFObject *user, NSError *error) {
        if(error==nil){
            user[@"profilePic"] = image;
            NSLog(@"success");
            [user saveInBackground];
        }
        else{
            NSLog(@"%@", error.localizedDescription);
        }
    
    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    self.profilePic.image = editedImage;
    
    [self sendProfile:self.author.objectId withImage:[self getPFFileFromImage:[self resizeI:editedImage withSize:editedImage.size]]];
    
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void) didTapPhoto:(UITapGestureRecognizer *)sender{
    //TODO: Call method delegate
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    profileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"profileCell" forIndexPath:indexPath];
    cell.post = (Post *)self.postsArray[indexPath.row];
    [cell setPost:cell.post];
    return cell;
    
}
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.postsArray.count;
}
- (UIImage *)resizeI:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(300, 300, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"profDetailSegue"]){
        UICollectionViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
        Post *poster = (Post *)self.postsArray[indexPath.row];
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.post = poster;
    }
}


@end
