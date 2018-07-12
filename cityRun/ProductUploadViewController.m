//
//  ProductUploadViewController.m
//  citiRun
//
//  Created by Basir Alam on 19/04/17.
//  Copyright © 2017 Basir. All rights reserved.
//

#import "ProductUploadViewController.h"
#import "AddQtyTableViewCell.h"
#import "TOCropViewController.h"

#import "AFNetworking.h"
#import "UIView+Toast.h"


@interface ProductUploadViewController ()<VSDropdownDelegate,ProcessDataDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,TOCropViewControllerDelegate,UITextFieldDelegate>
{
    IBOutlet NSLayoutConstraint *imgUploadTopLayout;
    IBOutlet NSLayoutConstraint *textFieldWidthLayout;
    IBOutlet NSLayoutConstraint *btnUploadHeightLayout;
    IBOutlet NSLayoutConstraint *btnUploadWidthLayout;
    //Property of textFields
    IBOutlet ACFloatingTextFieldOriginal *txtProductName;
    IBOutlet ACFloatingTextFieldOriginal *txtCategory;
    IBOutlet ACFloatingTextFieldOriginal *txtSubCategory;
    IBOutlet SAMTextView *txtVwProductDetails;
    IBOutlet ACFloatingTextFieldOriginal *txtQuantity;
    IBOutlet ACFloatingTextFieldOriginal *txtPrice;
    
    NSMutableArray* qtyArray;
    NSMutableArray* priceArray;
    
    IBOutlet UITableView *qtyTableView;
    VSDropdown* _dropDown;
    NSMutableArray* listArray; //for temp basis
    IBOutlet UIButton *btnShowMenu;
    IBOutlet UIImageView *bulkUploadBG;
    IBOutlet UIView *bulkUploadView;
    
    IBOutlet UIButton *btnAddProduct1;
    IBOutlet UIButton *btnAddBulkProduct1;
    IBOutlet UIButton *btnAddProduct2;
    IBOutlet UIButton *btnAddBulkProduct2;
    NSString* picStr,*uploadImageStr;
    NSString *path;
    UIImage *chosenImage;
    IBOutlet UIImageView *pickedImageView;
    
    IBOutlet UIImageView *product_Image;
    
    NSData *imagedata;
    DataFetch *_dataFetch;
    BOOL isReload;
    
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

@implementation ProductUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Add Product";
    
    txtCategory.delegate = self;
    txtSubCategory.delegate = self;
    txtQuantity.delegate = self;
    txtPrice.delegate = self;
    
    _dataFetch = [[DataFetch alloc]init];
    _dataFetch.delegate = self;
    
    picStr = @"";
    [self navigationColorSet];
    [self BackbuttonSet];
    [self setConstantsAndFonts];
    [self allocationOfObjects];
    //    [self setVSDropDown];
    [self setBulkUploadView];
    
}
#pragma mark NavigationColor Set

-(void)navigationColorSet{
    
    self.navigationItem.hidesBackButton = YES;
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:122/255.0 green:175/255.0 blue:72/255.0 alpha:1.0];
}

