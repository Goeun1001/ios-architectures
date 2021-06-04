//
//  Beer.h
//  Objc-MVC
//
//  Created by GoEun Jeong on 2021/06/03.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Beer : NSObject

+ (Beer *) _id: (NSString*)_id name: (NSString*)name desc: (NSString*)desc imageURL: (NSString*)imageURL;

@property (nullable) NSString* _id;
@property (nullable) NSString* name;
@property (nullable) NSString* desc;
@property (nullable) NSString* imageURL;

@end

NS_ASSUME_NONNULL_END
