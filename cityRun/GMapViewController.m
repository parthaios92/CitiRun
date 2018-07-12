//
//  GMapViewController.m
//  cityRun
//
//  Created by Basir Alam on 23/03/17.
//  Copyright © 2017 Basir. All rights reserved.
//

#import "GMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "ProductListTableViewCell.h"
#import "CartViewController.h"
@interface GMapViewController ()<CLLocationManagerDelegate,ProcessDataDelegate,GMSMapViewDelegate>
{
    
    IBOutlet GMSMapView *gMapView;
    CLLocationManager *locationManager;
    IBOutlet UIView *listView;
    IBOutlet UIView *productDetailsView;
    __weak IBOutlet UILabel *lblShowDistance;
    IBOutlet UIButton *btnMap;
    IBOutlet UIButton *btnList;
    NSMutableArray* latArray;
    NSMutableArray* lngArray;
    IBOutlet UIImageView *listViewBG;
    IBOutlet NSLayoutConstraint *textViewHeightLayout;
    IBOutlet UITextField *txtProductCount;
    IBOutlet UIButton *btnDecrement;
    NSMutableArray* listArray; //for temp basis
    IBOutlet UILabel *lblQty;
    
    
    //Popup properties
    IBOutlet UIImageView *productImage;
    IBOutlet UILabel *productName;
    IBOutlet UITextView *productDesc;
    IBOutlet UILabel *productDistance;
    IBOutlet UILabel *productPrice;
    
    DataFetch *_dataFetch;
    
    NSInteger productPriceInt;
    NSString* productID;
    
}
@property (strong, nonatomic) PayPalConfiguration *configuration;
@end

@implementation GMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataFetch = [[DataFetch alloc]init];
    _dataFetch.delegate = self;
    
    if (IS_IPAD) {
        listViewBG.image = [UIImage imageNamed:@"tab-bg.jpg"];
        textViewHeightLayout.constant = 150.0f;
    }else{
        listViewBG.image = [UIImage imageNamed:@"app-bg-innar.jpg"];
    }
    
    NSLog(@"%d",_miles);
    NSLog(@"%@",_dataDic);
    latArray = [[NSMutableArray alloc] init];
    lngArray = [[NSMutableArray alloc] init];
    
    latArray = [[_dataDic objectForKey:@"data"] valueForKey:@"lat"];
    lngArray = [[_dataDic objectForKey:@"data"] valueForKey:@"lng"];
    
    //    for (int i=0; i<[[[_dataDic objectForKey:@"data"] valueForKey:@"store_name"] count]; i++) {
    //        latArray = [[_dataDic objectForKey:@"data"] valueForKey:@"lat"];
    //        lngArray = [[_dataDic objectForKey:@"data"] valueForKey:@"lng"];
    //    }
    
    NSLog(@"%@",latArray);
    NSLog(@"%@",lngArray);
    NSLog(@"%@",[[_dataDic objectForKey:@"data"] valueForKey:@"quantity"]);
    
    self.title = @"Stores with product";
    [self getCurrentLocation];
    [self setupPayPal];
    lblShowDistance.text = [NSString stringWithFormat:@"Your searched item within %d mile",_miles];
}

-(void)setupPayPal{
    
    _configuration = [[PayPalConfiguration alloc]init];
    _configuration.acceptCreditCards = YES;
    _configuration.merchantName = @"MASC seller";
    _configuration.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/us/webapps/mpp/ua/privacy-full"];
    _configuration.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/us/webapps/mpp/ua/legalhub-full"];
    _configuration.languageOrLocale = [NSLocale preferredLanguages] [0];
    _configuration.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    NSLog(@"Pay Pal SDK = %@",[PayPalMobile libraryVersion]);
}
- (void)getCurrentLocation{
    
    CLLocationCoordinate2D coordinate = [self getLocation];
    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    //    LatLong = [NSString stringWithFormat:@"(%@,%@)",latitude,longitude];
    NSLog(@"Latitude  = %@", latitude);
    NSLog(@"Longitude = %@", longitude);
    //    [self GetCurrentAddressDetails:coordinate.latitude :coordinate.longitude];
    [self ShowCurrentAddressDetails:coordinate.latitude :coordinate.longitude];
    
}

-(CLLocationCoordinate2D) getLocation{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    return coordinate;
    
}