-(void)setBulkUploadView{
    [bulkUploadView setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    [self.view addSubview:bulkUploadView];
    bulkUploadView.hidden = YES;
    
}
//-(void)setVSDropDown{
//    //    spotNo = 1;
//    _dropDown = [[VSDropdown alloc]initWithDelegate:self];
//    [_dropDown setAdoptParentTheme:YES];
//    [_dropDown setShouldSortItems:YES];
//    listArray = [[NSMutableArray alloc]init];
//    for (int i = 1; i<= 10; i++) {
//        [listArray addObject:[NSString stringWithFormat:@"%dml",10*i]];
//    }
//    NSLog(@"%@",listArray);
//
//}
#pragma mark - Set Constants And Fonts
-(void)allocationOfObjects{
    qtyArray = [[NSMutableArray alloc]initWithObjects:@"", nil];
    priceArray = [[NSMutableArray alloc]initWithObjects:@"", nil];
    
    //    Allocation of VSDropDown
    _dropDown = [[VSDropdown alloc]initWithDelegate:self];
    [_dropDown setAdoptParentTheme:YES];
    [_dropDown setShouldSortItems:YES];
    
}

#pragma mark - Set Constants And Fonts
-(void)setConstantsAndFonts
{
    txtVwProductDetails.placeholder = @"Product Description";
    txtVwProductDetails.layer.borderWidth = 1.0f;
    txtVwProductDetails.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    if (IS_IPAD) {
        imgUploadTopLayout.constant = 150.0f;
        textFieldWidthLayout.constant = 400.0f;
        bulkUploadBG.image = [UIImage imageNamed:@"tab-bg.jpg"];
        
    }else{
        bulkUploadBG.image = [UIImage imageNamed:@"tab-bg.jpg"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Add Cell Action

- (IBAction)btnAddCellAction:(id)sender {
    [self addNewCell];
}

#pragma mark - Add Cell Action
- (void)addNewCell{
    
    NSLog(@"%@",qtyArray);
    
    [qtyTableView beginUpdates];
    
    [qtyArray addObject:@""];
    [priceArray addObject:@""];
    
    NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:[qtyArray count]-1 inSection:0]];
    [qtyTableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationTop];
    
    [qtyTableView endUpdates];
    
    
}

#pragma mark - TableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return qtyArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    if (tableView == slideMenuTable) {
    
    AddQtyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddQtyTableViewCell" forIndexPath:indexPath];
    cell.backgroundColor = cell.contentView.backgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.txtQty.delegate = self;
    cell.txtPrice.delegate = self;
    if (isReload) {
            cell.txtQty.text = @"";
            cell.txtPrice.text = @"";
        isReload = NO;
    }else{
        isReload = NO;
    }
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [qtyArray removeObjectAtIndex:indexPath.row];
    [priceArray removeObjectAtIndex:indexPath.row];
 
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
    [qtyTableView reloadData];
    
    if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        
    }
}

*/

#pragma mark-
#pragma mark- TextField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==5) {
        
        [self.view setFrame:CGRectMake(0,-170,self.view.frame.size.width,self.view.frame.size.height)];
        
    }else if (textField.tag==6){
        
        [self.view setFrame:CGRectMake(0,-190,self.view.frame.size.width,self.view.frame.size.height)];
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    UITableViewCell *textFieldRowCell;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        textFieldRowCell = (UITableViewCell *) textField.superview.superview;
        
    }
    else if([[[UIDevice currentDevice] systemVersion]intValue] <8) {
        // Load resources for iOS 7 or later
        textFieldRowCell = (UITableViewCell *) textField.superview.superview.superview;
        
        // TextField -> UITableVieCellContentView -> (in iOS 7!)ScrollView -> Whoola!
    }
    else
    {
        textFieldRowCell = (UITableViewCell *) textField.superview.superview;
    }
    
    NSIndexPath *indexPath = [qtyTableView indexPathForCell:textFieldRowCell];
    
    NSLog(@"Index==>%ld",(long)indexPath.row);
    NSLog(@"%ld",(long)textField.tag);
    //    NSLog(@"%@",textField.superview.superview.superview);
    
    
    [textField resignFirstResponder];
    [self.view endEditing:YES];
    
    if (textField.tag==5) {
        [qtyArray replaceObjectAtIndex:indexPath.row withObject:textField.text];
    }else if (textField.tag==6){
        [priceArray replaceObjectAtIndex:indexPath.row withObject:textField.text];
    }
    
    NSLog(@"%@",qtyArray);
    NSLog(@"%@",priceArray);
    
}

#pragma mark - Touches Began
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    [self.view endEditing:YES];
}




#pragma mark -
#pragma mark - VSDropdown Delegate methods.
- (void)showArrayList:(UIButton *)sender {
    NSLog(@"%@",listArray);
    [self showDropDownForButton:sender adContents:listArray multipleSelection:NO];
}

