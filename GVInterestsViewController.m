//
//  GVInterestsViewController.m
//  Gifty Viewer
//
//  Created by Mohamed Ayadi on 13/08/16.
//  Copyright © 2016 Ayadi. All rights reserved.
//

#import "GVInterestsViewController.h"

#import "GVInterestsCollectionViewCell.h"
#import "GVCollectionViewFlowLayout.h"
#import "GVSwipeGiftsViewController.h"
#import "GVGift.h"
#import "GVGiftStore.h"

@interface GVInterestsViewController()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) int numberOfInterestsSelected;
@property (weak, nonatomic) IBOutlet UILabel *counterLabel; // "You have selected..." label.
@property (copy, nonatomic) NSMutableArray *interestsSelected;

@end

@implementation GVInterestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidesWhenStopped = YES;
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"FirstLaunch"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstLaunch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController performSegueWithIdentifier:@"StartSegue" sender:self];
    }
    self.navigationController.navigationBarHidden = YES;
    
    self.interestsCollectionView.delegate = self;
    self.interestsCollectionView.dataSource = self;
    
    [self.interestsCollectionView registerNib:[UINib nibWithNibName:@"GVInterestsCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"tagCell"];

    
    _interestsSelected = [[NSMutableArray alloc] init];
    _numberOfInterestsSelected = 0;
    
    self.interestsList = [[GVGiftStore sharedStore] interests];
    
    [self.interestsCollectionView setAllowsMultipleSelection:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshInterests:) name:@"interestListUpdated" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.interestsList.count;
}

#pragma mark UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GVInterestsCollectionViewCell *cell = (GVInterestsCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"tagCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor orangeColor];
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    cell.layer.cornerRadius = 10;
    cell.layer.masksToBounds = NO;
    cell.interestLabel.text = [self.interestsList objectAtIndex:indexPath.row];
    
    if ([self.interestsSelected containsObject:cell.interestLabel.text]) {
        cell.selected = YES;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GVInterestsCollectionViewCell *cell = (GVInterestsCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self.interestsSelected addObject:cell.interestLabel.text];
    
    self.numberOfInterestsSelected++;
    [self updateCounter];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    GVInterestsCollectionViewCell *cell = (GVInterestsCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self.interestsSelected removeObject:cell.interestLabel.text];
    
    self.numberOfInterestsSelected--;
    [self updateCounter];
}

#pragma mark UICollectionViewFlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [[self.interestsList objectAtIndex:indexPath.row] sizeWithAttributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:30]}];
}

#pragma mark Custom functions

- (void)updateCounter {
    [self.counterLabel setText:[NSString stringWithFormat:@"You have selected %i interests.",self.numberOfInterestsSelected]];
}

#pragma mark - Navigation
 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    GVSwipeGiftsViewController *vc = (GVSwipeGiftsViewController *)[segue destinationViewController];
    vc.interestsSelected = self.interestsSelected;
}


- (void)refreshInterests:(NSNotification *)notification {
    self.interestsList = [[GVGiftStore sharedStore] interests];
    [self.activityIndicator stopAnimating];
    [self.interestsCollectionView reloadData];
}

@end
