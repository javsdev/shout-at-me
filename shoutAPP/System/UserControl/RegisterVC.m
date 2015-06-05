//
//  RegisterVC.m
//  shoutAPP
//
//  Created by MAC01 on 6/1/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import "RegisterVC.h"
#import "GeoShoutApi.h"

@interface RegisterVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIDatePicker *birthDatePicker;
@property (weak, nonatomic) IBOutlet UITextField *tfDisplayName;
@property (weak, nonatomic) IBOutlet UITextField *tfProfileName;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfRepeatPassword;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Only date needed in the date picker
    self.birthDatePicker.datePickerMode = UIDatePickerModeDate;
    // Set current date as maximum date that can be choosed
    [self.birthDatePicker setMaximumDate:[NSDate date]];
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

#pragma mark - TextField delegate methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return true;
}

#pragma mark - Actions for buttons
- (IBAction)btnRegister:(id)sender {
    self.tfDisplayName.enabled = false;
    self.tfPassword.enabled = false;
    self.tfProfileName.enabled = false;
    self.tfRepeatPassword.enabled = false;
    self.birthDatePicker.enabled = false;
    
    if ([self validatePasswordsWithFirst:self.tfPassword.text withConfirm:self.tfRepeatPassword.text]) {
        
        [self.activityIndicator startAnimating];
        
        Profile *profile = [Profile new];
        profile.profileName = self.tfProfileName.text;
        profile.displayName = self.tfProfileName.text;
        // TODO: Put a more reasonable status :P
        profile.displayStatus = @"working on final project :P";
        profile.DOB = self.birthDatePicker.date;
        
        Credentials *credentials = [Credentials new];
        credentials.cred_user = self.tfProfileName.text;
        credentials.cred_pass = self.tfPassword.text;
        credentials.cred_type = 1;
        
        [Users createUserWithProfile:profile credentials:credentials onCompletion:^(RequestResult *result) {
            [self onRegisterReturn:result];
        }];
        
    } else {
        NSLog(@"Different passwords");
    }
}

-(BOOL)validatePasswordsWithFirst:(NSString *)firstPassword withConfirm:(NSString *) confirmPassword {
    if ([firstPassword isEqualToString:confirmPassword]) {
        return YES;
    }
    
    return NO;
}

-(void)onRegisterReturn:(RequestResult *) result {
    if (result.success) {
        [self dismissViewControllerAnimated:YES completion:^{
            [self.delegate didRegisterSuccessWithResult:result];
        }];
    } else {
        self.tfDisplayName.enabled = true;
        self.tfPassword.enabled = true;
        self.tfProfileName.enabled = true;
        self.tfRepeatPassword.enabled = true;
        self.birthDatePicker.enabled = true;
        
        NSLog(@"Register Error: %@", result.msg);
    }
    
    [self.activityIndicator stopAnimating];
}

- (IBAction)btnLogin:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
