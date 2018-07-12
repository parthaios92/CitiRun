//
//  HomeViewControllerNew.m
//  citiRun
//
//  Created by Abhishek Mitra on 31/05/18.
//  Copyright © 2018 Basir. All rights reserved.
//

#import "HomeViewControllerNew.h"
#import "HamburgerMenuCell.h"
#import "StoreOwnerOrderViewController.h"
#import "MyOrdersViewController.h"
#import "WebViewController.h"
#import "UserProfileViewController.h"
#import "ContactUsViewController.h"
#import "LoginViewController.h"
#import "SignupViewController.h"


@interface HomeViewControllerNew (){
    
    IBOutlet UITableView *slideMenuTable;
    IBOutlet UIView *sliderMenuView;
    IBOutlet UIButton *btnLogin;
    IBOutlet UIButton *btnSignup;
    NSMutableArray *titleArray1;
    IBOutlet UILabel *fontHeader1;
    IBOutlet UILabel *fontHeader2;
    IBOutlet UILabel *fontHeader3;
    
    IBOutlet NSLayoutConstraint *logoHeightConstraints;
    IBOutlet NSLayoutConstraint *logoWidthConstraints;
    
    IBOutlet NSLayoutConstraint *btnClickHereHeightConstraints;
    IBOutlet NSLayoutConstraint *bottomViewHeightConstraints;
    
    IBOutlet UIView *loginSignUpView;
    
}

@end

@implementation HomeViewControllerNew

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self hamburgerMenuSetup];
    [self setupConstraints];
}

-(void)setAnonymousUser{
    NSDictionary *loginDic = @{@"user_id":@"anonymous"
                               };
    
    [[NSUserDefaults standardUserDefaults] setObject:loginDic forKey:@"loginDetails"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self makeTransparentNavigationBar];
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"loginDetails"]);
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"loginDetails"] == nil || [[[[NSUserDefaults standardUserDefaults] valueForKey:@"loginDetails"] valueForKey:@"user_id"] isEqual:@"anonymous"]) {
        [self setAnonymousUser];
        titleArray1=[[NSMutableArray alloc]initWithObjects:@"About citiRunn",@"Services",@"Contact Us",@"Terms and Conditions",@"Privacy Policy",nil];
        
        loginSignUpView.hidden = NO;
        
    }
    /*    else if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"loginDetails"] valueForKey:@"user_id"] isEqual:@"anonymous"]) {
     
     
     titleArray1=[[NSMutableArray alloc]initWithObjects:@"About citiRun",@"Services",@"Contact us",@"Terms and conditions",@"Privacy policy",nil];
     
     btnLogin.hidden = NO;
     btnSignup.hidden = NO;
     
     }*/else{
         
         titleArray1=[[NSMutableArray alloc]initWithObjects:@"My Profile",@"My Orders",@"Contact us",@"Logout",nil];
         
         if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"loginDetails"] valueForKey:@"user_type"] isEqual:@"store"] ) {
             
             StoreOwnerOrderViewController *ownerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StoreOwnerOrderViewController"];
             [self.navigationController pushViewController:ownerVC animated:YES];
             
         }else{
             
              loginSignUpView.hidden = YES;
         }
     }
    [slideMenuTable reloadData];
    
}
#pragma mark - Click Here
- (IBAction)btnClickHereAction:(id)sender {
}


#pragma mark - Login Action
- (IBAction)btnLoginAction:(id)sender {
    LoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:loginVC animated:YES];
}

#pragma mark - Signup Action

- (IBAction)btnSignupAction:(id)sender {
    SignupViewController *signVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SignupViewController"];
    [self.navigationController pushViewController:signVC animated:YES];
}

#pragma mark - Cart Action

- (IBAction)btnCartAction:(id)sender {
    
    CartViewController *cartVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CartViewController"];
    [self.navigationController pushViewController:cartVC animated:YES];
    
}


#pragma mark - Hamburger Menu

