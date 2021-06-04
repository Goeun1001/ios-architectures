//
//  CacheManager.h
//  Objc-MVC
//
//  Created by GoEun Jeong on 2021/06/04.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CacheManager : NSObject

+ (CacheManager*)sharedInstance;

// set
- (void)cacheImage:(UIImage*)image forKey:(NSString*)key;
// get
- (UIImage*)getCachedImageForKey:(NSString*)key;

@end

NS_ASSUME_NONNULL_END
