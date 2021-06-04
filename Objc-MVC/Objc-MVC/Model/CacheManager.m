//
//  CacheManager.m
//  Objc-MVC
//
//  Created by GoEun Jeong on 2021/06/04.
//

#import "CacheManager.h"

static CacheManager *sharedInstance;

@interface CacheManager ()
@property (nonatomic, strong) NSCache *imageCache;
@end

@implementation CacheManager

+ (CacheManager*)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CacheManager alloc] init];
    });
    return sharedInstance;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.imageCache = [[NSCache alloc] init];
    }
    return self;
}

- (void)cacheImage:(UIImage*)image forKey:(NSString*)key {
    [self.imageCache setObject:image forKey:key];
}

- (UIImage*)getCachedImageForKey:(NSString*)key {
    return [self.imageCache objectForKey:key];
}

@end
