//
//  NetworkingAPI.h
//  Objc-MVC
//
//  Created by GoEun Jeong on 2021/06/03.
//

#import <Foundation/Foundation.h>
#import "Beer.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetworkingAPI : NSObject

- (NSMutableArray *) getBeerList: (int)page;
- (NSMutableArray *) searchBeer: (int)_id;
- (NSMutableArray *) getRandomBeer;

@end

NS_ASSUME_NONNULL_END
