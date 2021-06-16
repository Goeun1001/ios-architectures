//
//  TableViewCell.m
//  Objc-MVC
//
//  Created by GoEun Jeong on 2021/06/03.
//

#import "BeerTableViewCell.h"

@implementation BeerTableViewCell

- (void) setupView: (Beer*) beer {
    NSLog(@"id: %@",[beer _id]);
    NSLog(@"name: %@",[beer name]);
    NSLog(@"desc: %@",[beer desc]);
    NSLog(@"image: %@",[beer imageURL]);
    
    [[self idLabel] setText: [NSString stringWithFormat:@"%@", [beer _id]]];
    [[self nameLabel] setText:[beer name]];
    [[self descLabel] setText:[beer desc]];
    
    if ([[beer imageURL] isKindOfClass:[NSString class]]) {
        UIImage *image = [[CacheManager sharedInstance] getCachedImageForKey: [beer imageURL]];
        
        if(image)
        {
            [[self beerImageView] setImage: image];
        } else {
            NSURL *imageURL = [NSURL URLWithString: [beer imageURL]];
            UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:imageURL]];
            
            [[CacheManager sharedInstance] cacheImage:image forKey: [beer imageURL]];
            [[self beerImageView] setImage: image];
        }
    } else {
        [[self beerImageView] setImage: nil];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
