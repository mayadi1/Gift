//
//  GVWelcomeViewController.m
//  Gifty Viewer
//
//  Created by Mohamed Ayadi on 13/08/16.
//  Copyright © 2016 Ayadi. All rights reserved.
//

#import "GVWelcomeViewController.h"


@interface GVWelcomeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *getStartedButton;

@end

@implementation GVWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.getStartedButton addTarget:self action:@selector(getStartedButtonPressed) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getStartedButtonPressed {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
