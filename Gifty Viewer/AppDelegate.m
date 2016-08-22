//
//  AppDelegate.m
//  Gifty Viewer
//
//  Created by Mohamed Ayadi on 13/08/16.
//  Copyright © 2016 Ayadi. All rights reserved.
//

#import "AppDelegate.h"
#import "GVGiftStore.h"
#import "GVGift.h"
#import <Firebase/Firebase.h>
#import <SDWebImage/UIImageView+WebCache.h>


@interface AppDelegate ()

- (void)updateStore;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self checkForUpdates];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    BOOL success = [[GVGiftStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"s-au salvat");
    }
    else {
        NSLog(@"nu s-au salvat");
    }
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [self checkForUpdates];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.

    BOOL success = [[GVGiftStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"s-au salvat");
    }
    else {
        NSLog(@"nu s-au salvat");
    }
}

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder {
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder {
    return YES;
}

// Checks the GiftStoreVersion (if the local GiftStoreVersion is different than the one from the Firebase, the database has to be updated)
- (void)checkForUpdates {
    
    __weak typeof(self) weakSelf = self;
    GVGiftStore *store = [GVGiftStore sharedStore];
    
    Firebase *firebaseRef = [[Firebase alloc] initWithUrl:@"https://giftyviewer.firebaseio.com/GiftStoreVersion"];
    [firebaseRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if ((int)snapshot.value != [store storeVersion]) {
            [[NSUserDefaults standardUserDefaults] setInteger:(int)snapshot.value forKey:@"GiftStoreVersion"];
            [weakSelf updateStore];
        } else {
            
            GVGiftStore *store = [GVGiftStore sharedStore];
            NSDictionary *dictionary = [store giftsDictionary];
            NSMutableDictionary *dictionaryByInterests = [store giftsDictionaryByInterest];
            NSMutableArray *interestsArray = [store interests];
            NSMutableArray *savedArray = [store giftsSaved];
            
            for (NSString *key in dictionary) {
                GVGift *gift = (GVGift *)[dictionary objectForKey:key];

                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                [manager downloadImageWithURL:[NSURL URLWithString:gift.imageUrlString]
                                      options:0
                                     progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                        
                                     }
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                        if (image) {

                                        }
                                    }];
                if (gift.saved == YES) {
                    [savedArray addObject:gift];
                }
                
                for (NSString *interest in gift.interests) {
                    if (![interestsArray containsObject:interest]) {
                        [interestsArray addObject:interest];
                    }
                    
                    if (![dictionaryByInterests objectForKey:interest]) {
                        NSMutableArray *array = [[NSMutableArray alloc] init];
                        [array addObject:gift.uuid];
                        [dictionaryByInterests setObject:array forKey:interest];
                    }
                    else {
                        NSMutableArray *array = [dictionaryByInterests objectForKey:interest];
                        [array addObject:gift.uuid];
                    }
                }
            }
        }
        [[GVGiftStore sharedStore] saveChanges];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"interestListUpdated" object:nil];
        [firebaseRef removeAllObservers];
    }];
}

// Download the data from the Firebase and store it with NSArchiving.
- (void)updateStore {
    GVGiftStore *store = [GVGiftStore sharedStore];

    Firebase *firebaseRef = [[Firebase alloc] initWithUrl:@"https://giftyviewer.firebaseio.com/GiftsList"];
    [firebaseRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
  
        NSDictionary *dictionary = (NSDictionary *)snapshot.value;
        for (NSString *key in dictionary) {
            GVGift *gift = [[GVGift alloc] init];
            gift.urlString = dictionary[key][@"urlString"];
            gift.imageUrlString = dictionary[key][@"imageUrlString"];
            gift.title = dictionary[key][@"title"];
            gift.price = dictionary[key][@"price"];
            gift.interests = dictionary[key][@"interests"];
            gift.uuid = dictionary[key][@"uuid"];
            
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadImageWithURL:[NSURL URLWithString:gift.imageUrlString]
                                  options:0
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                     // progression tracking code
                                 }
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                    if (image) {
                                        [[SDImageCache sharedImageCache] storeImage:image forKey:gift.imageUrlString];
                                        
                                }
                                }];
            
            NSMutableDictionary *dictionaryByInterests = [store giftsDictionaryByInterest];
            NSMutableArray *interestsArray = [store interests];

            for (NSString *interest in gift.interests) {
                if (![interestsArray containsObject:interest]) {
                    [interestsArray addObject:interest];
                }

                if (![dictionaryByInterests objectForKey:interest]) {
                    NSMutableArray *array = [[NSMutableArray alloc] init];
                    [array addObject:gift.uuid];
                    [dictionaryByInterests setObject:array forKey:interest];
                }
                else {
                    NSMutableArray *array = [dictionaryByInterests objectForKey:interest];
                    [array addObject:gift.uuid];
                }
            }
            NSMutableArray *savedArray = [store giftsSaved];
            if (![[store giftsDictionary] objectForKey:gift.uuid]) {
                gift.swiped = NO;
                if (gift.saved == YES) {
                    [savedArray addObject:gift];
                }
                [store setGift:gift forKey:gift.uuid];
            }
        }
        
        [[GVGiftStore sharedStore] saveChanges];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"interestListUpdated" object:nil];
    }];
}

@end
