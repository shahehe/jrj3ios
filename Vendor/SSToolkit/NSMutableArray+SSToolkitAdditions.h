/**
 Provides extensions to `NSMutableArray` for various common tasks.
 */
#import <UIKit/UIKit.h>
@interface NSMutableArray (SSToolkitAdditions)

///--------------------------
/// @name Changing the Array
///--------------------------

/**
 Shuffles the elements of this array in-place using the Fisher-Yates algorithm

 */
- (void)shuffle;

@end
