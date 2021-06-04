//
//  SearchBeerVC.m
//  Objc-MVC
//
//  Created by GoEun Jeong on 2021/06/03.
//

#import "SearchBeerVC.h"

@interface SearchBeerVC ()
{
    NSMutableArray *beer;
    NetworkingAPI *networkingApi;
}
@property (weak, nonatomic) IBOutlet UIImageView *beerImageView;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation SearchBeerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    networkingApi = [[NetworkingAPI alloc] init];
    
    [self setUpSearchVC];
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
}

- (void) setUpSearchVC {
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.searchResultsUpdater = self;
    searchController.searchBar.keyboardType = UIKeyboardTypeNumberPad;
    self.navigationItem.searchController = searchController;
    //    self.definesPresentationContext = YES;
    //    self.searchController = UISearchController(searchResultsController:  nil)
    //
    //           self.searchController.searchResultsUpdater = self
    //           self.searchController.delegate = self
    //           self.searchController.searchBar.delegate = self
    //
    //           self.searchController.hidesNavigationBarDuringPresentation = false
    //           self.searchController.dimsBackgroundDuringPresentation = true
    //
    //           self.navigationItem.titleView = searchController.searchBar
    //
    //           self.definesPresentationContext = true
}

- (void) searchData: (int) _id {
    [_activityIndicator startAnimating];
    beer = [networkingApi searchBeer:_id];
    [self setupView:[beer firstObject]];
    [_activityIndicator stopAnimating];
}

- (void) setupView: (Beer*) beer {
    NSLog(@"id: %@",[beer _id]);
    NSLog(@"name: %@",[beer name]);
    
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

//updateSearchResultsForSearchController

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = searchController.searchBar.text;
    if (searchText != nil && searchText.length != 0) {
        [self searchData:[searchText intValue]];
    }
}


@end
