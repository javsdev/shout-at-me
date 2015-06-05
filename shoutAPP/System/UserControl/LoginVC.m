//
//  LoginVC.m
//  shoutAPP
//
//  Created by Mac on 5/30/15.
//  Copyright (c) 2015 Miguel Garcia Topete. All rights reserved.
//

#import "LoginVC.h"
#import "GeoShoutApi.h"
#import "AppDelegate.h"
#import "RegisterVC.h"

@interface LoginVC () <UITextFieldDelegate, RegisterDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)btnLogin:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnLoginOut;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actIndicator;

@property (strong, nonatomic) RegisterVC *registerVC;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.txtUsername.delegate = self;
    self.txtPassword.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return true;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnLogin:(id)sender {
    self.txtUsername.enabled = false;
    self.txtPassword.enabled = false;
    self.btnLoginOut.enabled = false;
    [self.actIndicator startAnimating];
    
    Credentials * attempt = [Credentials new];
    attempt.cred_type = 1;//kCredentialUserNamePassword;
    attempt.cred_pass = [self.txtPassword text];
    
    [Users loginWithUserId:[self.txtUsername text] credentials:attempt onCompletion:^(RequestResult *result) {
        [self onLoginReturn:result];
    }];
}

-(void)onLoginReturn:(RequestResult*)result{
    if (result.success){
        //  we should reference display items after this
        GEO_LOGGED_USER = [(NSString*)[result.extra objectForKey:@"user_id"] integerValue];
        [UserLocation startStandarUpdates];
        [self dismissViewControllerAnimated:true completion:^{
            [((AppDelegate *)[[UIApplication sharedApplication]delegate]) refreshTabs];
        }];
    }
    else {
        self.txtUsername.enabled = true;
        self.txtPassword.enabled = true;
        self.btnLoginOut.enabled = true;
        [self.actIndicator stopAnimating];
        
        NSLog(@"Login Error: %@", result.msg);
    }
}

- (IBAction)btnRegister:(id)sender {
    self.registerVC = [[RegisterVC alloc] initWithNibName:@"RegisterVC" bundle:[NSBundle mainBundle]];
    
    self.registerVC.delegate = self;
    
    [self presentViewController:self.registerVC animated:YES completion:nil];
}

#pragma mark - user register delegate methods
-(void)didRegisterSuccessWithResult:(RequestResult *)result{
    [self onLoginReturn:result];
}

@end
