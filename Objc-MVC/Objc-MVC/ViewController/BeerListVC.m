//
//  BeerListVC.m
//  Objc-MVC
//
//  Created by GoEun Jeong on 2021/06/03.
//

#import "BeerListVC.h"
#import "BeerTableViewCell.h"

@interface BeerListVC ()

{
    NSMutableArray *beers;
    NetworkingAPI *networkingApi;
    UIRefreshControl *refreshControl;
}

@property (weak, nonatomic) IBOutlet UITableView *beerTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation BeerListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    beers = [[NSMutableArray alloc] init];
    networkingApi = [[NetworkingAPI alloc] init];
    
    [self setPage: 1];
    [self registerXib];
    [self setupRefreshControl];
    [self getData];
    // Do any additional setup after loading the view.
}

- (void) registerXib {
    [self.beerTableView registerNib:[UINib nibWithNibName:@"BeerTableViewCell" bundle:nil]
       forCellReuseIdentifier:@"BeerTableViewCell"];
    [self.beerTableView setRowHeight:114];
}

- (void)setupRefreshControl {
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [_beerTableView addSubview:refreshControl];
}

- (void)handleRefresh:(UIRefreshControl *)sender {
    [self setPage:1];
    [self getData];
    [_beerTableView reloadData];
    [refreshControl endRefreshing];
}

- (void) getData {
    [_activityIndicator startAnimating];
    beers = [networkingApi getBeerList:[self page]];
    [_beerTableView reloadData];
    [_activityIndicator stopAnimating];
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
 }
 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return beers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BeerTableViewCell* cell = nil;
    
    cell = (BeerTableViewCell* )[tableView dequeueReusableCellWithIdentifier:@"BeerTableViewCell"];
    
    if (cell == nil) {
        cell = [[BeerTableViewCell alloc]initWithStyle:
        UITableViewCellStyleSubtitle reuseIdentifier:@"BeerTableViewCell"];
    }
    
    Beer *beer = [beers objectAtIndex:indexPath.row];
    
    [cell setupView:[Beer _id:[beer _id] name: [beer name] desc: [beer desc] imageURL: [beer imageURL]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailBeerVC* vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailBeerVC"];
    printf("%s", vc);
    vc.beer = [beers objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
//    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailBeerVC") as! DetailBeerVC
//    vc.beer = beers[indexPath.row]
//    self.navigationController?.pushViewController(vc, animated: true)
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= 1800 * [self page]) {
        [self setPage:[self page] + 1];
        [self getData];
        [_beerTableView reloadData];
    }
}

@end
