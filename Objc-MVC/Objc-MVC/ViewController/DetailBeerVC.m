//
//  DetailBeerVC.m
//  Objc-MVC
//
//  Created by GoEun Jeong on 2021/06/03.
//

#import "DetailBeerVC.h"

@interface DetailBeerVC ()

@property (weak, nonatomic) IBOutlet UIImageView *beerImageView;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation DetailBeerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void) setupView {
    [[self idLabel] setText: [NSString stringWithFormat:@"%@", [self.beer _id]]];
    [[self nameLabel] setText:[self.beer name]];
    [[self descLabel] setText:[self.beer desc]];
    
    if ([[self.beer imageURL] isKindOfClass:[NSString class]]) {
        UIImage *image = [[CacheManager sharedInstance] getCachedImageForKey: [self.beer imageURL]];
        
        if(image)
        {
            [[self beerImageView] setImage: image];
        } else {
            NSURL *imageURL = [NSURL URLWithString: [self.beer imageURL]];
            UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:imageURL]];
            
            [[CacheManager sharedInstance] cacheImage:image forKey: [self.beer imageURL]];
            [[self beerImageView] setImage: image];
        }
    } else {
        [[self beerImageView] setImage: nil];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
