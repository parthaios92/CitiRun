//
//  SignupViewController.m
//  cityRun
//
//  Created by Basir Alam on 26/03/17.
//  Copyright © 2017 Basir. All rights reserved.
//

#import "SignupViewController.h"
#import "StoreOwnerOrderViewController.h"
#import "WebViewController.h"
#import "TOCropViewController.h"

#import "AFNetworking.h"
#import "UIView+Toast.h"

@interface SignupViewController ()<ProcessDataDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TOCropViewControllerDelegate>
{
    UIImagePickerController *imagePicker;
    UIImageView *savedImage;
    IBOutlet UIView *storeOwnerView;
    
    
    NSString *selectedTab,*uploadImageStr;
    
    IBOutlet UIView *pageUser;
    IBOutlet UIView *pageOwner;
    IBOutlet UIImageView *signupBG2;
    
    IBOutlet UIButton *btnUser2;
    IBOutlet UIButton *btnUser1;
    IBOutlet UIButton *btnSignup1;
    IBOutlet UIButton *btnSignup2;
    IBOutlet NSLayoutConstraint *topLayoutOfTextFiled;
    IBOutlet NSLayoutConstraint *topLayoutOfTextFiled1;
    IBOutlet NSLayoutConstraint *weightLayoutOfTextField;
    IBOutlet NSLayoutConstraint *weightLayoutOfTextField1;
    
    IBOutlet NSLayoutConstraint *storeOwnerTopConstraint;
    
    
    //    Create object of DataFetch
    DataFetch *_dataFetch;
    
    //Setting getter setter method
    
    IBOutlet ACFloatingTextField *txtFullname;
    IBOutlet ACFloatingTextField *txtEmail;
    IBOutlet ACFloatingTextField *txtPhone;
    IBOutlet ACFloatingTextField *txtAddressInUser;
    IBOutlet ACFloatingTextField *txtPassword;
    IBOutlet ACFloatingTextField *txtConfirmpassword;
    
    //Store Owner textFiled
    IBOutlet ACFloatingTextField *txtStoreName;
    IBOutlet ACFloatingTextField *txtStoreType;
    IBOutlet ACFloatingTextField *txtAddress;
    IBOutlet ACFloatingTextFieldOriginal *txtCountry;
    IBOutlet ACFloatingTextFieldOriginal *txtCity;
    IBOutlet ACFloatingTextFieldOriginal *txtZip;
    IBOutlet ACFloatingTextFieldOriginal *txtStoreDesc;
    
    
    IBOutlet UILabel *lblStoreImageName;
    
    NSMutableArray *storeTypeArray;
    IBOutlet UIView *storeTypeView;
    IBOutlet UITableView *storeTypeTable;
    
    IBOutlet NSLayoutConstraint *storeOwnerbtnTConstraint;
    
    NSData *imagedata;
    NSString* picStr;
    NSString *path;
    
    UIImageView *dummyImage;
    
    NSData *pngData;
    NSData *syncResData;
    NSMutableURLRequest *request;
    
#define URL  @"http://www.appsforcompany.com/citirun/app/upload_image.php"  // change this URL
#define NO_CONNECTION  @"No Connection"
#define NO_IMAGE      @"NO IMAGE SELECTED"
    
}
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navigationColorSet];
    
    self.title = @"Signup";
    selectedTab = @"user";
    [self BackbuttonSet];
    
    lblStoreImageName.layer.borderWidth = 1.0;
    lblStoreImageName.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    [storeOwnerView setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    [self.view addSubview:storeOwnerView];
    storeOwnerView.hidden = YES;
    
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    
    _dataFetch = [[DataFetch alloc]init];
    _dataFetch.delegate = self;
    
    [self setConstantsAndFonts];
    [self storeTypeDropDown];
    
}

-(void)storeTypeDropDown{
    storeTypeArray=[[NSMutableArray alloc]initWithObjects:@"Liquor",@"Vegan",@"Meal Plans",nil];
}

#pragma mark NavigationColor Set

