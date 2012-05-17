
#import <Foundation/Foundation.h>

@protocol ProductListDelegate
-(void)finishProductListAPI:(NSData*)jsonData;
-(void)finishProductListAPIWithError:(NSError*)error;
@end

@interface SPProductListApiConnect : NSObject{
    NSMutableData* downloadData;
    id<ProductListDelegate> productlistDelegate;
    NSURLConnection* connection;
}
-(void)getProductList:(id<ProductListDelegate>)delegate;
@end
