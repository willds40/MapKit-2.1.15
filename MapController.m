//
//  MapController.m
//  MapKit
//
//  Created by Will Devon-sand on 3/22/16.
//  Copyright © 2016 Will Devon-sand. All rights reserved.
//

#import "MapController.h"

@interface MapController ()

@end

@implementation MapController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    
    return self;
    
}



-(IBAction)setMap:(id)sender
{
    switch (((UISegmentedControl *)sender).selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.showsUserLocation = YES;
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 2.0; //user needs to press for 2 seconds
    [self.mapView addGestureRecognizer:lpgr];
        [self addAllPins];
   
    self.searchBar.delegate = self;

}


-(void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
    [theSearchBar resignFirstResponder];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:theSearchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
        [self getLocalRestuarants:theSearchBar.text];
    }];
}


-(void)getLocalRestuarants:(NSString*)restaurants{
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = restaurants;
    request.region = self.mapView.region;
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        NSLog(@"Map Items: %@", response.mapItems);
        for (int i =0; i < [response.mapItems count]; i++) {
            MapPin *myPin = [[MapPin alloc]init];
            myPin.title = [[response.mapItems objectAtIndex:i]name];
            
            myPin.coordinate = [[[response.mapItems objectAtIndex:i]placemark]coordinate];
            [self.mapView addAnnotation:myPin];

            }
}];

  
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    MKPointAnnotation *annot = [[MKPointAnnotation alloc] init];
    annot.coordinate = touchMapCoordinate;
    //    [self.mapView addAnnotation:annot];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self.locationManager stopUpdatingLocation];

}


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{

    NSLog(@"Location: %f, %f",
          userLocation.location.coordinate.latitude,
          userLocation.location.coordinate.longitude);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 250, 250);
    [self.mapView setRegion:region animated:YES];
    
   // CLLocationCoordinate2D center = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    
    CLLocationCoordinate2D center  = userLocation.location.coordinate;
    
    //set up zoom level
    MKCoordinateSpan zoom = MKCoordinateSpanMake(.1f, .1f);
    
    //the region the map will be showing
    MKCoordinateRegionMake(center, zoom);
    
    MapPin *pin = [[MapPin alloc] init];
    pin.title = @"Turn To Tech";
    pin.subtitle = @"New York City";
    pin.image = @"logo.png";
    pin.webLink= @"http://turntotech.io/";
    pin.coordinate = center;
    [mapView addAnnotation:pin];
   
    
}
-(void)addAllPins
{
    self.mapView.delegate=self;

    NSArray *name=[[NSArray alloc]initWithObjects:
                   @"FlatIron Room",
                   @"Gramercy Tavern",nil];

    NSMutableArray *arrCoordinateStr = [[NSMutableArray alloc] initWithCapacity:name.count];
    //init with capcity method improves preformance b/c it already creates the memory space.

    [arrCoordinateStr addObject:@"40.744572, -73.990455"];
    [arrCoordinateStr addObject:@"40.738427, -73.988418"];

    NSMutableArray *arrayOfImages =[[NSMutableArray alloc] initWithCapacity:name.count];

    [arrayOfImages addObject:@"flaitironRoom.jpg"];
    [arrayOfImages addObject:@"gramercyTavern.jpg"];
    
    NSMutableArray *arrayOfWebAddresses =[[NSMutableArray alloc]initWithCapacity:name.count];
    [arrayOfWebAddresses addObject:@"http://www.theflatironroom.com/"];
    [arrayOfWebAddresses addObject:@"http://www.gramercytavern.com/"];


    for(int i = 0; i < name.count; i++)
    {
        [self addPinWithTitle:name[i] AndCoordinate:arrCoordinateStr[i] AndPictures:arrayOfImages[i] AndWebLink:arrayOfWebAddresses[i]];
    }
}

-(void)addPinWithTitle:(NSString *)title AndCoordinate:(NSString *)strCoordinate AndPictures: (NSString*)picture AndWebLink: (NSString *)webLink
{
    MapPin *mapPin = [[MapPin alloc] init];


    // clear out any white space
    strCoordinate = [strCoordinate stringByReplacingOccurrencesOfString:@" " withString:@""];

    // convert string into actual latitude and longitude values
    NSArray *components = [strCoordinate componentsSeparatedByString:@","];

    double latitude = [components[0] doubleValue];
    double longitude = [components[1] doubleValue];

    // setup the map pin with all data and add to map view
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);

    mapPin.title = title;
    mapPin.coordinate = coordinate;
    mapPin.image = picture;
    mapPin.webLink = webLink;

    [self.mapView addAnnotation:mapPin];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[MapPin class]]) {
        static NSString *mapPinView = @"MapPinView";
        
        MapPin *mapPin = (MapPin*)annotation;
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:mapPinView];
        if(annotationView == nil)
        {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:mapPinView];
            
            annotationView.animatesDrop=YES;
            annotationView.canShowCallout=YES;
            
            UIImageView *leftImage =[[UIImageView alloc]initWithImage:[UIImage imageNamed:mapPin.image]];
                        annotationView.leftCalloutAccessoryView = leftImage;
            
            leftImage.frame =CGRectMake(0, 0, leftImage.frame.size.width/4, leftImage.frame.size.width/4);
            
           // leftImage.frame =CGRectMake(0, 0, 30*leftImage.image.size.width/leftImage.image.size.height,30);
            
             annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            
        }else{
            
            annotationView.annotation = mapPin;
            
        }
        return annotationView;
    }
    
    return nil;
    
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{

    
       MapPin *mapPin = (MapPin*)view.annotation;
    UIWebView *webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, mapView.frame.size.height, mapView.frame.size.height)];
    webview.tag=55;
    
    NSString *urlString = mapPin.webLink;
    NSURL *url = [[NSURL alloc] initWithString: urlString];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [webview loadRequest:requestObj];
    
    [self.mapView addSubview:webview];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(close:)
     forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"Close" forState:UIControlStateNormal];
    button.frame = CGRectMake(80, 210, 160, 40);
    [button addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [webview addSubview:button];
       }
-(IBAction)close:(id)sender {
    
    [[self.mapView viewWithTag:55] removeFromSuperview];
    
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
