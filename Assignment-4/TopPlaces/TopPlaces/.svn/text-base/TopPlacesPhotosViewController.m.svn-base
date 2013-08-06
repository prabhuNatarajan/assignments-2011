//
//  TopPlacesPhotosViewController.m
//  TopPlaces
//
//  Created by Apple on 04/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "TopPlacesPhotosViewController.h"
#import "FlickrFetcher.h"

@interface TopPlacesPhotosViewController () <UIScrollViewDelegate> //setup zooming
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation TopPlacesPhotosViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //spinner when downloading photo
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];    
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
    dispatch_async(downloadQueue, ^{
        //load the image from url
        NSURL *url = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.rightBarButtonItem = nil;
            _imageView = [[UIImageView alloc] initWithImage:image];
            [self.scrollView addSubview:_imageView];
            _imageView.image = image;
            //setup scroll
            self.scrollView.contentSize = self.imageView.bounds.size;
            self.scrollView.delegate = self;
            //setup zooming.
            self.scrollView.minimumZoomScale=MIN(self.scrollView.bounds.size.width/self.imageView.image.size.width, self.scrollView.bounds.size.height/self.imageView.image.size.height);
            self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
            //set the photo title on navigation bar
            NSString *title = [self.photo objectForKey:FLICKR_PHOTO_TITLE];
            if (![title isEqualToString:@""])
            {
                self.title = title;
            }else
            {
                self.title = @"Unknown";
            }
        });
    });
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self setScrollView:nil];
    [self setImageView:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end