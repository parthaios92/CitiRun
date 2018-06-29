//
//  SO_ChangePwdViewController.m
//  citiRun
//
//  Created by Basir Alam on 27/04/17.
//  Copyright © 2017 Basir. All rights reserved.
//

#import "SO_ChangePwdViewController.h"

@interface SO_ChangePwdViewController ()
{
    IBOutlet ACFloatingTextField *txtOldPwd;
    IBOutlet ACFloatingTextField *txtNewPwd;
    IBOutlet ACFloatingTextField *txtConfirmPwd;
    IBOutlet NSLayoutConstraint *textFeildWidthLayout;
    IBOutlet NSLayoutConstraint *textFeildHeightLayout;
    DataFetch *_dataFetch;

}
@end

@implementation SO_ChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Change Password";
    [self setBackgroundImage];
    [self setConstantsAndFonts];
    
    _dataFetch = [[DataFetch alloc]init];
    _dataFetch.delegate = self;

}

#pragma mark - Touches Began
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma mark - Set Constants And Fonts

-(void)setConstantsAndFonts{
    if (IS_IPAD) {
        textFeildWidthLayout.constant = 400.0f;
        
    }else if(IS_IPHONE_6P){
        
    }else if(IS_IPHONE_6){
        
    }else if (IS_IPHONE_5){
        
    }else{
        
    }
}
- (IBAction)btnChangePwdAction:(id)sender {
    
    NSLog(@"New: %@\nConf: %@",txtNewPwd.text,txtConfirmPwd.text);
    
    if (txtNewPwd.text.length == 0 || txtOldPwd.text.length == 0 || txtNewPwd.text.length == 0) {
        [self setAlertMessage:@"Blank Fields!" :@"Please fill the fields then click on submit."];
        
    }else{
        if ([txtNewPwd.text isEqualToString: txtConfirmPwd.text]) {
            [self changePwdMethod];
        }else{
            [self setAlertMessage:@"Error!" :@"Password does not match the confirm password."];

        }
    }

}

-(void)changePwdMethod{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSDictionary *contactDic = @{@"actiontype":@"changepassword",
                                 @"old_pwd":txtOldPwd.text,
                                 @"new_pwd":txtNewPwd.text,
                                 @"user_type":[[[NSUserDefaults standardUserDefaults] valueForKey:@"loginDetails"] valueForKey:@"user_type"],
                                 @"user_id":[[[NSUserDefaults standardUserDefaults] valueForKey:@"loginDetails"] valueForKey:@"user_id"]
                                 };
    NSLog(@"%@",contactDic);
    [_dataFetch requestURL:KBaseUrl method:@"POST" dic:contactDic from:@"contactUsMethod" type:@"json"];

}

#pragma mark - Process Successful
- (void) processSuccessful :(NSDictionary *)data1 :(NSString *)JsonFor{
    NSLog(@"%@",data1);
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    if ([[data1 objectForKey:@"status"] isEqual:@"password changed successfully"]) {
        
        [self setAlertMessage:@"Success!" :@"You have successfully changed the password."];
        txtNewPwd.text = nil;
        txtOldPwd.text = nil;
        txtConfirmPwd.text = nil;
        
    }else{
        
            [self setAlertMessage:@"Wrong Password!" :@"The old password that you provided is wrong."];
    }
    
}
-(void)processNotSucessful:(NSString *)string{
    [self setAlertMessage:@"Error!" :@"Something went wrong. Please try again."];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
