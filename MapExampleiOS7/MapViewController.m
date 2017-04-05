//
//  MapViewController.m
//  MapExampleiOS7
//


#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "CustomAnnotation.h"
#import "PlaceDetailViewViewController.h"

#define AllTrim(string) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

@interface MapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView      *mapView;

@property (nonatomic, strong) CustomAnnotation      *fixAnnotation;
@property (nonatomic, strong) UIImageView           *annotationImage;

@end

@implementation MapViewController

//---------------------------------------------------------------

#pragma mark
#pragma mark Memory management methods

//---------------------------------------------------------------

- (void) dealloc  {
    [self.mapView removeFromSuperview]; // release crashes app
    self.mapView = nil;
}

//---------------------------------------------------------------

#pragma mark
#pragma mark Custom methods

//---------------------------------------------------------------

- (void) showUserLocation {
    [UIView animateWithDuration:1.5 animations:^{
        MKCoordinateSpan span;
        span.latitudeDelta  = 1;
        span.longitudeDelta = 1;
        
        MKCoordinateRegion region;
        region.span = span;
        region.center = self.mapView.userLocation.coordinate;
        [self.mapView setRegion:region animated:YES];
    }];
}

//---------------------------------------------------------------

- (void)addBounceAnnimationToView:(UIView *)view {
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    bounceAnimation.values = @[@(0.05), @(1.1), @(0.9), @(1)];
    
    bounceAnimation.duration = 0.6;
    NSMutableArray *timingFunctions = [[NSMutableArray alloc] initWithCapacity:bounceAnimation.values.count];
    for (NSUInteger i = 0; i < bounceAnimation.values.count; i++) {
        [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    }
    [bounceAnimation setTimingFunctions:timingFunctions.copy];
    bounceAnimation.removedOnCompletion = NO;
    
    [view.layer addAnimation:bounceAnimation forKey:@"bounce"];
}

//---------------------------------------------------------------

#pragma mark
#pragma mark MKMapView delegate methods

//---------------------------------------------------------------

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    for (UIView *view in views) {
        [self addBounceAnnimationToView:view];
    }
}

//---------------------------------------------------------------

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
   
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    if ([annotation isKindOfClass:[CustomAnnotation class]]) {
        CustomAnnotation *customAnnotation = (CustomAnnotation *) annotation;
        
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        
        if (annotationView == nil)
            annotationView = customAnnotation.annotationView;
        else
            annotationView.annotation = annotation;
        [self addBounceAnnimationToView:annotationView];

        return annotationView;
    } else
        return nil;
}

//---------------------------------------------------------------

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    NSLog(@"Region will changed...");
    [self.mapView removeAnnotation:self.fixAnnotation];
    [self.mapView addSubview:self.annotationImage];

}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"Region did changed...");
    [self.annotationImage removeFromSuperview];
    CLLocationCoordinate2D centre = [mapView centerCoordinate];
    self.fixAnnotation.coordinate = centre;
    [self.mapView addAnnotation:self.fixAnnotation];
}

//---------------------------------------------------------------

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self showUserLocation];
}

//---------------------------------------------------------------

#pragma mark
#pragma mark View lifeCycle methods

//---------------------------------------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mapView setDelegate:self];
    [self.mapView setShowsUserLocation:YES];
    
    [self performSelector:@selector(showUserLocation) withObject:nil afterDelay:0.5];
    
    // Fix annotation
    _fixAnnotation = [[CustomAnnotation alloc] initWithTitle:@"Fix annotation" subTitle:@"Location" detailURL:nil location:self.mapView.userLocation.coordinate];
    [self.mapView addAnnotation:self.fixAnnotation];
    
    // Annotation image.
    CGFloat width = 64;
    CGFloat height = 64;
    CGFloat margiX = self.mapView.center.x - (width / 2);
    CGFloat margiY = self.mapView.center.y - (height / 2) - 32;
    // 32 is half size for navigationbar and status bar height to set exact location for image.
    
    _annotationImage = [[UIImageView alloc] initWithFrame:CGRectMake(margiX, margiY, width, height)];
    [self.annotationImage setImage:[UIImage imageNamed:@"mapannotation.png"]];
    
}

//---------------------------------------------------------------

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.mapView.pitchEnabled = YES;
    [self.mapView setShowsBuildings:YES];
    
    [self mapView:self.mapView regionDidChangeAnimated:YES];
}


//---------------------------------------------------------------

@end
