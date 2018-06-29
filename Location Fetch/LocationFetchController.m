//
//  LocationFetchController.m
//  citiRun
//
//  Created by @vi on 21/06/18.
//  Copyright © 2018 Basir. All rights reserved.
//

#import "LocationFetchController.h"
#import <coreLocation/CoreLocation.h>

@interface LocationFetchController()<CLLocationManagerDelegate>{
    
    CLLocationManager *locationManager;
    
}

@end

@implementation LocationFetchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    
    [self getCurrentLocation];
    
}

- (void)getCurrentLocation{
    CLLocationCoordinate2D coordinate = [self getLocation];
    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    //    LatLong = [NSString stringWithFormat:@"(%@,%@)",latitude,longitude];
    NSLog(@"Latitude  = %@", latitude);
    NSLog(@"Longitude = %@", longitude);
    //    [self GetCurrentAddressDetails:coordinate.latitude :coordinate.longitude];
    //[self ShowCurrentAddressDetails:coordinate.latitude :coordinate.longitude];
    
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

//Location Manager delegates

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    [self getCurrentLocation];
    [locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
