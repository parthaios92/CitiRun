//
//  ViewController.m
//  cityRun
//
//  Created by Basir Alam on 14/03/17.
//  Copyright © 2017 Basir. All rights reserved.
//

#import "HomeViewController.h"
#import "HamburgerMenuCell.h"
#import "LoginViewController.h"
#import "SignupViewController.h"
#import "OrderSelectionVC.h"
#import "MyOrdersViewController.h"
#import "StoreOwnerOrderViewController.h"
#import "UserProfileViewController.h"
#import "ContactUsViewController.h"
#import "WebViewController.h"
@interface HomeViewController ()
{
    IBOutlet UITableView *slideMenuTable;
    IBOutlet UIView *sliderMenuView;
    NSMutableArray *imagesArray;
    NSMutableArray *titleArray1;
    NSMutableArray *titleArray2;
    IBOutlet UIButton *btnLogin;
    IBOutlet UIButton *btnSignup;
    
    IBOutlet UIButton *btnHamburger;
    
    __weak IBOutlet NSLayoutConstraint *menuWidthLayout;
    __weak IBOutlet NSLayoutConstraint *menuHeightlayout;
    __weak IBOutlet UILabel *lblLiquor;
    __weak IBOutlet UILabel *lblVegan;
    __weak IBOutlet UILabel *lblMealPlan;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setConstantsAndFonts];
    [self setBackgroundImage];
    [self hamburgerMenuSetup];
    
}
-(void)setNavigationButton{
    
//    UIImage* image3 = [UIImage imageNamed:@"hamburger-nav.png"];
//    CGRect frameimg = CGRectMake(15,5, 25,25);
//    
//    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
//    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
//    [someButton addTarget:self action:@selector(Back_btn:)
//         forControlEvents:UIControlEventTouchUpInside];
//    [someButton setShowsTouchWhenHighlighted:YES];
//    
//    UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
//    self.navigationItem.leftBarButtonItem =mailbutton;
    //[someButton release];
}
-(IBAction)Back_btn:(id)sender
{
    //Your code here
}
-(void)setAnonymousUser{
    NSDictionary *loginDic = @{@"user_id":@"anonymous"
                               };
    
    [[NSUserDefaults standardUserDefaults] setObject:loginDic forKey:@"loginDetails"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)viewWillAppear:(BOOL)animated{
    [self setNavigationButton];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"loginDetails"]);
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"loginDetails"] == nil || [[[[NSUserDefaults standardUserDefaults] valueForKey:@"loginDetails"] valueForKey:@"user_id"] isEqual:@"anonymous"]) {
        [self setAnonymousUser];
        titleArray1=[[NSMutableArray alloc]initWithObjects:@"My Orders",@"About citiRunn",@"Services",@"Terms and Conditions",@"Privacy Policy",nil];
        
        btnLogin.hidden = NO;
        btnSignup.hidden = NO;
        
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
             btnLogin.hidden = YES;
             btnSignup.hidden = YES;
         }
     }
    [slideMenuTable reloadData];
    
}
#pragma mark - Set Constants And Fonts

