//
//  FeedViewController.h
//  instagramapp
//
//  Created by Laura Yao on 7/6/21.
//

#import <UIKit/UIKit.h>
#import "InfiniteScrollActivityView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedViewController : UIViewController
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (nonatomic,strong) InfiniteScrollActivityView* loadingMoreView;

@end

NS_ASSUME_NONNULL_END
