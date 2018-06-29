//
//  StoreOwnerOrderViewController.m
//  cityRun
//
//  Created by Basir Alam on 05/04/17.
//  Copyright © 2017 Basir. All rights reserved.
//

#import "StoreOwnerOrderViewController.h"
#import "StoreOwnerProductViewController.h"
#import "StoreOwnerOrderTableViewCell.h"
#import "HamburgerMenuCell.h"
#import "StoreProfileViewController.h"
#import "ProductUploadViewController.h"
#import "SO_ChangePwdViewController.h"
#import "ContactUsViewController.h"
#import "OrderDetailsViewController.h"

@interface StoreOwnerOrderViewController ()<ProcessDataDelegate>
{
    IBOutlet UIButton *btnNewOrder;
    IBOutlet UIButton *btnOrderCompleted;
    
    IBOutlet UITableView *slideMenuTable;
    IBOutlet UIView *sliderMenuView;

    NSMutableArray *imagesArray;
    NSMutableArray *titleArray;
    IBOutlet UITableView *orderTable;

    //    Create object of DataFetch
    DataFetch *_dataFetch;
    NSDictionary* dataDic;
    
    NSString* selectedTab;
    BOOL isNew;
    
    int coutValue;
    NSMutableArray *tempAr;
    NSMutableArray *temp2;
    
    UIRefreshControl*  refreshControl;

    IBOutlet UILabel *txtStoreName;
    IBOutlet UILabel *txtPhone;
    IBOutlet UILabel *txtEmail;
    
    IBOutlet UIView *noteView;
    UIView* transView;
    IBOutlet UILabel *txtNote;

}
@end

@implementation StoreOwnerOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    selectedTab = @"new_order";
    transView = [[UIView alloc] initWithFrame:self.view.bounds];

//    dataDic = [[NSDictionary alloc]init];
    
    isNew = YES;

    _dataFetch = [[DataFetch alloc]init];
    _dataFetch.delegate = self;
    
    [self setRefreshController];
    [self setBackgroundImage];
    [self hamburgerMenuSetup];
    [self fetchOrderData];

}


