//
//  TableViewCell.h
//  Objc-MVC
//
//  Created by GoEun Jeong on 2021/06/03.
//

#import <UIKit/UIKit.h>
#import "Beer.h"
#import "CacheManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface BeerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *beerImageView;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

- (void) setupView: (Beer*) beer;

@end

NS_ASSUME_NONNULL_END
