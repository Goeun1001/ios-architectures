//
//  Beer.m
//  Objc-MVC
//
//  Created by GoEun Jeong on 2021/06/03.
//

#import "Beer.h"

@implementation Beer

+ (Beer *) _id: (NSString* )_id name: (NSString*)name desc: (NSString*)desc imageURL: (NSString*)imageURL {
    Beer* result = [[Beer alloc] init];
    result._id = _id;
    result.name = name;
    result.desc = desc;
    result.imageURL = imageURL;
    
    return result;
}

@end
