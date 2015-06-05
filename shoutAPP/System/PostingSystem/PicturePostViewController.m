//
//  PicturePostViewController.m
//  shoutAPP
//
//  Created by Miguel Garcia Topete on 5/31/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import "PicturePostViewController.h"

@interface PicturePostViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imgView;

- (IBAction)doTakePicture:(id)sender;
- (IBAction)doPictureFolder:(id)sender;

@property (strong, nonatomic) UIImagePickerController *picker;
@property (strong, nonatomic) UIImage *image;

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic) BOOL usingPopover;
@property (nonatomic, strong) UIPopoverController *popover;

@end

@implementation PicturePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%@",info);
    self.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    self.imgView.image = self.image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Actions

- (IBAction)doPictureFolder:(id)sender
{
    self.picker = [[UIImagePickerController alloc]init];
    self.picker.delegate = self;
    [self.picker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    [self presentViewController:self.picker animated:YES completion:NULL];
    
}

- (IBAction)doTakePicture:(id)sender
{
    NSLog(@"Camera Functions.");
    
    self.picker =[[UIImagePickerController alloc] init];
    self.picker.delegate = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self.picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        self.picker.allowsEditing = NO;
        [self presentViewController:self.picker animated:YES completion:NULL];
    } else {
        NSLog(@"No camera available");
    }
}

- (IBAction)doUseImage:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        // Pass image back
        [self.delegate didSelectImage:self.image];
    }];
}

- (IBAction)doCancelImage:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
