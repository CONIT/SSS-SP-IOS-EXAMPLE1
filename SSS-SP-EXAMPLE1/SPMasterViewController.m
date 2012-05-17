

#import "SPMasterViewController.h"
#import "SPDetailViewController.h"
#import "SBJson.h"

@implementation SPMasterViewController

@synthesize detailViewController = _detailViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"書籍リスト";
        splistdata = nil;
    }
    return self;
}
							

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [loadingviewRef setHidden:YES];
    [self.view addSubview:loadingviewRef];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(splistdata == nil){
        [self loadSPProductList];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (splistdata!=nil)?[splistdata count]:0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont fontWithName:@"monoscape" size:12];
    }

    // Configure the cell.
    NSDictionary* rowData = [splistdata objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@) %@",
                           [rowData objectForKey:@"title"],
                           [rowData objectForKey:@"outline"],
                           ([[rowData objectForKey:@"is_free"]isEqualToString:@"0"])?@"有料":@"無料"];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.detailViewController) {
        self.detailViewController = [[SPDetailViewController alloc] initWithNibName:@"SPDetailViewController" bundle:nil];
    }
    
    self.detailViewController.detailDictionary = [splistdata objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

-(IBAction)pushReloadButton:(id)sender
{
    [self loadSPProductList];
}


-(void)loadSPProductList
{
    [loadingviewRef setHidden:NO];
    
    SPProductListApiConnect* apiConnect = [[SPProductListApiConnect alloc]init];
    [apiConnect getProductList:self];
    
}

-(void)finishProductListAPI:(NSData*)jsonData
{

    NSDictionary* resultDictionary = [jsonData JSONValue];
    if([resultDictionary objectForKey:@"error_info"] != nil)
    {
        //error
        [self showAlertWithTitle:@"エラー" message:@"APIエラーが発生しました"];
        NSLog(@"productlist error %@",[resultDictionary objectForKey:@"error_info"]);
        
    }else{
        
        NSLog(@"productlist successful %@",resultDictionary);
        splistdata = [resultDictionary objectForKey:@"products"];
        [mainTableViewRef reloadData];
    }

    [loadingviewRef setHidden:YES];
}
-(void)finishProductListAPIWithError:(NSError*)error
{
    NSLog(@"productlist error %@",[error localizedDescription]);
    [self showAlertWithTitle:@"エラー" message:@"通信エラーが発生しました。電波の良いところで再実行してください"];

    [loadingviewRef setHidden:YES];
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
