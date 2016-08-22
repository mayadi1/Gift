//
//  GVGift.h
//  Gifty Viewer
//
//  Created by Mohamed Ayadi on 13/08/16.
//  Copyright © 2016 Ayadi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Model object for the gifts.
// All instances are archived and unarchived in the Singleton GVGiftStore sharedStore

@interface GVGift : NSObject <NSCoding>

@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) NSString *imageUrlString;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSMutableArray *interests;
@property (nonatomic, assign) BOOL swiped;
@property (nonatomic, assign) BOOL saved;

- (instancetype)initWithUrlString:(NSString *)urlString imageUrlString:(NSString *)imageUrlString title:(NSString *)title price:(NSString *)price interests:(NSMutableArray *)interests uuid:(NSString *)uuid;


@end
