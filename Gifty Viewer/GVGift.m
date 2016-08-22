//
//  GVGift.m
//  Gifty Viewer
//
//  Created by Mohamed Ayadi on 13/08/16.
//  Copyright © 2016 Ayadi. All rights reserved.
//

#import "GVGift.h"

@interface GVGift()

@end

@implementation GVGift

- (instancetype)initWithUrlString:(NSString *)urlString imageUrlString:(NSString *)imageUrlString title:(NSString *)title price:(NSString *)price interests:(NSMutableArray *)interests uuid:(NSString *)uuid{
    self = [super init];
    if (self) {
        _urlString =urlString;
        _imageUrlString = imageUrlString;
        _title = title;
        _price = price;
        _interests = interests;
        _uuid = uuid;
        _swiped = NO;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _urlString = [aDecoder decodeObjectForKey:@"urlString"];
        _imageUrlString = [aDecoder decodeObjectForKey:@"imageUrlString"];
        _title = [aDecoder decodeObjectForKey:@"title"];
        _price = [aDecoder decodeObjectForKey:@"price"];
        _interests = [aDecoder decodeObjectForKey:@"interests"];
        _uuid = [aDecoder decodeObjectForKey:@"uuid"];
        _swiped = [aDecoder decodeBoolForKey:@"swiped"];
        _saved = [aDecoder decodeBoolForKey:@"saved"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.urlString forKey:@"urlString"];
    [aCoder encodeObject:self.imageUrlString forKey:@"imageUrlString"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.price forKey:@"price"];
    [aCoder encodeObject:self.interests forKey:@"interests"];
    [aCoder encodeObject:self.uuid forKey:@"uuid"];
    [aCoder encodeBool:self.swiped forKey:@"swiped"];
    [aCoder encodeBool:self.saved forKey:@"saved"];
}

@end
