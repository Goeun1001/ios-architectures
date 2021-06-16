# Objc



![Objc](/Users/jge/Documents/dev/JGE-ios-architecture/Docs/images/Objc.png)



## Image Load

BeerTableViewCell.m

```
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
```



## CacheManager

CacheManager.h

```
@interface CacheManager : NSObject

+ (CacheManager*)sharedInstance;

// set
- (void)cacheImage:(UIImage*)image forKey:(NSString*)key;
// get
- (UIImage*)getCachedImageForKey:(NSString*)key;

@end
```



## Network

```
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
```



## [Example](https://github.com/Goeun1001/ios-architectures/tree/master/Objc-MVC)