-(void)navigationColorSet{
    
    self.navigationItem.hidesBackButton = YES;
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:122/255.0 green:175/255.0 blue:72/255.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Set Constants And Fonts

-(void)setConstantsAndFonts{
    
    if (IS_IPAD) {
        
        weightLayoutOfTextField1.constant = 600.0f;
        //storeOwnerbtnTConstraint.constant = 70.0f;

    }else if(IS_IPHONE_6P){
       
        weightLayoutOfTextField1.constant = 330.0f;

    }else if(IS_IPHONE_6){
        
        weightLayoutOfTextField1.constant = 300.0f;

    }else if (IS_IPHONE_5){
        
        weightLayoutOfTextField1.constant = 280.0f;

    }else if (IS_IPHONE_X){
        
        //weightLayoutOfTextField1.constant = 260.0f;
        //storeOwnerbtnTConstraint.constant = 88.0f;
        
    }else{
       
        weightLayoutOfTextField1.constant = 260.0f;
    }
}

#pragma mark - Set Constants And Fonts

-(void)setBackgroundImageOfBG2
{
    UIGraphicsBeginImageContext(self.view.frame.size);
    if (IS_IPAD) {
        
        signupBG2.image = [UIImage imageNamed:@"tab-bg.jpg"];
        topLayoutOfTextFiled1.constant = -214.0f;
        topLayoutOfTextFiled.constant = 50.0f;
        weightLayoutOfTextField.constant = 600.0f;
        
        
    }else if(IS_IPHONE_6P){
        
        signupBG2.image = [UIImage imageNamed:@"app-bg-innar.jpg"];
        weightLayoutOfTextField.constant = 330.0f;
        weightLayoutOfTextField1.constant = 330.0f;
        
    }else if(IS_IPHONE_6){
        
        signupBG2.image = [UIImage imageNamed:@"app-bg-innar.jpg"];
        weightLayoutOfTextField.constant = 300.0f;
        weightLayoutOfTextField1.constant = 300.0f;
        
    }else if (IS_IPHONE_5){
        
        signupBG2.image = [UIImage imageNamed:@"app-bg-innar.jpg"];
        weightLayoutOfTextField.constant = 280.0f;
        weightLayoutOfTextField1.constant = 280.0f;

    }else{
        
        signupBG2.image = [UIImage imageNamed:@"app-bg-innar.jpg"];
        weightLayoutOfTextField.constant = 260.0f;
        weightLayoutOfTextField1.constant = 260.0f;

    }
}

- (IBAction)btnTnCAction:(id)sender {
    WebViewController *webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    webVC.from = @"Terms and Conditions";
    [self.navigationController pushViewController:webVC animated:YES];
    
}

//Create account
- (IBAction)btnSignUpAction:(id)sender {
    //    [self setAlertMessage:@"Success!" :@"You have successfully created account."];
    
    if (txtEmail.text.length > 0 && txtPassword.text.length > 0 && txtConfirmpassword.text.length > 0 && txtPhone.text.length > 0) {
        
        if (txtPassword.text == txtConfirmpassword.text) {
            if ([self validateEmailWithString:txtEmail.text]) {
                
                NSLog(@"%@",[self validateEmailWithString:txtEmail.text]? @"Yes" : @"No");
                [self sendSignupData];
                
            }else{
                
                NSLog(@"%@",[self validateEmailWithString:txtEmail.text]? @"Yes" : @"No");
                [self setAlertMessage:@"Error!" :@"Please enter valid email address and password."];
                
            }
        }else{
            [self setAlertMessage:@"Error!" :@"Password does not match the confirm password."];
            
        }
        
    }else{
        [self setAlertMessage:@"Empty Fields!" :@"Please fill the empty fields."];
    }
    
    
}
- (IBAction)btnSignupUserAction:(id)sender {
    
    selectedTab = @"user";
    pageUser.hidden = YES;
//    [btnSignup1 setBackgroundImage:nil forState:UIControlStateNormal];
//    [btnUser1 setBackgroundImage:[UIImage imageNamed:@"btn-active.jpg"] forState:UIControlStateNormal];
    [btnUser1 setBackgroundColor:[UIColor colorWithRed:122/255.0 green:175/255.0 blue:72/255.0 alpha:1.0]];
    [btnUser1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSignup1 setBackgroundColor:[UIColor whiteColor]];
    [btnSignup1 setTitleColor:[UIColor colorWithRed:122/255.0 green:175/255.0 blue:72/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    storeOwnerView.hidden = YES;
    storeTypeView.hidden = YES;
    [self.view endEditing:YES];
    
}
- (IBAction)btnSignupStoreOwner:(id)sender {
    
    if (IS_IPHONE_X)  {
       
         storeOwnerbtnTConstraint.constant = 88.0f;
        
    }else{
        
         storeOwnerbtnTConstraint.constant = 64.0f;
    }
    
    [btnUser1 setBackgroundColor:[UIColor whiteColor]];
    [btnUser1 setTitleColor: [UIColor colorWithRed:122/255.0 green:175/255.0 blue:72/255.0 alpha:1.0]forState:UIControlStateNormal];
    [btnSignup1 setBackgroundColor:[UIColor colorWithRed:122/255.0 green:175/255.0 blue:72/255.0 alpha:1.0]];
    [btnSignup1 setTitleColor: [UIColor whiteColor]forState:UIControlStateNormal];
    
    selectedTab = @"storeOwner";
    storeOwnerView.hidden = NO;
    //storeOwnerViewNew.hidden = NO;
    [self.view endEditing:YES];
    
}
- (IBAction)btnNextAction:(id)sender {
    pageUser.hidden = NO;
    if ([selectedTab isEqual:@"storeOwner"]) {
        if (txtStoreName.text.length > 0 && txtStoreType.text.length > 0 && txtZip.text.length && txtAddress.text.length > 0) {
            
            pageUser.hidden = NO;
            
//            [btnSignup1 setBackgroundImage:[UIImage imageNamed:@"btn-active.jpg"] forState:UIControlStateNormal];
//            [btnUser1 setBackgroundImage:nil forState:UIControlStateNormal];
//            btnUser1.backgroundColor = [UIColor colorWithRed:60/256.0 green:173/256.0 blue:139/256.0 alpha:1.0];
            
            storeOwnerView.hidden = YES;
            
        }else{
            [self setAlertMessage:@"Empty Fields!" :@"Please fill the empty fields."];
        }
        
    }else{
        //[btnSignup1 setBackgroundImage:[UIImage imageNamed:@"btn-active.jpg"] forState:UIControlStateNormal];
    }
}
- (IBAction)btnOwnerPage1:(id)sender {
    storeOwnerView.hidden = NO;
}

- (IBAction)btnImageUploadAction:(UIButton *)sender {
    
    [self addImageTapped];
    
}

-(void)addImageTapped
{
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:@"Profile Photo"
                                        message:@"Select method of input"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Gallery"
                                              style:UIAlertActionStyleDefault
                                            handler:^void (UIAlertAction *action) {
                                                NSLog(@"Clicked Gallery");
                                                [self showGallery];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Camera"
                                              style:UIAlertActionStyleDefault
                                            handler:^void (UIAlertAction *action) {
                                                NSLog(@"Clicked Camera");
                                                [self showCamera];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:^void (UIAlertAction *action) {
                                                NSLog(@"Clicked Remove Photo");
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)showCamera{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
    }
}
-(void)showGallery{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
    }
}

#pragma mark - Get Photo From Library
-(void)getPhotoFromLibrary{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

//MARK: ImagePicker Delegate Method

#pragma mark - Image Picker Delegate -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSLog(@"%@",info);
    UIImage * img = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    dummyImage.image =  img;
    pngData = [[NSData alloc] init];
    pngData = UIImagePNGRepresentation(img);
    NSData *webData = UIImagePNGRepresentation(dummyImage.image);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *localFilePath = [documentsDirectory stringByAppendingPathComponent:@","];
    [webData writeToFile:localFilePath atomically:YES];
    NSLog(@"localFilePath:%@",localFilePath);
    lblStoreImageName.text = localFilePath;
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//   [self dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:^{

        [self setParams];
    }];
    
    
}

#pragma mark - Cropper Delegate -

//- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
//{
//
//     _imageView.image = image;
//     imagedata = UIImageJPEGRepresentation(_imageView.image, 0.5);
//    // NSLog(@"image data%@",imagedata);
//    //[self layoutImageView];
//    // self.navigationItem.rightBarButtonItem.enabled = YES;
//
//    CGRect viewFrame = [self.view convertRect:_imageView.frame toView:self.navigationController.view];
//   // _imageView.hidden = YES;
//    [cropViewController dismissAnimatedFromParentViewController:self withCroppedImage:image toFrame:viewFrame completion:^{
//        //_imageView.hidden = NO;
//    }];
//    [self setParams];
//
//}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void) setParams{
    
    if(pngData != nil){
        
        request = [NSMutableURLRequest new];
        request.timeoutInterval = 20.0;
        [request setURL:[NSURL URLWithString:URL]];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [request setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
        [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/536.26.14 (KHTML, like Gecko) Version/6.0.1 Safari/536.26.14" forHTTPHeaderField:@"User-Agent"];
        
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", @"file"] dataUsingEncoding:NSUTF8StringEncoding]]; //%@.png\"\r\n
        
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[NSData dataWithData:pngData]];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [request setHTTPBody:body];
        [request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)[body length]] forHTTPHeaderField:@"Content-Length"];
        
        //========//
        
        NSError *error = nil;
        NSURLResponse *responseStr = nil;
        syncResData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseStr error:&error];
        NSString *returnString = [[NSString alloc] initWithData:syncResData encoding:NSUTF8StringEncoding];
        
        
          NSLog(@"ERROR %@", error);
          NSLog(@"RES %@", responseStr);
          NSLog(@"%@", syncResData);
        
        if(error == nil){
            
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            // response.text = returnString;
            NSLog(@"%@",returnString);
            
            NSArray *items = [returnString componentsSeparatedByString:@","];
            NSString *str1=[items objectAtIndex:0];
            //take the one array for split the string
            NSArray *items1 = [str1 componentsSeparatedByString:@"{"];
            NSString *str2=[items1 objectAtIndex:1];
            
            //take the Message String Only
            NSArray *items2 = [str2 componentsSeparatedByString:@":"];
            NSString *str3=[items2 objectAtIndex:1];

            NSLog(@"%@",str1);
            NSLog(@"%@",str2);
            NSLog(@"%@",str3);
            
            //Remove String Double Coutetion "".....
            NSCharacterSet *quoteCharset = [NSCharacterSet characterSetWithCharactersInString:@"\""];
            NSString *trimmedString = [str3 stringByTrimmingCharactersInSet:quoteCharset];
            
            NSLog(@"%@",trimmedString);

            uploadImageStr = trimmedString;
            NSLog(@"%@",uploadImageStr);

        }
        
        //=======//
        // return TRUE;
        
    }else{
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert .. " message:@"Image does not uploaded...,try  again.." preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
        [alertController addAction:ok];
        
        //  [HUD hideUIBlockingIndicator];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
}

