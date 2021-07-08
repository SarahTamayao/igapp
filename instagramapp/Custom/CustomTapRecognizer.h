//
//  CustomTapRecognizer.h
//  instagramapp
//
//  Created by Laura Yao on 7/8/21.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomTapRecognizer : UITapGestureRecognizer

@property (nonatomic, strong) PFUser *author;

@end

NS_ASSUME_NONNULL_END
