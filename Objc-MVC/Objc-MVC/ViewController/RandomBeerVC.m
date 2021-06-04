//
//  RandomBeerVC.m
//  Objc-MVC
//
//  Created by GoEun Jeong on 2021/06/03.
//

#import "RandomBeerVC.h"

@interface RandomBeerVC ()

{
    NSMutableArray *beer;
    NetworkingAPI *networkingApi;
}

@property (weak, nonatomic) IBOutlet UIImageView *beerImageView;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)rarndomButtonClicked:(id)sender;

@end

@implementation RandomBeerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    beer = [[NSMutableArray alloc] init];
    networkingApi = [[NetworkingAPI alloc] init];
    
    [self getData];
    
    // Do any additional setup after loading the view.
}

- (void) getData {
    [_activityIndicator startAnimating];
    beer = [networkingApi getRandomBeer];
    [self setupView:[beer firstObject]];
    [_activityIndicator stopAnimating];
}

- (void) setupView: (Beer*) beer {
    NSLog(@"id: %@",[beer _id]);
    NSLog(@"imageURL: %@",[beer imageURL]);
    
    [[self idLabel] setText: [NSString stringWithFormat:@"%@", [beer _id]]];
    [[self nameLabel] setText:[beer name]];
    [[self descLabel] setText:[beer desc]];
    
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
}

- (IBAction)rarndomButtonClicked:(id)sender {
    [self getData];
}
@end