-(void)hamburgerMenuSetup{
    
    //    imagesArray=[NSMutableArray arrayWithObjects:@"ico-input-username.png",@"select-bg.png",@"ico-input-phone.png",@"title_temp.jpg",@"ico-input-ps.png", nil];
    
    
    [sliderMenuView setFrame:CGRectMake(-(self.view.frame.size.width/2+60),64,self.view.frame.size.width/2+50,self.view.frame.size.height)];
    sliderMenuView.layer.masksToBounds = NO;
    sliderMenuView.layer.shadowOffset = CGSizeMake(1, 5);
    sliderMenuView.layer.shadowRadius = 5;
    sliderMenuView.layer.shadowOpacity = 0.5;
    
    [self.view addSubview:sliderMenuView];
    
    slideMenuTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
}

-(void)makeTransparentNavigationBar{
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
//                                                  forBarMetrics:UIBarMetricsDefault]; //UIImageNamed:@"transparent.png"
//    self.navigationController.navigationBar.shadowImage = [UIImage new]; ////UIImageNamed:@"transparent.png"
//    self.navigationController.navigationBar.translucent = YES;
    //self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
}

- (IBAction)menuAction:(UIButton *)sender {
    [self menuButtonAction];
}

- (void)menuButtonAction
{
    if (sliderMenuView.frame.origin.x>=0)
    {
        if (IS_IPAD) {
            [UIView animateWithDuration:0.2 animations:^
             {
                 self->sliderMenuView.frame = CGRectMake(-310, 64, 300, self.view.frame.size.height);
             }];
            
        }else{
            [UIView animateWithDuration:0.2 animations:^
             {
                 self->sliderMenuView.frame = CGRectMake(-(self.view.frame.size.width/2+60), 64, (self.view.frame.size.width/2+50), self.view.frame.size.height);
             }];
        }
    }
    else
    {
        if (IS_IPAD) {
            [UIView animateWithDuration:0.2 animations:^
             {
                 self->sliderMenuView.frame = CGRectMake(0, 64, 300, self.view.frame.size.height);
             }];
            
        }else{
            [UIView animateWithDuration:0.2 animations:^
             {
                 self->sliderMenuView.frame = CGRectMake(0, 64, (self.view.frame.size.width/2+50), self.view.frame.size.height);
             }];
        }
    }
}

#pragma mark - Touches Began
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self hideSliderMenu];
}
-(void)hideSliderMenu{
    if (sliderMenuView.frame.origin.x>=0)
    {
        if (IS_IPAD) {
            [UIView animateWithDuration:0.2 animations:^
             {
                 self->sliderMenuView.frame = CGRectMake(-310, 64, 300, self.view.frame.size.height);
             }];
            
        }else{
            [UIView animateWithDuration:0.2 animations:^
             {
                 self->sliderMenuView.frame = CGRectMake(-(self.view.frame.size.width/2+60), 64, (self.view.frame.size.width/2+50), self.view.frame.size.height);
             }];
        }
    }
}