-(void)setConstantsAndFonts{
    if (IS_IPAD) {
        menuWidthLayout.constant = 180;
        menuHeightlayout.constant = 180;
        
        [lblLiquor setFont:[UIFont fontWithName:@"Helvetica" size:26.0f]];
        [lblVegan setFont:[UIFont fontWithName:@"Helvetica" size:26.0f]];
        [lblMealPlan setFont:[UIFont fontWithName:@"Helvetica" size:26.0f]];
        
        //        [self formatLoginAndSignupButton:30.0];
        //        btnLogin.titleLabel.font = [UIFont systemFontOfSize:30.0];
        //        btnSignup.titleLabel.font = [UIFont systemFontOfSize:30.0];
        
    }else if(IS_IPHONE_6P){
        menuWidthLayout.constant = 110;
        menuHeightlayout.constant = 110;
        
        [self formatLoginAndSignupButton:16.0];
        btnLogin.titleLabel.font = [UIFont systemFontOfSize:16.0];
        btnSignup.titleLabel.font = [UIFont systemFontOfSize:16.0];
        
        
    }else if(IS_IPHONE_6){
        menuWidthLayout.constant = 110;
        menuHeightlayout.constant = 110;
        
        [self formatLoginAndSignupButton:16.0];
        btnLogin.titleLabel.font = [UIFont systemFontOfSize:16.0];
        btnSignup.titleLabel.font = [UIFont systemFontOfSize:16.0];
        
        
    }else if (IS_IPHONE_5){
        menuWidthLayout.constant = 90;
        menuHeightlayout.constant = 90;
        
        [self formatLoginAndSignupButton:16.0];
        btnLogin.titleLabel.font = [UIFont systemFontOfSize:16.0];
        btnSignup.titleLabel.font = [UIFont systemFontOfSize:16.0];
        
        
    }else{
        menuWidthLayout.constant = 70;
        menuHeightlayout.constant = 70;
        
        [self formatLoginAndSignupButton:16.0];
        btnLogin.titleLabel.font = [UIFont systemFontOfSize:16.0];
        btnSignup.titleLabel.font = [UIFont systemFontOfSize:16.0];
        
        
    }
}
-(void)viewDidAppear:(BOOL)animated{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:46.0/255 green:140.0/255 blue:106.0/255 alpha:1.0];
}
-(void)formatLoginAndSignupButton:(CGFloat)fontSize{
    NSMutableAttributedString *txtLogin =
    [[NSMutableAttributedString alloc]
     initWithAttributedString: btnLogin.titleLabel.attributedText];
    [txtLogin addAttribute:NSForegroundColorAttributeName
                     value:[UIColor blackColor]
                     range:NSMakeRange(7, 6)];
    
    [txtLogin addAttribute:NSFontAttributeName
                     value:[UIFont fontWithName:@"Helvetica" size:fontSize]
                     range:NSMakeRange(7, 6)];
    
    
    NSMutableAttributedString *txtSignin =
    [[NSMutableAttributedString alloc]
     initWithAttributedString: btnSignup.titleLabel.attributedText];
    [txtSignin addAttribute:NSForegroundColorAttributeName
                      value:[UIColor blackColor]
                      range:NSMakeRange(23, 6)];
    
    [txtSignin addAttribute:NSFontAttributeName
                      value:[UIFont fontWithName:@"Helvetica" size:fontSize]
                      range:NSMakeRange(23, 6)];
    
    
    [btnLogin setAttributedTitle:txtLogin forState:UIControlStateNormal];
    [btnSignup setAttributedTitle:txtSignin forState:UIControlStateNormal];
}
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self hideSliderMenu];
  
    //Not logged in
    if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"loginDetails"] valueForKey:@"user_id"] isEqual:@"anonymous"]) {
        
        if (indexPath.row == 0) {
            //My Orders.
            MyOrdersViewController *myOrderVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyOrdersViewController"];
            [self.navigationController pushViewController:myOrderVC animated:YES];
            
        }else if (indexPath.row == 1){
            
            WebViewController *webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
            webVC.from = [titleArray1 objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:webVC animated:YES];

            
        }else if (indexPath.row == 2){
            
            WebViewController *webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
            webVC.from = [titleArray1 objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:webVC animated:YES];
        }else if (indexPath.row == 3){
            
            WebViewController *webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
            webVC.from = [titleArray1 objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:webVC animated:YES];

        }else{
            
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
                
                //                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loginDetails"];
                //                [[NSUserDefaults standardUserDefaults] synchronize];
                [self setAnonymousUser];
                
                btnLogin.hidden = NO;
                btnSignup.hidden = NO;
                
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


- (IBAction)btnHamburgerMenu:(id)sender {
    [self menuButtonAction];
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
/*
 -(void)slidingActionToRight
 {
 if (sliderVC.view.frame.origin.x<0)
 {
 [UIView animateWithDuration:0.5 animations:^
 {
 sliderVC.view.frame = CGRectMake(0, 0, 180, self.view.frame.size.height-self.tabBarController.tabBar.frame.size.height);
 }];
 }
 }
 -(void)slidingActionToLeft
 {
 if (sliderVC.view.frame.origin.x>=0)
 {
 [UIView animateWithDuration:0.5 animations:^
 {
 sliderVC.view.frame = CGRectMake(-180, 0, 180, self.view.frame.size.height-self.tabBarController.tabBar.frame.size.height);
 }];
 
 }
 }
 */

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

#pragma mark - Goto Order Selection Action

- (IBAction)btnGotoOrderSelectionAction:(id)sender {
    NSLog(@"selected product %ld",(long)[sender tag]);
    OrderSelectionVC *orderVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderSelectionVC"];
    orderVC.productTag = [sender tag];
    [self.navigationController pushViewController:orderVC animated:YES];
}

#pragma mark - Cart Action


- (IBAction)btnCartAction:(id)sender {
    CartViewController *cartVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CartViewController"];
    [self.navigationController pushViewController:cartVC animated:YES];
    
}

@end
