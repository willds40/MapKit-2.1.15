//
//  MapPin.h
//  MapKit
//
//  Created by Will Devon-sand on 3/22/16.
//  Copyright © 2016 Will Devon-sand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapPin : NSObject <MKAnnotation>
@property(nonatomic,assign) CLLocationCoordinate2D coordinate;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *subtitle;
@property(nonatomic)NSString *image;
@property(nonatomic)NSString *webLink; 


@end
