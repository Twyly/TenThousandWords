//
//  TWPhotosCollectionViewController.m
//  TenThousandWords
//
//  Created by Teddy Wyly on 10/31/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "TWPhotosCollectionViewController.h"
#import "TWPhotoCollectionViewCell.h"
#import "Photo.h"
#import "CoreDataHelper.h"
#import "TWPhotoDetailViewController.h"

@interface TWPhotosCollectionViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) NSMutableArray *photos; // Of UIImages

@end

@implementation TWPhotosCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSMutableArray *)photos
{
    if (!_photos) _photos = [[NSMutableArray alloc] init];
    return _photos;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSSet *unorderedPhotos = self.album.photos;
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    NSArray *sortedPhotos = [unorderedPhotos sortedArrayUsingDescriptors:@[dateDescriptor]];
    self.photos = [sortedPhotos mutableCopy];
    
    [self.collectionView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo Cell";
    TWPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Photo *photo = self.photos[indexPath.row];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.imageView.image = photo.image;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (IBAction)cameraButtonPressed:(UIBarButtonItem *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (Photo *)photoFromImage:(UIImage *)image
{
    Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:[CoreDataHelper managedObjectContext]];
    photo.image = image;
    photo.date = [NSDate date];
    photo.albumBook = self.album;
    
    NSError *error = nil;
    if (![[photo managedObjectContext] save:&error]) {
        // Take Care of the Error
    }
    
    return photo;
}

# pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image) image = info[UIImagePickerControllerOriginalImage];
    
    
    [self.photos addObject:[self photoFromImage:image]];
    [self.collectionView reloadData];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Detail Segue"]) {
        if ([segue.destinationViewController isKindOfClass:[TWPhotoDetailViewController class]]) {
            TWPhotoDetailViewController *targetViewController = segue.destinationViewController;
            NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] lastObject];
            Photo *selectedPhoto = self.photos[indexPath.row];
            targetViewController.photo = selectedPhoto;
        }
    }
}


@end
