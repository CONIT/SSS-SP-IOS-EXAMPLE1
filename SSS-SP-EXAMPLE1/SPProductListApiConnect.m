
#import "SPProductListApiConnect.h"
#import "SPDefines.h"

@implementation SPProductListApiConnect
-(void)getProductList:(id<ProductListDelegate>)delegate
{
    productlistDelegate = delegate;
    downloadData=nil;
    
    NSMutableString* query =[[NSMutableString alloc]init];
    [query appendString:SP_PRODUCTLIST_API];
    [query appendFormat:@"?token=%@",SP_ACCESS_TOKEN];
    [query appendString:@"&fields=title,outline,publish_date,meta&lang=ja&sortfield=product_id&sorttype=ASC"];
        
    
    NSURL* url = [[NSURL alloc]initWithString:query];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    downloadData = [[NSMutableData alloc]init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [downloadData appendData:data];
}

- (void)connection:(NSURLConnection *)connection 
  didFailWithError:(NSError *)error
{
    [productlistDelegate finishProductListAPIWithError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [productlistDelegate finishProductListAPI:downloadData];
}
@end
