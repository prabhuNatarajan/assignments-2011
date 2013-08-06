//
//  MapPlacesPhotosViewController.m
//  MapPlaces
//
//  Created by Apple on 04/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "MapPlacesPhotosViewController.h"
#import "FlickrFetcher.h"
#import "PhotoCache.h"
#import "MapPlacesRecentPlaces.h"

@interface MapPlacesPhotosViewController () <UIScrollViewDelegate> //setup zooming
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation MapPlacesPhotosViewController

- (void)setPhoto:(NSDictionary *)photo
{
    _photo = photo;
    self.scrollView.zoomScale = 1.0f; //ipad reset zoomScale because the detailView always on screen so it's not reset as iphone.
    if ([self isViewLoaded] == YES){
        [self updateDisplay];
    }
}

- (BOOL)isViewLoaded
{
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)updateDisplay
{
    //spinner when downloading
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]init ];
    activityIndicator.frame = CGRectMake(self.view.frame.size.width/2 - activityIndicator.frame.size.width/2, self.view.frame.size.height/2 - activityIndicator.frame.size.height/2, activityIndicator.frame.size.width, activityIndicator.frame.size.height);
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    [self viewWillAppear];//for whiteScreen at the time of Loading photos
    //load the image from url
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
    dispatch_async(downloadQueue, ^{
        //check cache
        NSURL *url;
        NSString *urlString;
        NSData *imageData;        
        PhotoCache *flickrPhotoCache = [[PhotoCache alloc]init];
        [flickrPhotoCache retrievePhotoCache];
        
        if ([flickrPhotoCache isInCache:self.photo])
        {
            urlString = [flickrPhotoCache readImageFromCache:self.photo];//photo is in cache
            imageData = [NSData dataWithContentsOfFile:urlString];
            NSLog(@"load image from cache: %@",urlString);
        }else {
            url = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge]; //photo is not in cache
            NSLog(@"downloaded from url: %@",url);
            imageData = [NSData dataWithContentsOfURL:url];
            }
        
        //load the image from url
        UIImage *image = [UIImage imageWithData:imageData];
        //NSLog(@"image id to cache is %@",[self.photo objectForKey:FLICKR_PHOTO_ID]);
        [flickrPhotoCache writeImageToCache:image forPhoto:self.photo fromUrl:url]; //update photo cache
        dispatch_async(dispatch_get_main_queue(), ^{
            [activityIndicator stopAnimating];
            _imageView = [[UIImageView alloc] initWithImage:image];
            [self.scrollView addSubview:_imageView];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateDisplay];
}
- (void)viewWillAppear
{
    self.imageView.image=nil;
    [super viewWillAppear:YES];    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.splitViewController.delegate = self; //if put in viewDidLoad, delegate will be too late to assign, no button first launch
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
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

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsPortrait(orientation);
}


- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    //put the button up
    barButtonItem.title = @"Photo List";
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    //take the button away
    self.navigationItem.leftBarButtonItem = nil;
}

@end