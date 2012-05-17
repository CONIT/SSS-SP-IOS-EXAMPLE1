
#import <UIKit/UIKit.h>

@interface SPHTMLViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *htmlFilePath;

@end
