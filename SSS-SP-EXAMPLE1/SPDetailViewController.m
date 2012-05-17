
#import "SPDetailViewController.h"
#import "SPFileDownloadApiConnect.h"


@implementation SPDetailViewController

@synthesize detailAuthorLabel = _detailAuthorLabel;
@synthesize detailTitleLabel = _detailTitleLabel;
@synthesize detailDownloadButton = _detailDownloadButton;
@synthesize detailDictionary = _detailDictionary;
@synthesize loadingView = _loadingView;
@synthesize downloadProgressView = _downloadProgressView;
@synthesize htmlViewController = _htmlViewController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title =@"書籍詳細";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    _detailTitleLabel.text = [_detailDictionary objectForKey:@"title"];
    _detailAuthorLabel.text = [_detailDictionary objectForKey:@"outline"];
    if ([[_detailDictionary objectForKey:@"is_free"]isEqualToString:@"1"]) {
        [_detailDownloadButton setTitle:@"無料ダウンロード" forState:UIControlStateNormal];
    }else{
        [_detailDownloadButton setTitle:@"購入" forState:UIControlStateNormal];
    }
    _loadingView.hidden = YES;
    _downloadProgressView.progress = 0.0f;

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(IBAction)pushDownloadButton:(id)sender
{
    _loadingView.hidden = NO;
    SPFileDownloadApiConnect* downloadapi = [[SPFileDownloadApiConnect alloc]init];
    [downloadapi fileDownloadWith:[_detailDictionary objectForKey:@"product_id"]
                        delegate:self];
    
}

-(void)finishFileDownloadAPI:(NSString*)downloadFilePath
{
    NSLog(@"finishFileDownloadAPI path=%@",downloadFilePath);
    
    _loadingView.hidden = YES;
    
    if(!self.htmlViewController){
        self.htmlViewController = [[SPHTMLViewController alloc] initWithNibName:@"SPHTMLViewController" bundle:nil];

    }
    self.htmlViewController.htmlFilePath = downloadFilePath;
    [self.navigationController pushViewController:self.htmlViewController animated:YES];
    
}
-(void)progressFileDownloadAPI:(float)downloadRate
{
    NSLog(@"progressFileDownloadAPI rate=%f",downloadRate);
    _downloadProgressView.progress = downloadRate;

}
-(void)finishFileDownloadAPIWithError:(NSError*)error
{
    NSLog(@"finishFileDownloadAPIWithError error=%@",error);

    _loadingView.hidden = YES;
    [self showAlertWithTitle:@"エラー" message:@"ダウンロードエラー"];
    
}

-(void)showAlertWithTitle:(NSString*)title message:(NSString*)message
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:title
                                                   message:message
                                                  delegate:nil 
                                         cancelButtonTitle:@"閉じる"
                                         otherButtonTitles:nil];
    [alert show];
    
}

@end
