//
//  MainViewController.m
//  googleMapApi
//
//  Created by Dan Kim on 4/25/17.
//  Copyright © 2017 Dan Kim. All rights reserved.
//

#import "MainViewController.h"
#import "AutoCompleteViewController.h"
@import GooglePlaces;

@interface MainViewController ()
@property (nonatomic, strong) GMSPlace *markResult;
@property (nonatomic, strong) NSMutableArray *likelihood;
@end

@implementation MainViewController{
    CLLocationManager *manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    manager = [[CLLocationManager alloc]init];
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    [manager requestAlwaysAuthorization];
    [manager startUpdatingLocation];
    mapView.accessibilityElementsHidden = NO;
    mapView.myLocationEnabled = YES;
    NSLog(@"my location: %@", mapView.myLocation);
}

- (void)viewWillAppear:(BOOL)animated {
    [self setMarker:self.markResult];
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

- (void)setMarker:(GMSPlace *)result {
    if (!result) {
        GMSCameraPosition *position = [GMSCameraPosition cameraWithLatitude:37.526402 longitude:127.030577 zoom:15];
        mapView = [GMSMapView mapWithFrame:self.mapContainer.frame camera:position];
        [self.view addSubview:mapView];
    } else {
        GMSCameraPosition *position = [GMSCameraPosition cameraWithLatitude:result.coordinate.latitude longitude:result.coordinate.longitude zoom:15];
        mapView = [GMSMapView mapWithFrame:self.mapContainer.frame camera:position];
        [self.view addSubview:mapView];
        
        GMSMarker *marker = [[GMSMarker alloc]init];
        marker.position = CLLocationCoordinate2DMake(result.coordinate.latitude, result.coordinate.longitude);
        marker.title = result.name;
        marker.snippet = result.formattedAddress;
        marker.map = mapView;
    }
}

- (IBAction)SearchAction:(id)sender {
    AutoCompleteViewController *controller = [[AutoCompleteViewController alloc]init];
    [controller setLocationHandler:^(NSString *locationId) {
        GMSPlacesClient *placeClient = [GMSPlacesClient sharedClient];
        [placeClient lookUpPlaceID:locationId callback:^(GMSPlace * _Nullable result, NSError * _Nullable error) {
            if (!error) {
                [self setMarker:result];
            } else {
                NSLog(@"Error2 : %@",error.localizedDescription);
            }
        }];
    }];
    [self presentViewController:controller animated:YES completion:nil];
}
@end
