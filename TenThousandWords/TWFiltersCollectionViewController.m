//
//  TWFiltersCollectionViewController.m
//  TenThousandWords
//
//  Created by Teddy Wyly on 11/5/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "TWFiltersCollectionViewController.h"
#import "TWPhotoCollectionViewCell.h"
#import "Photo.h"

@interface TWFiltersCollectionViewController ()

@property (strong, nonatomic) NSMutableArray *filters;
@property (strong, nonatomic) CIContext *context;

@end

@implementation TWFiltersCollectionViewController


- (NSMutableArray *)filters
{
    if (!_filters) _filters = [[NSMutableArray alloc] init];
    return _filters;
}

- (CIContext *)context
{
    if (!_context) _context = [CIContext contextWithOptions:nil];
    return _context;
}

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
    
    for (CIFilter *filter in [[self class] photoFilters]) {
        [self.filters addObject:filter];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


+ (NSArray *)photoFilters;
{
    CIFilter *sepia = [CIFilter filterWithName:@"CISepiaTone" keysAndValues: nil];
    CIFilter *blur = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:kCIInputRadiusKey, @1, nil];
    CIFilter *colorClamp = [CIFilter filterWithName:@"CIColorClamp" keysAndValues:@"inputMaxComponents", [CIVector vectorWithX:0.9 Y:0.9 Z:0.9 W:0.9], @"inputMinComponents", [CIVector vectorWithX:0.2 Y:0.2 Z:0.2 W:0.2], nil];
    CIFilter *instant = [CIFilter filterWithName:@"CIPhotoEffectInstant" keysAndValues: nil];
    CIFilter *noir = [CIFilter filterWithName:@"CIPhotoEffectNoir" keysAndValues: nil];
    CIFilter *vignette = [CIFilter filterWithName:@"CIVignetteEffect" keysAndValues: nil];
    CIFilter *colorControl = [CIFilter filterWithName:@"CIColorControls" keysAndValues: kCIInputSaturationKey, @0.5, nil];
    CIFilter *transfer = [CIFilter filterWithName:@"CIPhotoEffectTransfer" keysAndValues: nil];
    CIFilter *unsharpen = [CIFilter filterWithName:@"CIUnsharpMask" keysAndValues: nil];
    CIFilter *monochrome = [CIFilter filterWithName:@"CIColorMonochrome" keysAndValues: nil];
    
    NSArray *allFilters = @[sepia, blur, colorClamp, instant, noir, vignette, colorControl, transfer, unsharpen, monochrome];
    return allFilters;
    
}

- (UIImage *)filteredImageFromImage:(UIImage *)image andFilter:(CIFilter *)filter
{
    CIImage *unfilteredImage = [[CIImage alloc] initWithCGImage:image.CGImage];
    [filter setValue:unfilteredImage forKey:kCIInputImageKey];
    CIImage *filteredImage = [filter outputImage];
    
    CGRect extent = [filteredImage extent];
    CGImageRef cgImage = [self.context createCGImage:filteredImage fromRect:extent];
    UIImage *finalImage = [UIImage imageWithCGImage:cgImage];
    NSLog(@"Look at all this data: %@", UIImagePNGRepresentation(finalImage));
    
    return finalImage;
}


#pragma mark - UICollectionViewDatasource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo Cell";
    TWPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    dispatch_queue_t filterQueue = dispatch_queue_create("filter queue", NULL);
    dispatch_async(filterQueue, ^{
        UIImage *filterImage = [self filteredImageFromImage:self.photo.image andFilter:self.filters[indexPath.row]];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = filterImage;
        });
    });

    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.filters count];
    
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TWPhotoCollectionViewCell *selectedCell = (TWPhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    self.photo.image = selectedCell.imageView.image;
    
    if (self.photo.image) {
        NSError *error = nil;
        
        if (![[self.photo managedObjectContext] save:&error]) {
            // Handle Error
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

@end