-(void)setAnonymousUser{
    NSDictionary *loginDic = @{@"user_id":@"anonymous"
                               };
    
    [[NSUserDefaults standardUserDefaults] setObject:loginDic forKey:@"loginDetails"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - Set Refresh Controller

-(void)setRefreshController{
    //refresh the table data.
    refreshControl = [[UIRefreshControl alloc]init];
    [orderTable addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(fetchOrderData) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Hamburger Menu Setup

-(void)hamburgerMenuSetup{
    
    imagesArray=[NSMutableArray arrayWithObjects:@"ico-username.png",@"ico_plus_circle.png",@"ico-view-order.png",@"ico-change-ps.png",@"ico-mail.png",@"ico-power.png", nil];
    
    titleArray=[[NSMutableArray alloc]initWithObjects:@"Store Profile",@"Add Product",@"My Product",@"Change Password",@"Contact us",@"Logout",nil];
    
    
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

#pragma mark - TableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == slideMenuTable) {
        return titleArray.count;
    }else{
        
        return [[[dataDic objectForKey:@"data"] valueForKey:@"status"] count];
        
//        if (isNew == YES) {
//            
////            NSLog(@"%d",(int)[[[dataDic objectForKey:@"data"] valueForKey:@"status"] count]);
//            
//            return (int)[tempAr count];
//        }else{
//            
////            NSLog(@"%d",(int)[[[dataDic objectForKey:@"data"] valueForKey:@"delivered"] count]);
//            
//            return (int)[temp2 count];
//        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == slideMenuTable) {
        
        HamburgerMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HamburgerMenuCell" forIndexPath:indexPath];
        cell.backgroundColor = cell.contentView.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      
        cell.lblMenuTitleSO.text = [titleArray objectAtIndex:indexPath.row];
        cell.imgMenuImageSO.image = [UIImage imageNamed:[imagesArray objectAtIndex:indexPath.row]];
        
        if (IS_IPAD) {
            cell.lblMenuTitle.font = [UIFont fontWithName:@"Helvetica" size:22];
        }else{
            cell.lblMenuTitle.font = [UIFont fontWithName:@"Helvetica" size:16];
        }
        return cell;

    }else{
        StoreOwnerOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreOwnerOrderTableViewCell" forIndexPath:indexPath];
        cell.backgroundColor = cell.contentView.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([[[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"status"] isEqual:@"placed"] && isNew == YES) {
            
            cell.lblAddress.text = [NSString stringWithFormat:@"%@, %@, %@",[[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"address"],[[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"city"],[[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"country"]] ;

            cell.lblBuyerName.text = [[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"name"];
            cell.lblTotalPrice.text = [NSString stringWithFormat:@"$%@",[[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"billing_amount"]];
            cell.lblZip.text = [[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"zipcode"];
            
            cell.btnMoveToCompleted.tag = indexPath.row;
            [cell.btnMoveToCompleted addTarget:self action:@selector(moveToCompletedMethod:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnMoveToCompleted.hidden = NO;
            
            cell.btnOrderNote.tag = indexPath.row;
            [cell.btnOrderNote addTarget:self action:@selector(orderNoteMethod:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.btnDeliveryNote.tag = indexPath.row;
            [cell.btnDeliveryNote addTarget:self action:@selector(deliveryNoteMethod:) forControlEvents:UIControlEventTouchUpInside];
            

        }
        else if([[[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"status"] isEqual:@"delivered"] && isNew == NO){
            
          
            [cell.imgProduct sd_setImageWithURL:[NSURL URLWithString:[[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"image"]]];

//            cell.lblProductName.text = [[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"product"];
//            cell.lblPrice.text = [[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"price"];
//            cell.lblQty.text = [[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"quantity"];
//            cell.lblCategory.text = [[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"category"];
            
            cell.lblAddress.text = [NSString stringWithFormat:@"%@, %@, %@",[[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"address"],[[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"city"],[[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"country"]] ;
            
            cell.lblBuyerName.text = [[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"name"];
            cell.lblTotalPrice.text = [NSString stringWithFormat:@"$%@",[[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"billing_amount"]];
            cell.lblZip.text = [[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"zipcode"];

            
            cell.btnMoveToCompleted.hidden = YES;
            
            
            cell.btnOrderNote.tag = indexPath.row;
            [cell.btnOrderNote addTarget:self action:@selector(orderNoteMethod:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.btnDeliveryNote.tag = indexPath.row;
            [cell.btnDeliveryNote addTarget:self action:@selector(deliveryNoteMethod:) forControlEvents:UIControlEventTouchUpInside];

        }
        
        if (IS_IPAD) {
            cell.imgWidthLayout.constant = 130;
            cell.btnMoveWidthLayout.constant = 160;
            cell.btnMoveHeightLayout.constant = 35;
            
        }else{
            cell.imgWidthLayout.constant = 88;
            cell.btnMoveWidthLayout.constant = 115;
            cell.btnMoveHeightLayout.constant = 28;
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self hideSlideMenu];
    if (tableView == slideMenuTable) {
        if (indexPath.row == 0) {
          
            StoreProfileViewController *storeProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StoreProfileViewController"];
            [self.navigationController pushViewController:storeProfileVC animated:YES];
            
        }else if (indexPath.row == 1){
            ProductUploadViewController *addProductVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductUploadViewController"];
            [self.navigationController pushViewController:addProductVC animated:YES];

            
        }else if (indexPath.row == 2){
            
            StoreOwnerProductViewController *myProductVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StoreOwnerProductViewController"];
            [self.navigationController pushViewController:myProductVC animated:YES];

            
        }else if (indexPath.row == 3){
            
            SO_ChangePwdViewController *changePwdVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SO_ChangePwdViewController"];
            [self.navigationController pushViewController:changePwdVC animated:YES];

            
        }else if (indexPath.row == 4){
            ContactUsViewController *contactVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
            [self.navigationController pushViewController:contactVC animated:YES];
            
        }else if (indexPath.row == 5){
            
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loginDetails"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
            [self setAnonymousUser];

            [self.navigationController popToRootViewControllerAnimated:NO];
        }
    }else{
        NSLog(@"Hi");
        
        
//        OrderDetailsViewController *orderDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderDetailsViewController"];
//        orderDetailsVC.cart_id = [[[dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"cart_id"];
//        [self.navigationController pushViewController:orderDetailsVC animated:YES];

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == slideMenuTable) {
        if(IS_IPAD){
            return 75;
        }else{
            return 55;
        }
    }else{
        if (IS_IPAD) {
            return 160;
        }else{
            return 138;
        }
    }
 }

#pragma mark - Move To Completed Method

-(void)moveToCompletedMethod:(id)sender{
    NSLog(@"index %ld",(long)[sender tag]);
    
//    isNew = NO;
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSDictionary* moveDic = @{@"actiontype":@"movetocompleted",
                              @"user_id":[[[NSUserDefaults standardUserDefaults] valueForKey:@"loginDetails"] valueForKey:@"user_id"],
                              @"id":[[[dataDic objectForKey:@"data"] objectAtIndex:[sender tag]] valueForKey:@"cart_id"]
                                  };
    
    NSLog(@"%@",moveDic);
    [_dataFetch requestURL:KBaseUrl method:@"POST" dic:moveDic from:@"moveToCompletedMethod" type:@"json"];

}

-(void)orderNoteMethod:(id)sender{
    NSLog(@"index %ld",(long)[sender tag]);
    [self addAlertSubviewToCenter];
    txtNote.text = [[[dataDic objectForKey:@"data"] objectAtIndex:[sender tag]] valueForKey:@"ordernote"];

}
-(void)deliveryNoteMethod:(id)sender{
    NSLog(@"index %ld",(long)[sender tag]);
    [self addAlertSubviewToCenter];
    txtNote.text = [[[dataDic objectForKey:@"data"] objectAtIndex:[sender tag]] valueForKey:@"deliverynote"];
}

#pragma mark - btnCloseNote

- (IBAction)btnCloseNote:(id)sender {
    [transView removeFromSuperview];
    [noteView removeFromSuperview];

}

#pragma mark - Show Order/Delevery Note To Center
-(void)addAlertSubviewToCenter{
    
    [self addTransparentView];
    noteView.center = CGPointMake(self.view.frame.size.width  / 2,
                                   self.view.frame.size.height / 2);
    
    noteView.layer.cornerRadius = 10.0f;
    [UIView transitionWithView:noteView
                      duration:0.2
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.view addSubview:noteView];
                    } completion:nil];
}

-(void)addTransparentView{
    transView.backgroundColor=[UIColor blackColor];
    transView.alpha = 0.5;
    [self.view addSubview:transView];
}


- (IBAction)btnCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - New Order Action

- (IBAction)btnNewOrderAction:(id)sender {
    
    isNew = YES;
    selectedTab = @"new_order";

    [btnOrderCompleted setBackgroundImage:nil forState:UIControlStateNormal];
    [btnNewOrder setBackgroundImage:[UIImage imageNamed:@"btn-active.jpg"] forState:UIControlStateNormal];
    btnOrderCompleted.backgroundColor = [UIColor colorWithRed:60/256.0 green:173/256.0 blue:139/256.0 alpha:1.0];

    [self fetchOrderData];

}

#pragma mark - Order Completed Action

- (IBAction)btnOrderCompletedAction:(id)sender {
    
    isNew = NO;
    
    selectedTab = @"order_completed";

    [btnNewOrder setBackgroundImage:nil forState:UIControlStateNormal];
    [btnOrderCompleted setBackgroundImage:[UIImage imageNamed:@"btn-active.jpg"] forState:UIControlStateNormal];
    btnNewOrder.backgroundColor = [UIColor colorWithRed:60/256.0 green:173/256.0 blue:139/256.0 alpha:1.0];
 
    [orderTable reloadData];

    [self fetchOrderData];
}

#pragma mark - Hamburger Menu

- (IBAction)btnHamburgerMenu:(id)sender {
    [self menuButtonAction];
}

#pragma mark - Menu Button Action

- (void)menuButtonAction
{
    if (sliderMenuView.frame.origin.x>=0)
    {
        if (IS_IPAD) {
            [UIView animateWithDuration:0.2 animations:^
             {
                 sliderMenuView.frame = CGRectMake(-310, 64, 300, self.view.frame.size.height);
             }];
            
        }else{
            [UIView animateWithDuration:0.2 animations:^
             {
                 sliderMenuView.frame = CGRectMake(-(self.view.frame.size.width/2+60), 64, (self.view.frame.size.width/2+50), self.view.frame.size.height);
             }];
        }
    }
    else
    {
        if (IS_IPAD) {
            [UIView animateWithDuration:0.2 animations:^
             {
                 sliderMenuView.frame = CGRectMake(0, 64, 300, self.view.frame.size.height);
             }];
            
        }else{
            [UIView animateWithDuration:0.2 animations:^
             {
                 sliderMenuView.frame = CGRectMake(0, 64, (self.view.frame.size.width/2+50), self.view.frame.size.height);
             }];
        }
    }
}

#pragma mark - Touches Began
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self hideSlideMenu];
 }

-(void)hideSlideMenu{
    if (sliderMenuView.frame.origin.x>=0)
    {
        if (IS_IPAD) {
            [UIView animateWithDuration:0.2 animations:^
             {
                 sliderMenuView.frame = CGRectMake(-310, 64, 300, self.view.frame.size.height);
             }];
            
        }else{
            [UIView animateWithDuration:0.2 animations:^
             {
                 sliderMenuView.frame = CGRectMake(-(self.view.frame.size.width/2+60), 64, (self.view.frame.size.width/2+50), self.view.frame.size.height);
             }];
        }
    }

}
#pragma mark - Edit Action

- (IBAction)btnEditAction:(id)sender {
    StoreProfileViewController *storeProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StoreProfileViewController"];
    [self.navigationController pushViewController:storeProfileVC animated:YES];

}

#pragma mark - Profile Details Method

-(void)getProfileDetailsMethod{
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSDictionary *getDataDic = @{@"actiontype":@"fetchprofile",
                                 @"user_type":[[[NSUserDefaults standardUserDefaults] valueForKey:@"loginDetails"] valueForKey:@"user_type"],
                                 @"user_id":[[[NSUserDefaults standardUserDefaults] valueForKey:@"loginDetails"] valueForKey:@"user_id"]
                                 };
    NSLog(@"%@",getDataDic);
    [_dataFetch requestURL:KBaseUrl method:@"POST" dic:getDataDic from:@"getProfileDetailsMethod" type:@"json"];
}


#pragma mark - Fetch Order Data

-(void)fetchOrderData{
    NSLog(@"%@",selectedTab);
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
        NSDictionary* getOrderDic = @{@"actiontype":selectedTab,
                                     @"user_id":[[[NSUserDefaults standardUserDefaults] valueForKey:@"loginDetails"] valueForKey:@"user_id"]
                                      };
    
    NSLog(@"%@",getOrderDic);
    [_dataFetch requestURL:KBaseUrl method:@"POST" dic:getOrderDic from:@"fetchOrderData" type:@"json"];
    
}

#pragma mark - Process Successful
- (void) processSuccessful :(NSDictionary *)data1 :(NSString *)JsonFor{
    
    orderTable.hidden = NO;

    [refreshControl endRefreshing];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    dataDic = [[NSDictionary alloc]init];
    
    NSLog(@"%@",data1);
    
    if ([JsonFor isEqual:@"fetchOrderData"]) {
        if ([data1 valueForKey:@"data"] == (id)[NSNull null] || data1 == nil) {
            // tel is null
            NSLog(@"Null value is data");
//            [self alertset:@"No Data!" :@"Server not responding please try after sometime"];
            
        }else{
            if ([[data1 objectForKey:@"available"] isEqual:@"yes"]) {
                
                dataDic = data1;
                

            }else{
                orderTable.hidden = YES;
                //            [self alertset:@"ecoPODIUM App" :@"Server not responding please try after sometime"];
            }
            [orderTable reloadData];

        }
    }
    else if ([JsonFor isEqual:@"moveToCompletedMethod"]){
        if ([[data1 objectForKey:@"available"] isEqual:@"yes"]) {
            dataDic = data1;
            
            [orderTable reloadData];
            
        }else{
            orderTable.hidden = YES;

            //            [self alertset:@"ecoPODIUM App" :@"Server not responding please try after sometime"];
        }

    }
    else if ([JsonFor isEqual:@"getProfileDetailsMethod"]){
        if ([[data1 objectForKey:@"status"] isEqual:@"yes"]) {
            txtEmail.text = [[data1 objectForKey:@"data"] valueForKey:@"email"];
            txtPhone.text = [[data1 objectForKey:@"data"] valueForKey:@"phonenumber"];
            txtStoreName.text = [[data1 objectForKey:@"data"] valueForKey:@"store_name"];
        }

    }
    
}

#pragma mark - Process Not Successful

-(void)processNotSucessful:(NSString *)string{
    
}

@end