-(void)sendSignupData{
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSDictionary *signupDic = [[NSDictionary alloc] init];
    if ([selectedTab isEqual:@"storeOwner"])
    {
        NSString* typeStr;
        if ([txtStoreType.text isEqual:@"Liquor"]) {
            typeStr = @"1";
        }else if ([txtStoreType.text isEqual:@"Vegan"]){
            typeStr = @"2";
        }else{
            typeStr = @"3";
        }
        
        if ([uploadImageStr isEqualToString:@""]){
            
            uploadImageStr = @"";
        }else{
            
            NSLog(@"%@",uploadImageStr);
        }
        
        if (txtStoreName.text.length > 0 && txtStoreType.text.length > 0 && txtZip.text.length > 0 && txtStoreDesc.text.length > 0) {
            
            signupDic = @{@"actiontype":@"signup_store",
                          @"fullname":txtFullname.text,
                          @"email":txtEmail.text,
                          @"phonenumber":txtPhone.text,
                          @"password":txtPassword.text,
                          @"store_name":txtStoreName.text,
                          @"store_type":typeStr,
                          @"address":txtAddress.text,
                          @"country":txtCountry.text,
                          @"city":txtCity.text,
                          @"zip":txtZip.text,
                          @"image":uploadImageStr,
                          @"description":txtStoreDesc.text,
                          };
           
        }else{
            [self setAlertMessage:@"Empty Fields!" :@"Please fill the empty fields."];
        }
        
    }else{
        
        signupDic = @{@"actiontype":@"signup",
                      @"fullname":txtFullname.text,
                      @"email":txtEmail.text,
                      @"phonenumber":txtPhone.text,
                      @"password":txtPassword.text,
                      @"address":@"",
                      };
    }
    
    NSLog(@"%@",signupDic);
    [_dataFetch requestURL:KBaseUrl method:@"POST" dic:signupDic from:@"sendSignupData" type:@"json"];
    
}


