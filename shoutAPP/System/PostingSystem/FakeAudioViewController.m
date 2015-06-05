//
//  FakeAudioViewController.m
//  shoutAPP
//
//  Created by MAC01 on 6/5/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import "FakeAudioViewController.h"

@interface FakeAudioViewController ()

@end

@implementation FakeAudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnSelectA:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate didFinishPickingFakeAudioWithInfo:@"HelixMobileProducer_test1_MPEG2_Mono_CBR_40kbps_16000Hz"];
    }];
}

- (IBAction)btnBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
