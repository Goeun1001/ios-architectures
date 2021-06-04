//
//  SearchBeerVC.h
//  Objc-MVC
//
//  Created by GoEun Jeong on 2021/06/03.
//

#import <UIKit/UIKit.h>
#import "NetworkingAPI.h"
#import "CacheManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchBeerVC : UIViewController<UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@end

NS_ASSUME_NONNULL_END
