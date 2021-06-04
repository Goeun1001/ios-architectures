//
//  NetworkingAPI.m
//  Objc-MVC
//
//  Created by GoEun Jeong on 2021/06/03.
//

#import "NetworkingAPI.h"

@implementation NetworkingAPI
{
    NSMutableArray *beers;
}

- (id) init {
    self = [super init];
    beers = [[NSMutableArray alloc] init];
    return self;
}

- (NSMutableArray *) getBeerList: (int)page {
    
    NSString* baseUrl = @"https://api.punkapi.com/v2/beers?per_page=25&page=";
    NSString* _page = [NSString stringWithFormat:@"%d", page];
    NSString *url = [NSString stringWithFormat: @"%@%@", baseUrl, _page];
    
    NSData *jsonSource = [NSData dataWithContentsOfURL:
                          [NSURL URLWithString: url]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:
                      jsonSource options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *dataDict in jsonObjects) {
        NSString *_id = [dataDict objectForKey:@"id"];
        NSString *name = [dataDict objectForKey:@"name"];
        NSString *description = [dataDict objectForKey:@"description"];
        NSString *imageURL = [dataDict objectForKey:@"image_url"];
        
        NSLog(@"id: %@",_id);
        
        [beers addObject:[Beer _id:_id name:name desc:description imageURL:imageURL]];
    }
    return beers;
}

- (NSMutableArray *) searchBeer: (int)_id {
    beers = [[NSMutableArray alloc] init];
    NSString* baseUrl = @"https://api.punkapi.com/v2/beers?ids=";
    NSString* _url = [NSString stringWithFormat:@"%d", _id];
    NSString* url = [NSString stringWithFormat: @"%@%@", baseUrl, _url];
    
    NSData *jsonSource = [NSData dataWithContentsOfURL:
                          [NSURL URLWithString: url]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:
                      jsonSource options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *dataDict in jsonObjects) {
        NSString *_id = [dataDict objectForKey:@"id"];
        NSString *name = [dataDict objectForKey:@"name"];
        NSString *description = [dataDict objectForKey:@"description"];
        NSString *imageURL = [dataDict objectForKey:@"image_url"];
        
        NSLog(@"id: %@",_id);
        
        [beers addObject:[Beer _id:_id name:name desc:description imageURL:imageURL]];
    }
    return beers;
}

- (NSMutableArray *) getRandomBeer {
    beers = [[NSMutableArray alloc] init];
    NSString* baseUrl = @"https://api.punkapi.com/v2/beers/random";
    NSString *url = [NSString stringWithFormat: @"%@", baseUrl];
    
    NSData *jsonSource = [NSData dataWithContentsOfURL:
                          [NSURL URLWithString: url]];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:
                      jsonSource options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *dataDict in jsonObjects) {
        NSString *_id = [dataDict objectForKey:@"id"];
        NSString *name = [dataDict objectForKey:@"name"];
        NSString *description = [dataDict objectForKey:@"description"];
        NSString *imageURL = [dataDict objectForKey:@"image_url"];
        
        NSLog(@"id: %@",_id);
        
        [beers addObject:[Beer _id:_id name:name desc:description imageURL:imageURL]];
    }
    return beers;
}

@end
