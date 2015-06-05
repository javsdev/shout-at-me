//
//  FakeVideoViewController.m
//  shoutAPP
//
//  Created by MAC01 on 6/4/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import "FakeVideoViewController.h"

@interface FakeVideoViewController ()

@property NSArray *urlVideos;

@end

@implementation FakeVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.urlVideos = @[@"sample_iTunes", @"sample_iTunes", @"sample_iTunes", @"sample_iTunes", @"sample_iTunes", @"sample_iTunes"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnSelectRandomVideo:(id)sender {
    int index = arc4random() % self.urlVideos.count;
    NSString *name = self.urlVideos[index];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *url = [bundle pathForResource:name ofType:@"mov"];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate didFinishPickingFakeMediaWithInfo:url];
    }];
}

- (IBAction)btnCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
