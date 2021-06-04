//
//  BeerListVC.h
//  Objc-MVC
//
//  Created by GoEun Jeong on 2021/06/03.
//

#import <UIKit/UIKit.h>
#import "NetworkingAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface BeerListVC : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property int page;

@end

NS_ASSUME_NONNULL_END
