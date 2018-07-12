//
//  StoreProfileViewController.m
//  citiRun
//
//  Created by Basir Alam on 27/04/17.
//  Copyright © 2017 Basir. All rights reserved.
//

#import "StoreProfileViewController.h"

@interface StoreProfileViewController ()<ProcessDataDelegate>
{
    IBOutlet UIView *storeTypeView;
    
    IBOutlet ACFloatingTextField *txtStoreName;
    IBOutlet ACFloatingTextField *txtOwnerName;
    IBOutlet ACFloatingTextField *txtStoreType;
    IBOutlet ACFloatingTextField *txtEmail;
    IBOutlet ACFloatingTextField *txtAddress;
    IBOutlet ACFloatingTextField *txtPhone;
    IBOutlet ACFloatingTextFieldOriginal *txtCountry;
    IBOutlet ACFloatingTextFieldOriginal *txtCity;
    IBOutlet ACFloatingTextFieldOriginal *txtZip;
   
    IBOutlet NSLayoutConstraint *lblWidthLayout;
    IBOutlet NSLayoutConstraint *lblHeightLayout;
    IBOutlet NSLayoutConstraint *topLayout;
    
    DataFetch *_dataFetch;

}
@end

@implementation StoreProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Edit Profile";
    [self setConstantsAndFonts];
    
    //[self setBackgroundImage];
    [self navigationColorSet];
    [self BackbuttonSet];
    
    _dataFetch = [[DataFetch alloc]init];
    _dataFetch.delegate = self;

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
        [self setAlertMessage:@"Blank Fields!" :@"Please fill the fields then click on submit."];
        
    }else{
        [self setProfileDetailsMethod];
    }
    
}

-(void)setProfileDetailsMethod{
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSDictionary *contactDic = @{@"actiontype":@"editprofile",
                                 @"email":txtEmail.text,
                                 @"zip":txtZip.text,
                                 @"address":txtAddress.text,
                                 @"city":txtCity.text,
                                 @"phonenumber":txtPhone.text,
                                 @"country":txtCountry.text,
                                 @"ownername":txtOwnerName.text,
                                 @"store_type":txtStoreType.text,
                                 @"store_name":txtStoreName.text,
                                 @"user_type":[[[NSUserDefaults standardUserDefaults] valueForKey:@"loginDetails"] valueForKey:@"user_type"],
                                 @"user_id":[[[NSUserDefaults standardUserDefaults] valueForKey:@"loginDetails"] valueForKey:@"user_id"]
                                 };
    NSLog(@"%@",contactDic);
    [_dataFetch requestURL:KBaseUrl method:@"POST" dic:contactDic from:@"setProfileDetailsMethod" type:@"json"];
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
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    if ([JsonFor isEqual:@"getProfileDetailsMethod"]) {
        //code for get
        if ([[data1 objectForKey:@"status"] isEqual:@"yes"]) {
            txtEmail.text = [[data1 objectForKey:@"data"] valueForKey:@"email"];
            txtZip.text = [[data1 objectForKey:@"data"] valueForKey:@"zip"];
            txtAddress.text = [[data1 objectForKey:@"data"] valueForKey:@"address"];
            txtCity.text = [[data1 objectForKey:@"data"] valueForKey:@"city"];
            txtPhone.text = [[data1 objectForKey:@"data"] valueForKey:@"phonenumber"];
            txtCountry.text = [[data1 objectForKey:@"data"] valueForKey:@"country"];
            txtOwnerName.text = [[data1 objectForKey:@"data"] valueForKey:@"fullname"];
            txtStoreType.text = [[data1 objectForKey:@"data"] valueForKey:@"store_type"];
            txtStoreName.text = [[data1 objectForKey:@"data"] valueForKey:@"store_name"];
        }
    }else{
        
        if ([[data1 objectForKey:@"success"] isEqual:@"yes"]) {
            
            [self setAlertMessage:@"Success!" :@"Profile saved successfully."];
//            txtSubject.text = nil;
//            txtViewMessage.text = nil;
            
        }else{
            
            //        [self setAlertMessage:@"Success!" :@"Product successfully added to your shopping cart."];
        }
    }
}
-(void)processNotSucessful:(NSString *)string{
    [self setAlertMessage:@"Error!" :@"Something went wrong. Please try again."];
}

@end
