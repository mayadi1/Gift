//
//  GVGiftStore.h
//  Gifty Viewer
//
//  Created by Mohamed Ayadi on 13/08/16.
//  Copyright © 2016 Ayadi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVGift.h"

// Singleton class. It stores every Gift retrieved from Firebase. If new gifts are added, with the help of Firebase Framework, the store is updated.

@interface GVGiftStore : NSObject

@property (nonatomic, readonly) NSDictionary *giftsDictionary;
@property (nonatomic, copy) NSMutableDictionary *giftsDictionaryByInterest;
@property (nonatomic, copy) NSMutableArray *interests;
@property (nonatomic, copy) NSMutableArray *giftsSaved;

+ (GVGiftStore *)sharedStore;
+ (GVGift *)loadGVGiftFromUUID:(NSString *)uuid;

- (void)setGift:(GVGift *)gift forKey:(NSString *)key;
- (NSString *)giftStoreArchivePath;
- (BOOL)saveChanges;
- (int)storeVersion;


@end
