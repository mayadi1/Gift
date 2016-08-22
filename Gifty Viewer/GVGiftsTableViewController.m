//
//  GVGiftsTableViewController.m
//  Gifty Viewer
//
//  Created by Mohamed Ayadi on 13/08/16.
//  Copyright © 2016 Ayadi. All rights reserved.
//

#import "GVGiftsTableViewController.h"
#import "GVGiftTableViewCell.h"
#import "GVBuyGiftViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "GVGift.h"
#import "GVGiftStore.h"
#import "UIImage+GVGiftlyViewer.h"

@interface GVGiftsTableViewController ()<UITableViewDelegate, UITableViewDataSource, GVGiftTableViewCellDelegate>

@end

NSIndexPath *indexPathPressed;

@implementation GVGiftsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.giftsTableView.contentInset = UIEdgeInsetsMake(-1.0f, 0.0f, 0.0f, 0.0);
    [self.giftsTableView setTableFooterView:[UIView new]];
    
    self.giftsTableView.delegate = self;
    self.giftsTableView.dataSource = self;
    
    [self.giftsTableView registerNib:[UINib nibWithNibName:@"GVGiftTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"GiftCell"];
    
    [self.giftsTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.giftsTableView setSeparatorColor:[UIColor darkGrayColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)giftsButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[GVGiftStore sharedStore] giftsSaved] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GVGiftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GiftCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.thumbnailImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    GVGift *gift = [[GVGiftStore sharedStore] giftsSaved][indexPath.row];
    cell.titleLabel.text = gift.title;
    cell.priceLabel.text = gift.price;
    
    SDWebImageManager *imageManager = [SDWebImageManager sharedManager];
    [imageManager downloadImageWithURL:[NSURL URLWithString:gift.imageUrlString] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        cell.thumbnailImageView.image = image;
    }];
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell.selectionStyle == UITableViewCellSelectionStyleNone){
        return nil;
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (void)didPressBuyAtIndexPath:(NSIndexPath *)indexPath {
    indexPathPressed = indexPath;
    [self performSegueWithIdentifier:@"showSegueBuy" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showSegueBuy"]) {

        GVBuyGiftViewController *vc = (GVBuyGiftViewController *)[segue destinationViewController];

        GVGift *gift = [[GVGiftStore sharedStore] giftsSaved][indexPathPressed.row];
        vc.giftToPresent = gift;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        GVGift *gift = (GVGift *)[[[GVGiftStore sharedStore] giftsSaved] objectAtIndex:indexPath.row];
        gift.saved = NO;
        [[GVGiftStore sharedStore] saveChanges];
        
        [[[GVGiftStore sharedStore] giftsSaved] removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    }
}

@end
