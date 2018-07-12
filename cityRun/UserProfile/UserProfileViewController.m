//
//  UserProfileViewController.m
//  citiRun
//
//  Created by Basir Alam on 03/05/17.
//  Copyright © 2017 Basir. All rights reserved.
//

#import "UserProfileViewController.h"

@interface UserProfileViewController ()<ProcessDataDelegate,UITextFieldDelegate>
{
    IBOutlet ACFloatingTextField *txtUserName;
    IBOutlet ACFloatingTextField *txtEmail;
    IBOutlet ACFloatingTextField *txtAddress;
    IBOutlet ACFloatingTextField *txtPhone;
    IBOutlet ACFloatingTextField *txtCountry;
    
    IBOutlet ACFloatingTextFieldOriginal *txtCity;
    IBOutlet ACFloatingTextFieldOriginal *txtZip;
    
    IBOutlet NSLayoutConstraint *lblWidthLayout;
    IBOutlet NSLayoutConstraint *lblHeightLayout;
    IBOutlet NSLayoutConstraint *topLayout;
    
    DataFetch *_dataFetch;
    
}
@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    txtUserName.delegate = self;
    txtEmail.delegate = self;
    txtAddress.delegate = self;
    txtPhone.delegate = self;
    txtCountry.delegate = self;
    
    txtCity.delegate = self;
    txtZip.delegate = self;
    
    _dataFetch = [[DataFetch alloc]init];
    _dataFetch.delegate = self;
    
    //[self setBackgroundImage];
    [self navigationColorSet];
    [self BackbuttonSet];
    [self setConstantsAndFonts];
    [self getProfileDetailsMethod];
    
}

#pragma mark NavigationColor Set

-(void)navigationColorSet{
    
    self.navigationItem.hidesBackButton = YES;
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:122/255.0 green:175/255.0 blue:72/255.0 alpha:1.0];
}

#pragma mark - Set Constants And Fonts

-(void)setConstantsAndFonts{
    if (IS_IPAD) {
        
        topLayout.constant = 100.0f;
        lblWidthLayout.constant = 400.0f;
        
    }else if(IS_IPHONE_6P){
        
    }else if(IS_IPHONE_6){
        
    }else if (IS_IPHONE_5){
        
    }else{
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnSubmitAction:(id)sender {
    
    if (txtZip.text.length == 0 || txtEmail.text.length == 0) {
        
        [self setAlertMessage:@"Blank Fields!" :@"Please fill the fields one of Zip Or Email then click on UPDATE."];
        
    }else{
        
        [self setProfileDetailsMethod];
    }
    
}

-(void)setProfileDetailsMethod{
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSDictionary *updateDic = @{@"actiontype":@"editprofile",
                                 @"fullname":txtUserName.text,
                                 @"address":txtAddress.text,
                                 @"city":txtCity.text,
                                 @"country":txtCountry.text,
                                 @"zipcode":txtZip.text,
                                 @"phonenumbe":txtPhone.text,
                                 @"user_type":[[[NSUserDefaults standardUserDefaults] valueForKey:@"loginDetails"] valueForKey:@"user_type"],
                                 @"user_id":[[[NSUserDefaults standardUserDefaults] valueForKey:@"loginDetails"] valueForKey:@"user_id"]
                                 };
    NSLog(@"%@",updateDic);
    [_dataFetch requestURL:KBaseUrl method:@"POST" dic:updateDic from:@"setProfileDetailsMethod" type:@"json"];
}

-(void)getProfileDetailsMethod{
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSDictionary *getDataDic = @{@"actiontype":@"fetchprofile",
                                 @"user_type":[[[NSUserDefaults standardUserDefaults] valueForKey:@"loginDetails"] valueForKey:@"user_type"],
                                 @"user_id":[[[NSUserDefaults standardUserDefaults] valueForKey:@"loginDetails"] valueForKey:@"user_id"]
                                 };
    NSLog(@"%@",getDataDic);
    [_dataFetch requestURL:KBaseUrl method:@"POST" dic:getDataDic from:@"getProfileDetailsMethod" type:@"json"];
    
}

#pragma mark - Process Successful
- (void) processSuccessful :(NSDictionary *)data1 :(NSString *)JsonFor{
    
    NSLog(@"%@",data1);
    NSLog(@"%@",[data1 objectForKey:@"zipcode"]);
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    if ([JsonFor isEqual:@"getProfileDetailsMethod"]) {
        //code for get
        
        txtEmail.text = [data1 objectForKey:@"email"];
        txtZip.text = [data1 objectForKey:@"zipcode"];
        txtAddress.text = [data1 objectForKey:@"address"];
        txtCity.text = [data1 objectForKey:@"city"];
        txtPhone.text = [data1 objectForKey:@"phonenumber"];
        txtCountry.text = [data1 objectForKey:@"country"];
        txtUserName.text = [data1 objectForKey:@"fullname"];
        
    }else{
        
        if ([[data1 objectForKey:@"success"] isEqual:@"yes"]) {
            
            [self setAlertMessage:@"Success!" :@"Your profile is updated successfully."];
            
//            txtSubject.text = nil;
//            txtViewMessage.text = nil;
            
        }else{
            
            //   [self setAlertMessage:@"Success!" :@"Product successfully added to your shopping cart."];
        }
    }
}
-(void)processNotSucessful:(NSString *)string{
    [self setAlertMessage:@"Error!" :@"Something went wrong. Please try again."];
}

#pragma mark-
#pragma mark- TextField Delegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

@end
