
//  OrderSelectionVC.m
//  cityRun
//
//  Created by Basir Alam on 14/03/17.
//  Copyright © 2017 Basir. All rights reserved.
//

#import "OrderSelectionVC.h"
#import "ASValueTrackingSlider.h"
#import "ACFloatingTextFieldFind.h"
#import "GMapViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface OrderSelectionVC ()<ASValueTrackingSliderDataSource,ProcessDataDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    
    IBOutlet ASValueTrackingSlider *asSlider;
    NSArray *_sliders;
    
    IBOutlet ACFloatingTextFieldFind *txtCategory;
    IBOutlet ACFloatingTextFieldFind *txtSubcategory;
    IBOutlet ACFloatingTextFieldFind *txtZipcode;
    
    IBOutlet UITableView *autocompleteTable;
    
    IBOutlet UIImageView *imgSelectedProduct;
    
    __weak IBOutlet NSLayoutConstraint *menuWidthLayout;
    __weak IBOutlet NSLayoutConstraint *menuHeightlayout;
    IBOutlet UIView *autocompleteView;
    NSString* selectedTextField;
    int milesFromSlider;
    __weak IBOutlet UIButton *btnFind;
    IBOutlet UILabel *lblSelectRadius;
    
    DataFetch *_dataFetch;
    
    NSDictionary* dataDic;
    NSMutableArray* tableArray;
    NSString* catIDStr;
    NSString* subCatIDStr;
    
    IBOutlet NSLayoutConstraint *sliderTopLayout;
    
    
}

@end

@implementation OrderSelectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Search your item";
    
    _dataFetch = [[DataFetch alloc]init];
    _dataFetch.delegate = self;
    
    autocompleteTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    

    [self allocationOfObjects];
    [self.view addSubview:autocompleteView];
    [autocompleteView setHidden:YES];
    [self setBackgroundImageTemp];
    [self settingGBSlider];
    [self setImageOfSearchingProduct];
    [self setConstantsAndFonts];
    [self setShadowToAutocompleteView];
//    [self getCategory];
    
    NSLog(@"Product Tag: %ld",(long)self.productTag);
    
}

-(void)allocationOfObjects{
    dataDic = [[NSDictionary alloc]init];
    tableArray = [[NSMutableArray alloc]init];
}
-(void)setBackgroundImageTemp
{
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"select-radius-bg_iPad.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}

-(void)getCategory: (NSString *)str{
//    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSDictionary *selectMealDic = @{@"actiontype":@"get_category",
                                    @"category_title":str,
                                    @"meal_type":[NSString stringWithFormat:@"%ld",(long)_productTag],
                                    };
    NSLog(@"%@",selectMealDic);
    [_dataFetch requestURL:KBaseUrl method:@"POST" dic:selectMealDic from:@"getCategory" type:@"json"];
    
}
-(void)getSubCategory:(NSString*)categoryStr{
//    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSDictionary *selectMealDic = @{@"actiontype":@"get_subcategory",
                                    @"category":categoryStr,
                                    };
    NSLog(@"%@",selectMealDic);
    [_dataFetch requestURL:KBaseUrl method:@"POST" dic:selectMealDic from:@"getSubCategory" type:@"json"];
    
}
-(void)setShadowToAutocompleteView{
    autocompleteView.layer.masksToBounds = NO;
    autocompleteView.layer.shadowOffset = CGSizeMake(1, 2);
    autocompleteView.layer.cornerRadius = 10.0f;
    autocompleteView.layer.shadowRadius = 5.0f;
    autocompleteView.layer.shadowOpacity = 0.5;
    if (IS_IPAD) {
        btnFind.titleLabel.font = [UIFont systemFontOfSize:26.0];
    }
}
-(void)setConstantsAndFonts{
    txtCategory.placeHolderColor = [UIColor whiteColor];
    txtSubcategory.placeHolderColor = [UIColor whiteColor];
    txtZipcode.placeHolderColor = [UIColor whiteColor];
    
    if (IS_IPAD) {
        menuWidthLayout.constant = 180;
        menuHeightlayout.constant = 180;
        
        txtCategory.font = [UIFont fontWithName:@"Helvetica" size:26];
        txtSubcategory.font = [UIFont fontWithName:@"Helvetica" size:26];
        txtZipcode.font = [UIFont fontWithName:@"Helvetica" size:26];
        lblSelectRadius.font = [UIFont fontWithName:@"Helvetica" size:26];
        
    }else if(IS_IPHONE_6P){
        menuWidthLayout.constant = 110;
        menuHeightlayout.constant = 110;
        
    }else if(IS_IPHONE_6){
        menuWidthLayout.constant = 110;
        menuHeightlayout.constant = 110;
        
    }else if (IS_IPHONE_5){
        menuWidthLayout.constant = 100;
        menuHeightlayout.constant = 100;
        sliderTopLayout.constant = 70;
    }else{
        menuWidthLayout.constant = 70;
        menuHeightlayout.constant = 70;
        
    }
}

