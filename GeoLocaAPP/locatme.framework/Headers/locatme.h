//
//  locatme.h
//  locatme
//
//  Created by Stéphane JAIS on 22/08/16.
//  Copyright © 2016 it4pme. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for locatme.
FOUNDATION_EXPORT double locatmeVersionNumber;

//! Project version string for locatme.
FOUNDATION_EXPORT const unsigned char locatmeVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <locatme/PublicHeader.h>


typedef NS_OPTIONS(NSInteger, InitializationOption) {
    InitializationOptionDoNotRequestLocationPermission = 1 << 0,
};