-(void)showDropDownForButton:(UIButton *)sender adContents:(NSArray *)contents multipleSelection:(BOOL)multipleSelection
{
    NSLog(@"%@",sender);
    [_dropDown setAllowMultipleSelection:multipleSelection];
    [_dropDown setupDropdownForView:sender];
    [_dropDown setSeparatorColor:sender.titleLabel.textColor];
    if (_dropDown.allowMultipleSelection)
    {
        NSLog(@"%@",[[listArray objectAtIndex:sender.tag] componentsSeparatedByString:@","]);
        [_dropDown reloadDropdownWithContents:contents andSelectedItems:[[listArray objectAtIndex:sender.tag] componentsSeparatedByString:@","]];
    }
    else
    {
        [_dropDown reloadDropdownWithContents:contents andSelectedItems:@[[sender titleForState:UIControlStateNormal]]];
    }
}

- (void)dropdown:(VSDropdown *)dropDown didChangeSelectionForValue:(NSString *)str atIndex:(NSUInteger)index selected:(BOOL)selected
{
    NSLog(@"%lu",(unsigned long)index);
    
    btnShowMenu = (UIButton *)dropDown.dropDownView;
    NSString *allSelectedItems = 0;
    if (dropDown.selectedItems.count>1)
    {
        allSelectedItems = [dropDown.selectedItems componentsJoinedByString:@","];
        
        if ([allSelectedItems hasPrefix:@","]) {
            
            allSelectedItems = [allSelectedItems substringFromIndex:1];
            
        }
    }
    else
    {
        allSelectedItems = [dropDown.selectedItems firstObject];
    }
    
    if (allSelectedItems.length == 0) {
        allSelectedItems = @"";
    }
    
    [btnShowMenu setTitle:allSelectedItems forState:UIControlStateNormal];
    
}

- (UIColor *)outlineColorForDropdown:(VSDropdown *)dropdown
{
    UIButton *btn = (UIButton *)dropdown.dropDownView;
    
    return btn.titleLabel.textColor;
    
}

- (CGFloat)outlineWidthForDropdown:(VSDropdown *)dropdown
{
    return 2.0;
}

- (CGFloat)cornerRadiusForDropdown:(VSDropdown *)dropdown
{
    return 3.0;
}

- (CGFloat)offsetForDropdown:(VSDropdown *)dropdown
{
    return -2.0;
}
- (IBAction)btnAddProductAction:(id)sender {
    //    bulkUploadView.hidden = YES;
    [self addProductDetails];
}
- (IBAction)btnAddBulkProductAction:(id)sender {
    bulkUploadView.hidden = NO;
}

- (IBAction)btnUploadImageAction:(id)sender {
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
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
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


#pragma mark - upload manager setup

-(void)uploadManagerSetup{
    
    //    self.uploadManager = [[UploadManager alloc]init];
}

#pragma mark -upload manager delegate

-(void)uploadStatus :(NSString *)status :(long)persentage{
    
    //    DLog(@"delegate :%@",status);
    //    DLog(@"delegate :%ld",persentage);
    
    
}

#pragma mark - Image Picker Delegate -

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSLog(@"%@",info);
    UIImage * img = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    product_Image.image =  img;
    pngData = [[NSData alloc] init];
    pngData = UIImagePNGRepresentation(product_Image.image);
    [self layoutImageView];
    NSData *webData = UIImagePNGRepresentation(product_Image.image);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *localFilePath = [documentsDirectory stringByAppendingPathComponent:@","];
    [webData writeToFile:localFilePath atomically:YES];
    NSLog(@"localFilePath.%@",localFilePath);
   // lblStoreImageName.text = localFilePath;
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    //      [self dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:^{
        
        [self uploadImage];
    }];
}

