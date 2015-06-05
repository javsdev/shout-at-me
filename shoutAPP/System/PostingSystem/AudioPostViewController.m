//
//  AudioPostViewController.m
//  shoutAPP
//
//  Created by MAC01 on 6/4/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AudioPostViewController.h"
#import "FakeAudioViewController.h"

@interface AudioPostViewController ()<FakeAudioDelegate>

@property (weak, nonatomic) IBOutlet UITableView *pictureSourceTableView;

@property UIImagePickerController *picker;

@property (nonatomic, strong) NSString *audioUrl;

@property (nonatomic, strong) AVPlayerLayer *myPlayerLayer;
@property (nonatomic, strong) AVPlayer *myavp;
@property (weak, nonatomic) IBOutlet UILabel *lblAudioFile;

@end

@implementation AudioPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
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

-(void)playAudioWithString:(NSString *)urlStr {
    NSURL *url = [[NSBundle mainBundle] URLForResource:urlStr withExtension:@"mp3"];
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
    self.myavp = [AVPlayer playerWithPlayerItem:playerItem];
    self.myPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.myavp];
    self.myPlayerLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size
                                          .height);
    [self.view.layer addSublayer:self.myPlayerLayer];
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

-(void)showFileSystemPicker{
    /*NSLog(@"PhotoLibrary Functions.");
    self.picker = [[UIImagePickerController alloc]init];
    self.picker.delegate = self;
    [self.picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    self.picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    [self presentViewController:self.picker animated:YES completion:NULL];*/
}

#pragma mark - Action methods
- (IBAction)doAudioFolder:(id)sender
{
    self.audioUrl = @"";
    [self.myavp pause];
    
    // TODO: For production
    //[self showFileSystemPicker];
    
    // TODO: For testing without device
    [self showFakeFileSystemPicker];
}

- (IBAction)doTakeAudio:(id)sender
{
    /*self.videoUrl = @"";
    [self.player stop];
    
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.delegate = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self.picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        self.picker.allowsEditing = NO;
        self.picker.showsCameraControls = NO;
        self.picker.cameraViewTransform = CGAffineTransformIdentity;
        
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear])
        self.picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        else
        self.picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        
        [self presentViewController:self.picker animated:YES completion:NULL];
        
        [self.picker startVideoCapture];
    } else {
        NSLog(@"Not device available");
    }*/
}

- (IBAction)btnPlay:(id)sender {
    [self.myavp play];
}

- (IBAction)btnStop:(id)sender {
    [self.myavp pause];
}

- (IBAction)btnBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnUse:(id)sender {
    [self.myavp pause];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate didSelectAudio:self.audioUrl];
    }];
}

#pragma mark - Image picker delegate methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    /*NSLog(@"%@",info);
    
    NSURL *videoURL = [info valueForKey:UIImagePickerControllerMediaURL];
    NSString *pathToVideo = [videoURL path];
    BOOL okToSaveVideo = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(pathToVideo);
    if (okToSaveVideo) {
        UISaveVideoAtPathToSavedPhotosAlbum(pathToVideo, self, nil, NULL);
        
        [self showVideoWithURL:[NSURL URLWithString:pathToVideo]];
        
        self.videoUrl = pathToVideo;
    } else {
        //[self video:pathToVideo didFinishSavingWithError:nil contextInfo:NULL];
    }*/
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Fake Video Picker Methods
-(void)showFakeFileSystemPicker{
    FakeAudioViewController *pickerView = [[FakeAudioViewController alloc] initWithNibName:@"FakeAudioViewController" bundle:[NSBundle mainBundle]];
    pickerView.delegate = self;
    
    [self presentViewController:pickerView animated:YES completion:nil];
}

-(void)fakeAudioPickerControllerDidCancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didFinishPickingFakeAudioWithInfo:(NSString *)info{
    self.lblAudioFile.text = info;
    
    self.audioUrl = info;
    
    [self playAudioWithString:self.audioUrl];
}

@end