-(void)ShowCurrentAddressDetails :  (double) GetCurrentLat  : (double) GetcurrentLong{
    
    NSLog(@"%f\n%f",GetCurrentLat,GetcurrentLong);
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:GetCurrentLat
                                                            longitude:GetcurrentLong
                                                                 zoom:10];
    
    gMapView.delegate = self;
    for (int i=0; i<latArray.count; i++) {
        GMSMarker *marker = [[GMSMarker alloc] init];
        
        marker.position = CLLocationCoordinate2DMake([[latArray objectAtIndex:i] doubleValue], [[lngArray objectAtIndex:i] doubleValue]);
        marker.icon = [UIImage imageNamed:@"ico-map-store-location.png"];
  
        marker.title = [[[_dataDic objectForKey:@"data"] objectAtIndex:i] valueForKey:@"store_name"];
        marker.snippet = [[[_dataDic objectForKey:@"data"] objectAtIndex:i] valueForKey:@"price"];
        marker.userData = [[_dataDic objectForKey:@"data"] objectAtIndex:i];
        marker.map = gMapView;
        
    }
    
    //set the camera for the map
    gMapView.camera = camera;
    gMapView.myLocationEnabled = YES;
    
    gMapView.settings.myLocationButton = YES;
    gMapView.settings.compassButton = YES;
    
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    // your code
    NSLog(@"%@",marker.userData);
    
    productPriceInt = 0;
    txtProductCount.text = @"1";
    if (IS_IPAD) {
        [productDetailsView setFrame:CGRectMake(170,64+170,self.view.frame.size.width-340,self.view.frame.size.height-(300+64))];
        
    }else{
        [productDetailsView setFrame:CGRectMake(8,64+8,self.view.frame.size.width-16,self.view.frame.size.height-(16+64))];
    }
    [self.view setAlpha:0.5f];
    [self.view setUserInteractionEnabled:NO];
    [self.view.window addSubview:productDetailsView];
    
    lblQty.text = [marker.userData valueForKey:@"quantity"];
    productName.text = [marker.userData valueForKey:@"store_name"];
    productDesc.text = [marker.userData valueForKey:@"description"];
    productDistance.text = [marker.userData valueForKey:@"distance"];
    [productImage sd_setImageWithURL:[NSURL URLWithString:[marker.userData valueForKey:@"image"]]];
    
    productID = [marker.userData valueForKey:@"id"];
    
    productPrice.text = [NSString stringWithFormat:@"$%@",[marker.userData valueForKey:@"price"]];

}

