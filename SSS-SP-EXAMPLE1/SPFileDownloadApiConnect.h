
#import <Foundation/Foundation.h>

@protocol FileDownloadDelegate
-(void)finishFileDownloadAPI:(NSString*)downloadFilePath;
-(void)progressFileDownloadAPI:(float)downloadRate;
-(void)finishFileDownloadAPIWithError:(NSError*)error;
@end

@interface SPFileDownloadApiConnect : NSObject
{
    NSMutableData* downloadData;
    id<FileDownloadDelegate> downloadDelegate;
    NSURLConnection* connection;
    float currentSize;
    float totalSize;
    float downloadRate;
    NSString* downloadFilePath;
}

-(void)fileDownloadWith:(NSString*)productID delegate:(id<FileDownloadDelegate>)delegate;

@end
