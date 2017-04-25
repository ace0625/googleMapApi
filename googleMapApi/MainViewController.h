//
//  MainViewController.h
//  googleMapApi
//
//  Created by Dan Kim on 4/25/17.
//  Copyright © 2017 Dan Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMaps;

@interface MainViewController : UIViewController{
    GMSMapView *mapView;
}

@property (weak, nonatomic) IBOutlet UIView *mapContainer;
- (IBAction)SearchAction:(id)sender;
@end