-(void)setImageOfSearchingProduct{
    if (_productTag == 1) {
        imgSelectedProduct.image = [UIImage imageNamed:@"ico-liquor.png"];
    }
    else if (_productTag == 2) {
        imgSelectedProduct.image = [UIImage imageNamed:@"ico-vegan.png"];
    }
    else {
        imgSelectedProduct.image = [UIImage imageNamed:@"ico-meal.png"];
    }
}

-(void)settingGBSlider{
    // customize slider 1
    asSlider.minimumValue = 5.0;
    asSlider.maximumValue = 50.0;
    asSlider.value = 25.0;
    asSlider.popUpViewCornerRadius = 0.0;
    [asSlider setMaxFractionDigitsDisplayed:0];
    asSlider.popUpViewColor = [UIColor colorWithRed:46.0/255 green:140.0/255 blue:106.0/255 alpha:1.0];
    asSlider.textColor = [UIColor whiteColor];
    asSlider.popUpViewWidthPaddingFactor = 2.0;
    
    if (IS_IPAD) {
        asSlider.font = [UIFont fontWithName:@"GillSans" size:30];
    }else{
        asSlider.font = [UIFont fontWithName:@"GillSans" size:20];
    }
}

#pragma mark - ASValueTrackingSliderDataSource

- (NSString *)slider:(ASValueTrackingSlider *)slider stringForValue:(float)value;
{
    value = roundf(value);
    NSString *s;
    if (value < -10.0) {
        s = @"❄️Brrr!⛄️";
    } else if (value > 29.0 && value < 50.0) {
        s = [NSString stringWithFormat:@"😎 %@ 😎", [slider.numberFormatter stringFromNumber:@(value)]];
    } else if (value >= 50.0) {
        s = @"I’m Melting!";
    }
    return s;
}

#pragma mark - IBActions

- (IBAction)toggleShowHide:(UIButton *)sender
{
    sender.selected = !sender.selected;
    for (ASValueTrackingSlider *slider in _sliders) {
        sender.selected ? [slider showPopUpViewAnimated:YES] : [slider hidePopUpViewAnimated:YES];
    }
}

- (void)animateSlider:(ASValueTrackingSlider*)slider toValue:(float)value
{
    [slider setValue:25.0f animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)sliderMoved:(id)sender
{
    NSLog(@"Slider Value: %d",(int)asSlider.value);
    milesFromSlider = (int)asSlider.value;
}


#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[tableArray valueForKey:@"category_id"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor = cell.contentView.backgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (IS_IPAD) {
        cell.textLabel.font  = [ UIFont fontWithName: @"Arial" size: 20.0 ];
    }else{
        cell.textLabel.font  = [ UIFont fontWithName: @"Arial" size: 14.0 ];
    }
    if ([selectedTextField isEqual:@"category"]) {
        [cell.textLabel setText:[[tableArray objectAtIndex:indexPath.row] valueForKey:@"category_title"]];

    }else{
        [cell.textLabel setText:[[tableArray objectAtIndex:indexPath.row] valueForKey:@"sub_category_title"]];
    }
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([selectedTextField isEqual:@"category"]) {
        txtCategory.text = [[tableArray objectAtIndex:indexPath.row] valueForKey:@"category_title"];
        catIDStr = [[tableArray objectAtIndex:indexPath.row] valueForKey:@"category_id"];
        
//        [self getSubCategory:catIDStr];
        
    }else{

        subCatIDStr = [[tableArray objectAtIndex:indexPath.row] valueForKey:@"sub_category_id"];
        txtSubcategory.text = [[tableArray objectAtIndex:indexPath.row] valueForKey:@"sub_category_title"];
    }
    autocompleteView.hidden = YES;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPAD) {
        return 60;
        
    }else{
        return 40;
    }
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    
    if(indexPath.row % 2 == 0)
        cell.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1];
    
    else
        cell.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Touches Began
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [autocompleteView setHidden:YES];
    [self.view endEditing:YES];
}

#pragma mark  UITextfield Delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == 1 || textField.tag == 2)
    {
        [autocompleteView setHidden:NO];
    }
    [self.view setFrame:CGRectMake(0,-120,self.view.frame.size.width,self.view.frame.size.height)];
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [autocompleteTable setContentOffset:CGPointZero animated:YES];
    
    NSLog(@"%lu",(unsigned long)tableArray.count) ;
    
    
    
    if (textField.tag == 1)
    {
        
        autocompleteView.hidden = NO;
        
        
        txtSubcategory.enabled = YES;
        txtSubcategory.text = nil;
        [self getCategory:@""];
        selectedTextField = @"category";
        autocompleteView.frame = CGRectMake(txtCategory.frame.origin.x, txtCategory.frame.origin.y+txtCategory.frame.size.height, txtCategory.frame.size.width, [self autocompleteViewHeight]);
        NSLog(@"%lu",(unsigned long)[self autocompleteViewHeight]);
    }
    else if(textField.tag == 2)
    {
        autocompleteView.hidden = NO;
        
        selectedTextField = @"subcategory";
        autocompleteView.frame = CGRectMake(txtSubcategory.frame.origin.x, txtSubcategory.frame.origin.y+txtSubcategory.frame.size.height, txtSubcategory.frame.size.width, [self autocompleteViewHeight]);
        
        [self getSubCategory:catIDStr];
        
    }
    
    return YES;
    
}

