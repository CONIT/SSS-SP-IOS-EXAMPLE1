

#import <UIKit/UIKit.h>
#import "SPFileDownloadApiConnect.h"
#import "SPHTMLViewController.h"

@interface SPDetailViewController : UIViewController<FileDownloadDelegate>
{
}

@property (strong, nonatomic) IBOutlet UILabel *detailAuthorLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailTitleLabel;
@property (strong, nonatomic) IBOutlet UIButton *detailDownloadButton;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (strong, nonatomic) IBOutlet UIProgressView *downloadProgressView;
@property (strong, nonatomic) NSDictionary* detailDictionary;
@property (strong, nonatomic) SPHTMLViewController* htmlViewController;

-(IBAction)pushDownloadButton:(id)sender;
-(void)showAlertWithTitle:(NSString*)title message:(NSString*)message;

@end
