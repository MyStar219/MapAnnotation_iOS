//
//  PlaceDetailViewViewController.m
//  MapExampleiOS7


#import "PlaceDetailViewViewController.h"

@interface PlaceDetailViewViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@end

@implementation PlaceDetailViewViewController

//---------------------------------------------------------------

#pragma mark
#pragma mark Memory management methods

//---------------------------------------------------------------

- (void) dealloc  {
    [self.webView setDelegate:nil];
}

//---------------------------------------------------------------

#pragma mark
#pragma mark Action methods

//---------------------------------------------------------------


//---------------------------------------------------------------

#pragma mark
#pragma mark Custom methods

//---------------------------------------------------------------

//---------------------------------------------------------------

#pragma mark
#pragma mark  methods

//---------------------------------------------------------------

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.activityView setHidden:YES];
}

//---------------------------------------------------------------

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.activityView setHidden:YES];
}

//---------------------------------------------------------------

#pragma mark
#pragma mark View lifeCycle methods

//---------------------------------------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.webView setDelegate:self];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.loadURL];
    [self.webView loadRequest:request];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.activityView startAnimating];
}

//---------------------------------------------------------------

@end