#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return storeTypeArray.count;
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
        cell.textLabel.font  = [ UIFont fontWithName: @"Arial" size: 14.0 ];
    }else{
        cell.textLabel.font  = [ UIFont fontWithName: @"Arial" size: 12.0 ];
    }
    [cell.textLabel setText:[storeTypeArray objectAtIndex:indexPath.row]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    txtStoreType.text = [storeTypeArray objectAtIndex:indexPath.row];
    storeTypeView.hidden = YES;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPAD) {
        return 60;
        
    }else{
        return 40;
    }
}

#pragma mark - Touches Began
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [storeTypeView setHidden:YES];
    //    [storeTypeView setHidden:NO];
    
}

#pragma mark  UITextfield Delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField.tag == 99)
    {
        [self.view endEditing:YES];
        [textField resignFirstResponder];
        [storeTypeView setHidden:NO];
        
    }else if (textField.tag == 100 || textField.tag == 101) {
        
        [self.view setFrame:CGRectMake(0,-190,self.view.frame.size.width,self.view.frame.size.height)];
    }
    
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [storeTypeTable setContentOffset:CGPointZero animated:YES];
    
    if (textField.tag == 99)
    {
        storeTypeView.hidden = NO;
        storeTypeView.frame = CGRectMake(txtStoreType.frame.origin.x, txtStoreType.frame.origin.y+txtStoreType.frame.size.height+2, txtStoreType.frame.size.width, [self autocompleteViewHeight]);
//        storeTypeView.frame = CGRectMake(storeOwnerView.frame.size.width/2, storeOwnerView.frame.size.height/2, txtStoreType.frame.size.width, [self autocompleteViewHeight]);
        [storeOwnerView addSubview:storeTypeView];
        [self setShadowToAutocompleteView];
    }
    
    return YES;
    
}