#pragma mark - Cropper Delegate -
//- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
//{
//
//    product_Image.image = image;
//    imagedata = UIImageJPEGRepresentation(product_Image.image, 0.5);
//    // NSLog(@"image data%@",imagedata);
//
//    [self layoutImageView];
//
//    // self.navigationItem.rightBarButtonItem.enabled = YES;
//
//    CGRect viewFrame = [self.view convertRect:product_Image.frame toView:self.navigationController.view];
//    product_Image.hidden = YES;
//    [cropViewController dismissAnimatedFromParentViewController:self withCroppedImage:image toFrame:viewFrame completion:^{
//        product_Image.hidden = NO;
//    }];
//    [self uploadImage];
//
//}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)layoutImageView
{
    if (self.imageView.image == nil)
        return;
    
    CGFloat padding = 20.0f;
    
    CGRect viewFrame = self.view.frame;
    viewFrame.size.width -= (padding * 2.0f);
    viewFrame.size.height -= ((padding * 2.0f));
    
    CGRect imageFrame = CGRectZero;
    imageFrame.size = self.imageView.image.size;
    
    CGFloat scale = MIN(viewFrame.size.width / imageFrame.size.width, viewFrame.size.height / imageFrame.size.height);
    imageFrame.size.width *= scale;
    imageFrame.size.height *= scale;
    imageFrame.origin.x = (CGRectGetWidth(self.view.bounds) - imageFrame.size.width) * 0.5f;
    imageFrame.origin.y = (CGRectGetHeight(self.view.bounds) - imageFrame.size.height) * 0.5f;
    self.imageView.frame = imageFrame;
    
    
}

-(void)uploadImage
{
    
    
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
        
        //========
        
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
            
            picStr = trimmedString;
            NSLog(@"%@",picStr);
            
            
        }
        
        //=======
        // return TRUE;
        
    }else{
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert .. " message:@"Image does not uploaded...,try  again.." preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
        [alertController addAction:ok];
        
        //        [HUD hideUIBlockingIndicator];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
}

-(void)addProductDetails{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSString * resultQty = [[qtyArray valueForKey:@"description"] componentsJoinedByString:@","];
    NSLog(@"%@",resultQty);

    NSString * resultPrice = [[priceArray valueForKey:@"description"] componentsJoinedByString:@","];
    NSLog(@"%@",resultPrice);

    NSDictionary *productDic = @{@"actiontype":@"addproduct",
                                 @"productname":txtProductName.text,
                                 @"imagename":picStr,
                                 @"description":txtVwProductDetails.text,
                                 @"category":txtCategory.text,
                                 @"subcategory":txtSubCategory.text,
                                 @"quantity":txtQuantity.text,
                                 @"price":txtPrice.text,
                                 @"user_id":[[[NSUserDefaults standardUserDefaults] valueForKey:@"loginDetails"] valueForKey:@"user_id"]
                                 };
    NSLog(@"%@",productDic);
    [_dataFetch requestURL:KBaseUrl method:@"POST" dic:productDic from:@"addProductDetails" type:@"json"];
    
}

#pragma mark - Process Successful
- (void) processSuccessful :(NSDictionary *)data1 :(NSString *)JsonFor{
    NSLog(@"%@",data1);
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    if ([[data1 objectForKey:@"success"] isEqual:@"yes"]) {
        
        [self setAlertMessage:@"Success!" :@"You have successfully added the product."];
        txtProductName.text = nil;
        picStr = @"";
        txtVwProductDetails.text = nil;
        txtCategory.text = nil;
        txtSubCategory.text = nil;
        product_Image.image = [UIImage imageNamed:@"add-product-icon.png"];
        txtPrice.text = nil;
        txtQuantity.text = nil;
//        [qtyArray removeAllObjects];
//        [priceArray removeAllObjects];
//        
//        [qtyArray addObject:@""];
//        [priceArray addObject:@""];
        
        isReload = YES;
        [qtyTableView reloadData];
        
    }else{
        
        [self setAlertMessage:@"Error!" :@"Something went wrong. Please try again."];
    }
    
}

-(void)processNotSucessful:(NSString *)string{
    [self setAlertMessage:@"Error!" :@"Something went wrong. Please try again."];
}

@end
