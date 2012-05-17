

#import <UIKit/UIKit.h>
#import "SPProductListApiConnect.h"


@class SPDetailViewController;

@interface SPMasterViewController : UIViewController<ProductListDelegate>{
    NSArray* splistdata;
    
    IBOutlet UIView* loadingviewRef;
    IBOutlet UITableView* mainTableViewRef;
    
}
@property (strong, nonatomic) SPDetailViewController *detailViewController;

-(IBAction)pushReloadButton:(id)sender;
-(void)loadSPProductList;
-(void)showAlertWithTitle:(NSString*)title message:(NSString*)message;

@end
