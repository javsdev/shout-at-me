//
//  PicturePostViewController.m
//  shoutAPP
//
//  Created by Miguel Garcia Topete on 5/31/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import "PicturePostViewController.h"

@interface PicturePostViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *pictureSourceTableView;

@end

UIImagePickerController *picker;
UIImage *image;

@implementation PicturePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.imgView = [[UIImageView alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%@",info);
    image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    self.imgView.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];

    CGFloat pickerViewYpositionHidden = self.view.frame.size.height + self.pictureSourceTableView.frame.size.height;
    
    [UIView animateWithDuration:0.5f
                     animations:^{
                         [self.pictureSourceTableView setFrame:CGRectMake(self.pictureSourceTableView.frame.origin.x,
                                                                          pickerViewYpositionHidden,
                                                                          self.pictureSourceTableView.frame.size.width,
                                                                          self.pictureSourceTableView.frame.size.height)];
                     }
                     completion:nil];
    
    
}

-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doPictureFolder:(id)sender
{
    picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    [picker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    [self presentViewController:picker animated:YES completion:NULL];

}

- (IBAction)doUseAction:(UIButton *)sender {
}

- (IBAction)doCancelAction:(UIButton *)sender {
}

#pragma mark Custom Methods

-(void) createDatePickerAndShow
{
    [self.pictureSourceTableView setHidden:NO];
    CGFloat pickerViewYpositionHidden = self.view.frame.size.height + self.pictureSourceTableView.frame.size.height;
    CGFloat pickerViewYposition = self.view.frame.size.height - self.pictureSourceTableView.frame.size.height;
    NSLog(@"pickerViewPositionHidden:%.2f",pickerViewYpositionHidden);
    NSLog(@"pickerViewPosition:%.2f",pickerViewYposition);
    [self.pictureSourceTableView setFrame:CGRectMake(self.pictureSourceTableView.frame.origin.x,
                                                     pickerViewYpositionHidden,
                                                     self.pictureSourceTableView.frame.size.width,
                                                     self.pictureSourceTableView.frame.size.height)];
    
    [UIView animateWithDuration:0.5f
                     animations:^{
                         [self.pictureSourceTableView setFrame:CGRectMake(self.pictureSourceTableView.frame.origin.x,
                                                                          pickerViewYposition,
                                                                          self.pictureSourceTableView.frame.size.width,
                                                                          self.pictureSourceTableView.frame.size.height)];
                     }
                     completion:nil];
}


- (IBAction)doTakePicture:(id)sender
{
    NSLog(@"Camera Functions.");
    
    picker =[[UIImagePickerController alloc] init];
    picker.delegate = self;
    [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    picker.allowsEditing = NO;
    [self presentViewController:picker animated:YES completion:NULL];

}

- (IBAction)doUseImage:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        // Pass image back
        [self.delegate didSelectImage:image];
    }];
}

- (IBAction)doCancelImage:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
