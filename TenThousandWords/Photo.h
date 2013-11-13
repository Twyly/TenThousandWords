//
//  Photo.h
//  TenThousandWords
//
//  Created by Teddy Wyly on 11/4/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Album;

@interface Photo : NSManagedObject

@property (nonatomic, retain) id image;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Album *albumBook;

@end