-(void)setShadowToAutocompleteView{
    
    storeTypeView.layer.masksToBounds = NO;
    storeTypeView.layer.shadowOffset = CGSizeMake(1, 2);
    storeTypeView.layer.cornerRadius = 10.0f;
    storeTypeView.layer.shadowRadius = 5.0f;
    storeTypeView.layer.shadowOpacity = 0.5;
}

-(NSUInteger)autocompleteViewHeight{
    
    NSUInteger height = 0;
    if (IS_IPAD) {
        NSLog(@"%lu",(unsigned long)60*storeTypeArray.count);
        
        return height = 60*storeTypeArray.count;
    }else{
        return height = 40*storeTypeArray.count;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Process Successful
- (void) processSuccessful :(NSDictionary *)data1 :(NSString *)JsonFor{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
    NSLog(@"%@",data1);
    if ([JsonFor isEqual:@"sendSignupData"]) {
        NSLog(@"%@",data1);
        if ([[data1 objectForKey:@"status"] isEqual:@"yes"]) {
            
            [self setSignupAlert:@"Success!" :@"You have successfully created account."];
            
            [[NSUserDefaults standardUserDefaults] setObject:[data1 objectForKey:@"data"] forKey:@"loginDetails"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }else{
            [self setAlertMessage:@"Error!" :@"Email Id already exists."];
        }
        
    }
    
}

-(void)setSignupAlert :(NSString *)titel :(NSString *)message{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:titel
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              //                                                              NSLog(@"Hi");
                                                              if ([selectedTab isEqual:@"storeOwner"]) {
                                                                  StoreOwnerOrderViewController *ownerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StoreOwnerOrderViewController"];
                                                                  [self.navigationController pushViewController:ownerVC animated:YES];
                                                                  
                                                                  
                                                              }else{
                                                                  [self.navigationController popToRootViewControllerAnimated:YES];
                                                              }
                                                          }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Process Not Successful

-(void)processNotSucessful:(NSString *)string{
    
}


@end
