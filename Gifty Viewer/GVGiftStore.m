//
//  GVGiftStore.m
//  Gifty Viewer
//
//  Created by Mohamed Ayadi on 13/08/16.
//  Copyright © 2016 Ayadi. All rights reserved.
//

#import "GVGiftStore.h"

@interface GVGiftStore ()

@property (nonatomic) NSMutableDictionary *giftsDictionary;

@end

@implementation GVGiftStore

+ (instancetype)sharedStore
{
    static dispatch_once_t once;
    static id sharedStore;
    
    dispatch_once(&once, ^{
                      sharedStore = [[self alloc] initPrivate];
    });
    return sharedStore;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        NSString *path = [self giftStoreArchivePath];
        _giftsDictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        _giftsDictionaryByInterest = [[NSMutableDictionary alloc] init];
        _giftsSaved = [[NSMutableArray alloc] init];
        _interests = [[NSMutableArray alloc] init];
        
        if (!_giftsDictionary) {
            _giftsDictionary = [[NSMutableDictionary alloc] init];
        }
    }
    return self;
}

- (NSString *)giftStoreArchivePath {
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"giftStore.archive"];
}

- (BOOL)saveChanges {
    NSString *path = [self giftStoreArchivePath];
    
    return [NSKeyedArchiver archiveRootObject:_giftsDictionary toFile:path];
}

- (void)setGift:(GVGift *)gift forKey:(NSString *)key {
    [_giftsDictionary setObject:gift forKey:key];
}

- (NSDictionary *)giftsDictionary {
    return _giftsDictionary;
}

- (int)storeVersion {
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"GiftStoreVersion"];
}

+ (GVGift *)loadGVGiftFromUUID:(NSString *)uuid {
    return [[[GVGiftStore sharedStore] giftsDictionary] objectForKey:uuid];
}

@end