-(NSUInteger)autocompleteViewHeight{
    
    NSUInteger height = 0;
    
    
//    if (tempCategoryArray.count<5) {
//        if (IS_IPAD) {
//            NSLog(@"%lu",(unsigned long)60*tableArray.count);
//            
//            return height = 60*tableArray.count;
//        }else{
//            return height = 40*tableArray.count;
//        }
//    }else{
        return height = txtCategory.frame.size.height*3;
//    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    
//    if (textField.tag == 1 || textField.tag == 2) {
        if (textField.tag == 1 ) {
        autocompleteView.hidden = NO;
        NSString * searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSLog(@"%@",searchStr);
        
            [self getCategory :searchStr];
            
//        NSPredicate *searchSearch = [NSPredicate predicateWithFormat:@"self CONTAINS[cd] %@", searchStr];
//        currentArray = [tableArray filteredArrayUsingPredicate:searchSearch];
        
//        CGRect tableFrame = [autocompleteView frame];
//        if (currentArray.count<6){
//            if (IS_IPAD) {
//                tableFrame.size.height = 60*currentArray.count;
//                
//            }else{
//                tableFrame.size.height = 40*currentArray.count;
//            }
//        }
//        else{
//            tableFrame.size.height = txtSubcategory.frame.size.height*3;
//        }
//        [autocompleteView setFrame:tableFrame];
//        [autocompleteTable reloadData];
    }
    
    return YES;
}
- (IBAction)btnFindAction:(id)sender {
    NSLog(@"%d",milesFromSlider);
    if (milesFromSlider == 0) {
        milesFromSlider = 25;
    }
    /*
     GMapViewController *gMapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GMapViewController"];
     gMapVC.miles = milesFromSlider;
     //    gMapVC.dataDic = data1;
     [self.navigationController pushViewController:gMapVC animated:YES];
     */
    
    [self getTheStorList];
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

-(void)getTheStorList{
    
    NSLog(@"catStr:%@\nsubCatStr:%@",catIDStr,subCatIDStr);
    
    if (txtZipcode.text.length == 0 || txtCategory.text.length == 0 || txtSubcategory.text.length == 0) {
        [self setAlertMessage:@"Empty fields!" :@"Please fill the fields to proceed."];
    }else{
   
        CLLocationCoordinate2D coordinate = [self getLocation];
        NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
        NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];

        NSLog(@"%@",latitude);
        NSLog(@"%@",latitude);
        
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        NSDictionary *selectMealDic = @{@"actiontype":@"search",
                                        @"meal_type":[NSString stringWithFormat:@"%ld",(long)_productTag],
                                        @"zip":txtZipcode.text,
                                        @"radius":[NSString stringWithFormat:@"%ld",(long)milesFromSlider],
                                        @"category":catIDStr,
                                        @"sub_category":subCatIDStr,
                                        @"lat":latitude,
                                        @"long":longitude
                                        };
        NSLog(@"%@",selectMealDic);
        
        [_dataFetch requestURL:KBaseUrl method:@"POST" dic:selectMealDic from:@"getTheStoreList" type:@"json"];
    }
}
#pragma mark - Process Successful
- (void) processSuccessful :(NSDictionary *)data1 :(NSString *)JsonFor{
    NSLog(@"%@",data1);
    
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
    if ([JsonFor isEqual:@"getCategory"]) {
       
        tableArray = [data1 objectForKey:@"data"];
        
    }else if ([JsonFor isEqual:@"getSubCategory"]){

        tableArray = [data1 objectForKey:@"data"];
    }
    else if ([JsonFor isEqual:@"getTheStoreList"]){
        if ([[data1 objectForKey:@"status"] isEqual:@"no"]) {
            [self setAlertMessage:@"Result" :@"No data found."];
        }else{
            if ([[data1 objectForKey:@"status"] isEqual:@"no"]) {
                [self setAlertMessage:@"Result" :@"No data found."];
            }else{
                GMapViewController *gMapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GMapViewController"];
                gMapVC.miles = milesFromSlider;
                gMapVC.dataDic = data1;
                [self.navigationController pushViewController:gMapVC animated:YES];
            }
        }
    }
    
    [autocompleteTable reloadData];
}
-(void)processNotSucessful:(NSString *)string{
    
}

#pragma mark - Cart Action

- (IBAction)btnCartAction:(id)sender {
    CartViewController *cartVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CartViewController"];
    [self.navigationController pushViewController:cartVC animated:YES];
    
}

@end
