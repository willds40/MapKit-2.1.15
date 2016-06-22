//
//  MapController.h
//  MapKit
//
//  Created by Will Devon-sand on 3/22/16.
//  Copyright © 2016 Will Devon-sand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapPin.h"


#import <CoreLocation/CoreLocation.h>


@interface MapController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic,strong) CLLocationManager *locationManager;

#pragma mark - IBAction method
- (IBAction)setMap:(id)sender;
-(IBAction)close:(id)sender;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;




@end
