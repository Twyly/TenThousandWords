//
//  TWPhotoDetailViewController.m
//  TenThousandWords
//
//  Created by Teddy Wyly on 11/5/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "TWPhotoDetailViewController.h"
#import "Photo.h"
#import "TWFiltersCollectionViewController.h"

@interface TWPhotoDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation TWPhotoDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.imageView.image = self.photo.image;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addFilterButtonPressed:(UIButton *)sender
{
 
}

- (IBAction)deleteButtonPressed:(UIButton *)sender
{
    [[self.photo managedObjectContext] deleteObject:self.photo];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Filter Segue"]) {
        if ([segue.destinationViewController isKindOfClass:[TWFiltersCollectionViewController class]]) {
            TWFiltersCollectionViewController *targetViewController = segue.destinationViewController;
            targetViewController.photo = self.photo;
        }
    }
}

@end
