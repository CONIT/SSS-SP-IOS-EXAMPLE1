
#import "SPHTMLViewController.h"

@implementation SPHTMLViewController

@synthesize webView = _webView;
@synthesize htmlFilePath = _htmlFilePath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"HTMLビュー";
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@", _htmlFilePath]];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
