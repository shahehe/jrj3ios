
#import "NSMutableArray+SSToolkitAdditions.h"

@implementation NSMutableArray (SSToolkitAdditions)

- (void)shuffle
{
    for (NSUInteger i = [self count] - 1; i > 0; i--) {
        int count = (int)(i + 1);
        [self exchangeObjectAtIndex:arc4random_uniform(count)
                  withObjectAtIndex:i];
    }
}

@end
