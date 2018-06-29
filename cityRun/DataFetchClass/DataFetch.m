//
//  DataFetch.m
//  JsonDemo
//
//  Created by MacMini3 on 2015-12-09.
//  Copyright © 2015 MacMini3. All rights reserved.
//

#import "DataFetch.h"
//#import "FTHTTPCodes.h"



@implementation DataFetch
{
    NSMutableData *_responseData;
    NSString *JsonFor;
    NSString *JsonType;
    
//    FTHTTPCodes *statusCode;
    
    NSString* storeUrl;
    NSString* storeMethod;
    NSDictionary* storeParameterDic;
    NSString* storeFrom;
    NSString* storeType;
    
    
}

-(id)init {
    self = [super init];
    return self;
}

-(void)requestURL:(NSString *)URL method:(NSString *)Method dic:(NSDictionary *)Method_Parameter from:(NSString *)From type:(NSString *)Type
{
    
//    NSLog(@"%@",URL);
//    NSLog(@"%@",Method);
//    NSLog(@"%@",Method_Parameter);
//    NSLog(@"%@",From);
//    NSLog(@"%@",Type);
    
    storeUrl = URL;
    storeMethod = Method;
    storeParameterDic = Method_Parameter;
    storeFrom = From;
    storeType = Type;
    
    
    JsonFor = From;
    JsonType = Type;
    
    NSError *error;
    
    // Create the request.
    NSString *urlString = URL;
    
    
    //This is sample webservice url. Please replace it with your own and pass your valid parameters.
    
    if ([Method isEqual:@"GET"]) {
        
        /*****************************************************************************************/
                                    //Using GET method
        /****************************************************************************************/
        
        
        
        NSURL *url = [NSURL URLWithString:urlString];
        
//        NSLog(@"%@",url);
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        
        [theRequest addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [theRequest setHTTPMethod:@"GET"];
        
        
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        if( connection )
        {
            _responseData = [[NSMutableData alloc] init];
        }

    }
    
    else
    {
        /**************************************************************************************/
        //Using POST method
        /****************************************************************************************/

        NSData *parameterData = [NSJSONSerialization dataWithJSONObject:Method_Parameter options:kNilOptions error:&error];
        
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        [theRequest setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
//        [theRequest addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [theRequest addValue: @"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];

        [theRequest setHTTPMethod:@"POST"];
        [theRequest setHTTPBody:parameterData];
        
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        if( connection )
        {
            _responseData = [[NSMutableData alloc] init];
        }
        
        /*****************************************************************************************************/
    }
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int responseStatusCode = (int)[httpResponse statusCode];
    
    NSError *error;
    
    NSLog(@"responseStatusCode: %d",responseStatusCode);
    
//    if (!error && responseStatusCode == 200) {
//    
//        _responseData = [[NSMutableData alloc] init];
//        
//        
//
//        
//    } else {
//        
////        [FTHTTPCodes descriptionForCode:responseStatusCode];
//    
////        NSLog(@"%d",responseStatusCode);
//        
//        UIAlertView *Alert = [[UIAlertView alloc]initWithTitle:@"Sydney Emergency" message:@"Server is Not Responding, Please try again later..!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        
//        [Alert show];
//        
//    }
    
   
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    
    
   
         if (connection) {
              NSError *error;
             
              
             if ([JsonType isEqual:@"json"]) {
                 
                 [[self delegate] processSuccessful:[NSJSONSerialization JSONObjectWithData:_responseData options:kNilOptions error:&error] :JsonFor];
                 
             }
             else if ([JsonType isEqual:@"string"])
             {
                 
                 NSDictionary *temp = [[NSDictionary alloc]initWithObjectsAndKeys:[[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding],@"data", nil];
                 
                 [[self delegate] processSuccessful:temp :JsonFor];
             }
             
          
         }
    
    
    
    else
    {
        /*
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Internet Connection" message:@"Check Your Internet Connection..!!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];*/
        
//        UIAlertView *Alert = [[UIAlertView alloc]initWithTitle:@"Ard Canaan Restaurant" message:@"Server is Not Responding, Please try again later..!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        
//        [Alert show];

    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"%@",error);
    NSLog(@"Error Code: %ld",(long)error.code);
    if (error)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            dispatch_group_t downloadGroup = dispatch_group_create();
            dispatch_group_enter(downloadGroup);
            dispatch_group_wait(downloadGroup, dispatch_time(DISPATCH_TIME_NOW, 2000000000)); // Wait 5 seconds before trying again.
            dispatch_group_leave(downloadGroup);
            dispatch_async(dispatch_get_main_queue(), ^{
                //Main Queue stuff here
//                [self request:storeUrl :storeMethod :storeParameterDic :storeFrom :storeType]; //Redo the function that made the Request.
                [self requestURL:storeUrl method:storeMethod dic:storeParameterDic from:storeFrom type:storeType];
                NSLog(@"call the request method once again...");
            });
        });
        
        return;
    }
    NSLog(@"end method...");
    
    [[self delegate] processNotSucessful:@"Error"];
    
        
    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Ard Canaan Restaurant" message:@"Server is Not Responding, Please try again later..!" preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
//        
////        [alertController hideHUDView];
//        
//    }];
//    [alertController addAction:ok];
//    
//    [alertController show];
    
}




@end
