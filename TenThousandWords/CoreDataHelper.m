//
//  CoreDataHelper.m
//  TenThousandWords
//
//  Created by Teddy Wyly on 10/31/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "CoreDataHelper.h"

@implementation CoreDataHelper

+ (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

@end