/*
 -(void)ShowCurrentAddressDetails :  (double) GetCurrentLat  : (double) GetcurrentLong{
 
 GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[latArray objectAtIndex:0] doubleValue]
 longitude:[[lngArray objectAtIndex:0] doubleValue]
 zoom:12];
 
 for (int i=0; i<[[[_dataDic objectForKey:@"data"] valueForKey:@"store_name"] count]; i++) {
 GMSMarker *marker = [[GMSMarker alloc] init];
 
 marker.position = CLLocationCoordinate2DMake([[latArray objectAtIndex:i] doubleValue], [[lngArray objectAtIndex:i] doubleValue]);
 marker.icon = [UIImage imageNamed:@"ico-map-store-location.png"];
 marker.title = [[[_dataDic objectForKey:@"data"] objectAtIndex:i]valueForKey:@"store_name"];
 marker.snippet = [[[_dataDic objectForKey:@"data"] objectAtIndex:i]valueForKey:@"store_address"];
 marker.map = gMapView;
 
 }
 
 //set the camera for the map
 gMapView.camera = camera;
 gMapView.myLocationEnabled = YES;
 
 gMapView.settings.myLocationButton = YES;
 
 }
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[_dataDic objectForKey:@"data"] valueForKey:@"id"] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ProductListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductListTableViewCell" forIndexPath:indexPath];
    cell.backgroundColor = cell.contentView.backgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.btnViewDetails.tag = indexPath.row;
    [cell.btnViewDetails addTarget:self action:@selector(viewDetailsMethod:) forControlEvents:UIControlEventTouchUpInside];

    cell.lblStoreName.text = [[[_dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"store_name"];
    cell.lblStartingFrom.text = [NSString stringWithFormat:@"$%@ (%@)",[[[_dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"price"],[[[_dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"quantity"]];
    cell.lblStoreDistance.text = [[[_dataDic objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"distance"];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",(long)indexPath.row);
    

    productPriceInt = 0;
    txtProductCount.text = @"1";
    if (IS_IPAD) {
        [productDetailsView setFrame:CGRectMake(170,64+170,self.view.frame.size.width-340,self.view.frame.size.height-(300+64))];
        
    }else{
        [productDetailsView setFrame:CGRectMake(8,64+8,self.view.frame.size.width-16,self.view.frame.size.height-(16+64))];
    }
    [self.view setAlpha:0.5f];
    [self.view setUserInteractionEnabled:NO];
    [self.view.window addSubview:productDetailsView];
    
    productName.text = [[[_dataDic objectForKey:@"data"] objectAtIndex:indexPath.item] valueForKey:@"store_name"];
    productDesc.text = [[[_dataDic objectForKey:@"data"] objectAtIndex:indexPath.item] valueForKey:@"description"];
    productDistance.text = [[[_dataDic objectForKey:@"data"] objectAtIndex:indexPath.item] valueForKey:@"distance"];
    [productImage sd_setImageWithURL:[NSURL URLWithString:[[[_dataDic objectForKey:@"data"] objectAtIndex:indexPath.item] valueForKey:@"image"]]];
    
    productID = [[[_dataDic objectForKey:@"data"] objectAtIndex:indexPath.item] valueForKey:@"id"];
    lblQty.text = [[[_dataDic objectForKey:@"data"] objectAtIndex:indexPath.item] valueForKey:@"quantity"];

    
    productPrice.text = [NSString stringWithFormat:@"$%@",[[[_dataDic objectForKey:@"data"] objectAtIndex:indexPath.item] valueForKey:@"price"]];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPAD) {
        return 160;
    }else{
        return 138;
    }
}

- (IBAction)btnListViewAction:(id)sender {
    //    [gMapView removeFromSuperview];
    
//    btnMap.backgroundColor = [UIColor colorWithRed:60.0f/255.0f green:173.0f/255.0f blue:139.0f/255.0f alpha:1];
//    btnList.backgroundColor = [UIColor colorWithRed:41.0f/255.0f green:118.0f/255.0f blue:95.0f/255.0f alpha:1];
    
    [btnList setBackgroundColor:[UIColor whiteColor]];
    [btnList setTitleColor: [UIColor colorWithRed:122/255.0 green:175/255.0 blue:72/255.0 alpha:1.0]forState:UIControlStateNormal];
    [btnMap setBackgroundColor:[UIColor colorWithRed:122/255.0 green:175/255.0 blue:72/255.0 alpha:1.0]];
    [btnMap setTitleColor: [UIColor whiteColor]forState:UIControlStateNormal];
    
    
    [gMapView setHidden:YES];
    [listView setFrame:CGRectMake(0,64+54,self.view.frame.size.width,self.view.frame.size.height-(64+54+37))];
    [self.view addSubview:listView];
    
}
-(void)showProductPopUp{
    
}
- (IBAction)btnMapViewAction:(id)sender {
    
//    btnMap.backgroundColor = [UIColor colorWithRed:41.0f/255.0f green:118.0f/255.0f blue:95.0f/255.0f alpha:1];
//    btnList.backgroundColor = [UIColor colorWithRed:60.0f/255.0f green:173.0f/255.0f blue:139.0f/255.0f alpha:1];
    
    [btnMap setBackgroundColor:[UIColor colorWithRed:122/255.0 green:175/255.0 blue:72/255.0 alpha:1.0]];
    [btnMap setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnList setBackgroundColor:[UIColor whiteColor]];
    [btnList setTitleColor:[UIColor colorWithRed:122/255.0 green:175/255.0 blue:72/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [listView removeFromSuperview];
    [gMapView setHidden:NO];
    
    //    [gMapView setFrame:CGRectMake(0,64+60,self.view.frame.size.width,self.view.frame.size.height-(64+60))];
    //    [self.view addSubview:gMapView];
    
}
- (IBAction)btnCloseDetails:(id)sender {
    [self.view setAlpha:1.0f];
    [self.view setUserInteractionEnabled:YES];
    [productDetailsView removeFromSuperview];
}
- (IBAction)btnOrderNowAction:(id)sender {
    //    [self setupPaymentWithTaxAndOther];
    CartViewController *cartVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CartViewController"];
    [self.navigationController pushViewController:cartVC animated:YES];
}
-(void)setupPaymentWithTaxAndOther{
    PayPalItem * item1 = [PayPalItem itemWithName:@"song1" withQuantity:1 withPrice:[NSDecimalNumber decimalNumberWithString:@"30"] withCurrency:@"USD" withSku:@"Song1-1122"];
    
    PayPalItem * item2 = [PayPalItem itemWithName:@"song2" withQuantity:1 withPrice:[NSDecimalNumber decimalNumberWithString:@"30"] withCurrency:@"USD" withSku:@"Song2-1133"];
    
    NSArray* items = @[item1,item2];
    NSDecimalNumber *subTotal = [PayPalItem totalPriceForItems:items];
    NSDecimalNumber* shipping = [[NSDecimalNumber alloc]initWithString:@"5.0"];
    NSDecimalNumber* tax = [[NSDecimalNumber alloc]initWithString:@"2.0"];
    PayPalPaymentDetails* paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subTotal withShipping:shipping  withTax:tax];
    
    
    NSDecimalNumber *toal=[[subTotal decimalNumberByAdding:shipping]decimalNumberByAdding:tax];
    PayPalPayment *payments=[[PayPalPayment alloc]init];
    payments.amount=toal;
    payments.currencyCode=@"USD";
    payments.shortDescription=@"MY Payments";
    payments.items=items;
    payments.paymentDetails=paymentDetails;
    // payments.payeeEmail = @"";
    
    if(!payments.processable)
    {
        
    }
    
    PayPalPaymentViewController *paymentViewController=[[PayPalPaymentViewController alloc]initWithPayment:payments configuration:self.configuration delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];
}
- (void)payPalPaymentDidCancel:(nonnull PayPalPaymentViewController *)paymentViewController{
    NSLog(@"Payment cancelled");
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)payPalPaymentViewController:(nonnull PayPalPaymentViewController *)paymentViewController
                 didCompletePayment:(nonnull PayPalPayment *)completedPayment{
    
    NSLog(@"Payment success");
    NSLog(@"%@",completedPayment);
    
    NSDictionary *payDetails =@{@"CurrencyCode":completedPayment.currencyCode,
                                @"Amount":completedPayment.amount,
                                @"ShortDescription":completedPayment.shortDescription,
                                };
    
    NSDictionary *data = @{@"userid":@"user001",
                           @"paydata":payDetails,
                           };
    
    NSLog(@"%@",data);
    if (data == (id)[NSNull null]) {
        // tel is null
    }
    //    [dataFetch request:paymentUrl :@"POST" :data :@"payPalSubmit"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnTemp:(id)sender {
    [productDetailsView setFrame:CGRectMake(8,64+8,self.view.frame.size.width-16,self.view.frame.size.height-(16+64))];
    [self.view addSubview:productDetailsView];
}
-(void)viewDetailsMethod:(id)sender{
    
    productPriceInt = 0;
    txtProductCount.text = @"1";
    NSLog(@"%ld",(long)[sender tag]);
    if (IS_IPAD) {
        [productDetailsView setFrame:CGRectMake(170,64+170,self.view.frame.size.width-340,self.view.frame.size.height-(300+64))];
        
    }else{
        [productDetailsView setFrame:CGRectMake(8,64+8,self.view.frame.size.width-16,self.view.frame.size.height-(16+64))];
    }
    [self.view setAlpha:0.5f];
    [self.view setUserInteractionEnabled:NO];
    [self.view.window addSubview:productDetailsView];
    
    productName.text = [[[_dataDic objectForKey:@"data"] objectAtIndex:[sender tag]] valueForKey:@"store_name"];
    productDesc.text = [[[_dataDic objectForKey:@"data"] objectAtIndex:[sender tag]] valueForKey:@"description"];
    productDistance.text = [[[_dataDic objectForKey:@"data"] objectAtIndex:[sender tag]] valueForKey:@"distance"];
    [productImage sd_setImageWithURL:[NSURL URLWithString:[[[_dataDic objectForKey:@"data"] objectAtIndex:[sender tag]] valueForKey:@"image"]]];
    
    productID = [[[_dataDic objectForKey:@"data"] objectAtIndex:[sender tag]] valueForKey:@"id"];
    
    productPrice.text = [NSString stringWithFormat:@"$%@",[[[_dataDic objectForKey:@"data"] objectAtIndex:[sender tag]] valueForKey:@"price"]];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self isMovingFromParentViewController])
    {
        NSLog(@"View controller was popped");
        [productDetailsView removeFromSuperview];
        
    }
    else
    {
        NSLog(@"New view controller was pushed");
    }
}

#pragma mark - Increment Action.

- (IBAction)btnIncrementAction:(id)sender {
    
    btnDecrement.enabled = YES;
    txtProductCount.text = [NSString stringWithFormat:@"%ld",[txtProductCount.text integerValue]+1];
    productPrice.text = [NSString stringWithFormat:@"$%ld",[txtProductCount.text integerValue] * productPriceInt] ;
}


#pragma mark - Decrement Action.

- (IBAction)btnDecrementAction:(id)sender {
    NSLog(@"%ld",(long)productPriceInt);
    NSLog(@"%@",txtProductCount.text);
    
    if ([txtProductCount.text integerValue] == 1) {
        btnDecrement.enabled = NO;
    }else{
        btnDecrement.enabled = YES;
        txtProductCount.text = [NSString stringWithFormat:@"%ld",[txtProductCount.text integerValue]-1];
        productPrice.text = [NSString stringWithFormat:@"$%ld",[txtProductCount.text integerValue] * productPriceInt] ;
        
    }
    
}

#pragma mark - Cart Action

- (IBAction)btnCartAction:(id)sender {
    CartViewController *cartVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CartViewController"];
    [self.navigationController pushViewController:cartVC animated:YES];
    
}
- (IBAction)btnAddToCart:(id)sender {
    [self.view setAlpha:1.0f];
    [self.view setUserInteractionEnabled:YES];
    [productDetailsView removeFromSuperview];
    [self addToCartMethod];
}

-(void)addToCartMethod{
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSString *deviceToken ;
    
    
#if TARGET_IPHONE_SIMULATOR
    
    deviceToken = @"396dc0b8baa8698843ad2f7e5088039c49da5bffb1171aa7252e9affa53efe21";
    
#else
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"deviceID"] == nil) {
        deviceToken = @"396dc0b8baa8698843ad2f7e5088039c49da5bffb1171aa7252e9affa53efe21";
    }else{
        deviceToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"deviceID"];
    }
#endif
    
    NSLog(@"dev id:%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"deviceID"]);
    NSLog(@"dev id: %@",deviceToken);
    
    NSDictionary *addToCartDic = @{@"actiontype":@"addtocart",
                                   @"id":productID,
                                   @"user_id":[[[NSUserDefaults standardUserDefaults] valueForKey:@"loginDetails"] valueForKey:@"user_id"],
                                   @"device_id":deviceToken,
                                   @"quantity":lblQty.text,
                                   @"amount":txtProductCount.text,
                                   @"price":[productPrice.text stringByReplacingOccurrencesOfString:@"$" withString:@""],
                                   };
    
    
    NSLog(@"%@",addToCartDic);
    [_dataFetch requestURL:KBaseUrl method:@"POST" dic:addToCartDic from:@"addToCartMethod" type:@"json"];
}

#pragma mark - Process Successful
- (void) processSuccessful :(NSDictionary *)data1 :(NSString *)JsonFor{
    NSLog(@"%@",data1);
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    if ([[data1 objectForKey:@"success"] isEqual:@"no"]) {
        if ([[[data1 objectForKey:@"data"] valueForKey:@"invalid"] isEqual:@"Different Seller"]) {
           
            [self setAlertMessage:@"Error!" :@"You cannot add product from different seller in one cart."];

        }else if ([[[data1 objectForKey:@"data"] valueForKey:@"invalid"] isEqual:@"Product Exists"]){
            [self setAlertMessage:@"Error!" :@"You have already added this product to your cart."];
        }
        else{
            [self setAlertMessage:@"Error!" :@"Something went wrong. Please try again."];

        }
        
    }else{
        
        [self setAlertMessage:@"Success!" :@"Product successfully added to your shopping cart."];
    }
    
}
-(void)processNotSucessful:(NSString *)string{
    [self setAlertMessage:@"Error!" :@"Something went wrong. Please try again."];
}


@end
