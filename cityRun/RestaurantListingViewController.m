//
//  RestaurantListingViewController.m
//  citiRun
//
//  Created by Abhishek Mitra on 05/06/18.
//  Copyright © 2018 Basir. All rights reserved.
//

#import "RestaurantListingViewController.h"
#import "TableViewCell.h"
#import "RestaurentDetailsController.h"
#import "CartViewController.h"
#import <coreLocation/CoreLocation.h>

@interface RestaurantListingViewController ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,CLLocationManagerDelegate,ProcessDataDelegate>{
    
    IBOutlet UITableView *tableViewRestaurant;
    
    UITextField *searchTextField;
    
     CLLocationManager *locationManager;
     NSMutableArray* restaurantListingArray;
     NSDictionary *dataDic;
    
     DataFetch *_dataFetch;
    
    NSString *longitude;
    NSString *latitude;
}

@end

@implementation RestaurantListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    
    
    _dataFetch = [[DataFetch alloc]init];
    _dataFetch.delegate = self;
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self cutomNavigation];
   
}

#pragma mark - NavigationBarDesign

-(void)cutomNavigation{
    
    
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:122/255.0 green:175/255.0 blue:72/255.0 alpha:1.0];
    
    [self.navigationController.navigationBar setBackgroundImage:nil
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
    
    UIImage* image3 = [UIImage imageNamed:@"cart (1).png"];
    CGRect frameimg = CGRectMake(0, 0, image3.size.width, image3.size.height);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(Cart)
         forControlEvents:UIControlEventTouchUpInside];
    //[someButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.rightBarButtonItem=mailbutton;
    
    searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width/2, 30.0)];
    //textField.layer.borderWidth = 1.0;
    //textField.layer.borderColor = [UIColor darkGrayColor].CGColor;
    [searchTextField.layer setCornerRadius:14.0f];
    searchTextField.placeholder = @"Search Here..";
    [searchTextField setTextAlignment:NSTextAlignmentCenter];
    searchTextField.backgroundColor = [UIColor whiteColor];
    //textField.background=[UIImage imageNamed:@"textFieldImage.png"];
    self.navigationItem.titleView = searchTextField;
    searchTextField.delegate = self;
   
    
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        longitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        latitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        
        NSLog(@"Latitude  = %@", latitude);
        NSLog(@"Longitude = %@", longitude);
        [self fetchListingData];
        
    }
}

-(void)fetchListingData{
    
    NSDictionary *listDic = @{@"actiontype":@"restaurantsearch",
                              @"long":longitude,
                              @"lat":latitude,
                              };
    NSLog(@"%@",listDic);
    [_dataFetch requestURL:KBaseUrl method:@"POST" dic:listDic from:@"listValue" type:@"json"];

    
}

-(void)Cart{
    
    CartViewController *cartVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CartViewController"];
    [self.navigationController pushViewController:cartVC animated:YES];
}

#pragma mark - UITextfieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
     [searchTextField becomeFirstResponder];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [searchTextField resignFirstResponder];
    [self SearchRestaurent];
    
    return YES;
}

#pragma SearChing Restaurent With Name:

-(void)SearchRestaurent{
    
    NSDictionary *searchDic = @{@"actiontype":@"restaurantsearch_key",
                              @"long":longitude,
                              @"lat":latitude,
                              @"store_name":searchTextField.text
                              };
    NSLog(@"%@",searchDic);
    [_dataFetch requestURL:KBaseUrl method:@"POST" dic:searchDic from:@"SearchItem" type:@"json"];
}



#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return restaurantListingArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TableViewCell * cell =  [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
    
    cell.cellView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    cell.cellView.layer.borderWidth = 1;
    
    [cell.storeImage sd_setImageWithURL:[NSURL URLWithString:[[restaurantListingArray objectAtIndex:indexPath.row] valueForKey:@"image"]]];
    cell.lblStoreName.text = [[restaurantListingArray objectAtIndex:indexPath.row] valueForKey:@"store_name"];
    cell.lblStoreAddress.text = [[restaurantListingArray objectAtIndex:indexPath.row] valueForKey:@"address"];
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (IS_IPAD){
        
        return 300.0;
        
    }else{
        
        return 220.0;
    }
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RestaurentDetailsController *restDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RestaurentDetailsController"];
    restDetailVC.restDetailsArray = restaurantListingArray[indexPath.row];
    [self.navigationController pushViewController:restDetailVC animated:YES];
    
}

#pragma mark - Process Successful

- (void) processSuccessful :(NSDictionary *)data1 :(NSString *)JsonFor{
    
    NSLog(@"%@",data1);
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    dataDic = [[NSDictionary alloc]init];
    
    if ([JsonFor isEqual:@"listValue"]){
        
        if ([[data1 objectForKey:@"availability"] isEqual:@"yes"]){
            
            dataDic = data1;
            
            restaurantListingArray=[dataDic objectForKey:@"data"];
            
            //NSLog(@"%lu,%@",(unsigned long)restaurantListingArray.count,[dataDic objectForKey:@"data"]);
            [tableViewRestaurant reloadData];
            
        }else{
            
            
        }
        
    }else{
        
        if ([[data1 objectForKey:@"availability"] isEqual:@"yes"]){
            
            dataDic = data1;
            
            restaurantListingArray=[dataDic objectForKey:@"data"];
            
            //NSLog(@"%lu,%@",(unsigned long)restaurantListingArray.count,[dataDic objectForKey:@"data"]);
            [tableViewRestaurant reloadData];
            
        }else{
            
            
        }
        
    }
    
    
}

-(void)processNotSucessful:(NSString *)string{
    
}


@end
