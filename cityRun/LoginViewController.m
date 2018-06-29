//
//  LoginViewController.m
//  cityRun
//
//  Created by Basir Alam on 26/03/17.
//  Copyright © 2017 Basir. All rights reserved.
//

#import "LoginViewController.h"
#import "ACFloatingTextField.h"
#import "SignupViewController.h"
#import "StoreOwnerOrderViewController.h"
@interface LoginViewController ()<ProcessDataDelegate>
{
    __weak IBOutlet NSLayoutConstraint *logoHeghtLayout;
    IBOutlet NSLayoutConstraint *logoWeightLayout;
    IBOutlet ACFloatingTextField *txtEmail;
    IBOutlet ACFloatingTextField *txtPassword;
    
    //    Create object of DataFetch
    DataFetch *_dataFetch;
    IBOutlet NSLayoutConstraint *textFieldWidthLayout;

}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"Login";
    //[self setBackgroundImage];
    [self setConstantsAndFonts]; //setConstantsAndFonts
    [self navigationColorSet];
    _dataFetch = [[DataFetch alloc]init];
    _dataFetch.delegate = self;


}

#pragma mark - Set Constants And Fonts

-(void)setConstantsAndFonts{
    if (IS_IPAD) {
        logoHeghtLayout.constant = 140;
        logoWeightLayout.constant = 140;
        textFieldWidthLayout.constant = 600.0f;

     }else if(IS_IPHONE_6P){
        logoHeghtLayout.constant = 110;
        logoWeightLayout.constant = 110;
         textFieldWidthLayout.constant = 315.0f;
        
    }else if(IS_IPHONE_6){
        logoHeghtLayout.constant = 110;
        logoWeightLayout.constant = 110;
        textFieldWidthLayout.constant = 300.0f;
        
    }else if (IS_IPHONE_5){
        logoHeghtLayout.constant = 90;
        logoWeightLayout.constant = 90;
        textFieldWidthLayout.constant = 280.0f;

    }else if (IS_IPHONE_X){
        
        NSLog(@"iPhone X");
        
    }else{
        logoHeghtLayout.constant = 70;
        logoWeightLayout.constant = 70;
        textFieldWidthLayout.constant = 260.0f;

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark NavigationColor Set

-(void)navigationColorSet{
    
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:122/255.0 green:175/255.0 blue:72/255.0 alpha:1.0];
}

#pragma mark  UITextfield Delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    //[self.view setFrame:CGRectMake(0,-120,self.view.frame.size.width,self.view.frame.size.height)];
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    //[self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}




#pragma mark - Login Action

- (IBAction)btnLoginAction:(id)sender {
    
    if (txtEmail.text.length > 0 && txtPassword.text.length > 0 ) {
        if ([self validateEmailWithString:txtEmail.text]) {
            NSLog(@"%@",[self validateEmailWithString:txtEmail.text]? @"Yes" : @"No");
            [self sendLoginData];
            
        }else{
            NSLog(@"%@",[self validateEmailWithString:txtEmail.text]? @"Yes" : @"No");
            [self setAlertMessage:@"Error!" :@"Please enter valid email address and password."];

        }

    }else{
        [self setAlertMessage:@"Empty Fields!" :@"Please enter email address and password."];
    }
}

#pragma mark - Signup Action

- (IBAction)btnSignupAction:(id)sender {
    SignupViewController *signupVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SignupViewController"];
    [self.navigationController pushViewController:signupVC animated:YES];
}

#pragma mark - Forgot Password Action

- (IBAction)BtnForgotAction:(id)sender {
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Forget Password"
                                message:@"Please enter your email-id to get your password"
                                preferredStyle:UIAlertControllerStyleAlert];
    
    
    [alert addTextFieldWithConfigurationHandler:nil];
    
    [alert addAction: [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *textField = alert.textFields[0];
        textField.placeholder = @"Email-id";
        textField.textAlignment = NSTextAlignmentCenter;
        
        
        //        NSLog(@"text was %@", textField.text);
        
        [self forgetPasswordSetup:textField.text];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"Cancel pressed");
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - forget Password Validation

-(void)forgetPasswordSetup :(NSString *)email{
    
    if (email.length >0)
    {
        NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        
        if  ([emailTest evaluateWithObject:email] != YES && [email length]!=0)
        {
            [self setAlertMessage:@"Invalid Email" :@"Please enter valid email address."];
            
        }
        
        else
        {
          [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            NSDictionary *forgotDic = @{@"email":email,
                                   @"actiontype":@"forgotpass"
                                   };
            NSLog(@"%@",forgotDic);
            [_dataFetch requestURL:KBaseUrl method:@"POST" dic:forgotDic from:@"forgetPasswordSetup" type:@"json"];
        }
    }
    else
    {
        [self setAlertMessage:@"Blank Email" :@"Email is required."];
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
    }
    
    
}

#pragma mark - Touches Began
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)sendLoginData{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSDictionary *loginDic = @{@"actiontype":@"login",
                                @"email":txtEmail.text,
                                @"password":txtPassword.text,
                                };
    NSLog(@"%@",loginDic);
    [_dataFetch requestURL:KBaseUrl method:@"POST" dic:loginDic from:@"sendLoginData" type:@"json"];
    
}

#pragma mark - Process Successful
- (void) processSuccessful :(NSDictionary *)data1 :(NSString *)JsonFor{
    
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
    NSLog(@"%@",data1);
    if ([JsonFor isEqual:@"sendLoginData"]) {
        if ([[data1 objectForKey:@"status"] isEqual:@"yes"]) {
            
            [[NSUserDefaults standardUserDefaults] setObject:[data1 objectForKey:@"data"] forKey:@"loginDetails"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            if ([[[data1 objectForKey:@"data"]valueForKey:@"user_type"] isEqual:@"user"]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else{
                StoreOwnerOrderViewController *ownerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StoreOwnerOrderViewController"];
                [self.navigationController pushViewController:ownerVC animated:YES];
            }
        }else{
            [self setAlertMessage:@"Error!" :@"Invalid Email id or Password."];
        }
        
    }else if([JsonFor isEqual:@"forgetPasswordSetup"]){
        if ([[[data1 objectForKey:@"data"]valueForKey:@"status"] isEqual:@"Invalid email"]) {
            [self setAlertMessage:@"Error!" :@"Invalid Email Id"];
        }else{
            [self setAlertMessage:@"Password Sent!" :@"Password has been sent to your email."];
        }
    }
    
}

#pragma mark - Process Not Successful

-(void)processNotSucessful:(NSString *)string{
    
}


@end