#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArray1.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HamburgerMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HamburgerMenuCell" forIndexPath:indexPath];
    cell.backgroundColor = cell.contentView.backgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lblMenuTitle.text = [titleArray1 objectAtIndex:indexPath.row];
    //    cell.imgMenuImage.image = [UIImage imageNamed:[imagesArray objectAtIndex:indexPath.row]];
    if(IS_IPAD){
        cell.lblMenuTitle.font = [UIFont fontWithName:@"Helvetica" size:22];
    }else{
        cell.lblMenuTitle.font = [UIFont fontWithName:@"Helvetica" size:16];
    }
    
    return cell;
}
#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self hideSliderMenu];
    
    //Not logged in
    if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"loginDetails"] valueForKey:@"user_id"] isEqual:@"anonymous"]) {
        
//        if (indexPath.row == 0) {
//            //My Orders.
//            MyOrdersViewController *myOrderVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyOrdersViewController"];
//            [self.navigationController pushViewController:myOrderVC animated:YES];
//
//        }else
        
        if (indexPath.row == 0){
        
            WebViewController *webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
            webVC.from = [titleArray1 objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:webVC animated:YES];
            
            
        }else if (indexPath.row == 1){
            
            WebViewController *webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
            webVC.from = [titleArray1 objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:webVC animated:YES];
            
            
        }else if (indexPath.row == 2){
            
            ContactUsViewController *contactVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
            [self.navigationController pushViewController:contactVC animated:YES];
            
        }else if (indexPath.row == 3){
            
            WebViewController *webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
            webVC.from = [titleArray1 objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:webVC animated:YES];
            
        }
        else{
            
            WebViewController *webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
            webVC.from = [titleArray1 objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:webVC animated:YES];
            
        }
        
    }
    
    //Logged in
    else{
        if (indexPath.row == 0) {
            UserProfileViewController *myOrderVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
            [self.navigationController pushViewController:myOrderVC animated:YES];
            
        }else if (indexPath.row == 1){
            MyOrdersViewController *myOrderVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyOrdersViewController"];
            [self.navigationController pushViewController:myOrderVC animated:YES];
            
        }else if (indexPath.row == 2){
            
            ContactUsViewController *contactVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
            [self.navigationController pushViewController:contactVC animated:YES];
            
        }else if (indexPath.row == 3){
            
            if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"loginDetails"] valueForKey:@"user_id"] isEqual:@"anonymous"]) {
                
            }
            else{
                //                titleArray1=[[NSMutableArray alloc]initWithObjects:@"About citiRunn ",@"Services",@"Contact us",@"Terms and conditions",@"Privacy policy",nil];
                titleArray1=[[NSMutableArray alloc]initWithObjects:@"My Orders",@"About citiRunn",@"Services",@"Terms and Conditions",@"Privacy Policy",nil];
                
                [slideMenuTable reloadData];
                
                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loginDetails"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                [self setAnonymousUser];
                loginSignUpView.hidden = NO;
                
                [self setAlertMessage:@"Logout Success!" :@"You have successfully Logged out."];
            }
        }else{
            
        }
        
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(IS_IPAD){
        return 75;
    }else{
        return 55;
    }
    
}

#pragma mark - Constraints Setup
-(void)setupConstraints{
    if (IS_IPHONE) {
        if (IS_IPHONE_5){
            [fontHeader1 setFont:[UIFont fontWithName:@"Roboto-Light" size:39]];
            [fontHeader2 setFont:[UIFont fontWithName:@"Roboto-Light" size:39]];
            [fontHeader3 setFont:[UIFont fontWithName:@"Roboto-Light" size:22]];
            
            [logoHeightConstraints setConstant:231.5];
            [logoWidthConstraints setConstant:251.6];
            [btnClickHereHeightConstraints setConstant:40.0];
            [bottomViewHeightConstraints setConstant:46.3];
        }
        else if (IS_IPHONE_6){
            [fontHeader1 setFont:[UIFont fontWithName:@"Roboto-Light" size:45.0]];
            [fontHeader2 setFont:[UIFont fontWithName:@"Roboto-Light" size:45.0]];
            [fontHeader3 setFont:[UIFont fontWithName:@"Roboto-Light" size:25.0]];
            
            [logoHeightConstraints setConstant:272.0];
            [logoWidthConstraints setConstant:295.5];
            [btnClickHereHeightConstraints setConstant:47.0];
            [bottomViewHeightConstraints setConstant:54.3];
        }
        else if (IS_IPHONE_6P){
            [fontHeader1 setFont:[UIFont fontWithName:@"Roboto-Light" size:50]];
            [fontHeader2 setFont:[UIFont fontWithName:@"Roboto-Light" size:50]];
            [fontHeader3 setFont:[UIFont fontWithName:@"Roboto-Light" size:28]];
            
            [logoHeightConstraints setConstant:300.0];
            [logoWidthConstraints setConstant:326.0];
            [btnClickHereHeightConstraints setConstant:52.0];
            [bottomViewHeightConstraints setConstant:60.0];
        }
        
    }else if (IS_IPAD){
        
    }
    
}

@end
