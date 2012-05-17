
#import "SPFileDownloadApiConnect.h"
#import "SPDefines.h"
#import "SBJson.h"

@implementation SPFileDownloadApiConnect

-(void)fileDownloadWith:(NSString*)productID delegate:(id<FileDownloadDelegate>)delegate
{
    downloadDelegate = delegate;
    downloadData=nil;
    currentSize=0;
    totalSize=0;
    downloadRate=0;
    downloadFilePath=[NSString stringWithFormat:@"%@/%@.html",NSTemporaryDirectory(),productID];
    
    NSMutableString* querybody =[[NSMutableString alloc]init];
    [querybody appendFormat:@"token=%@&product_id=%@",SP_ACCESS_TOKEN,productID];
    NSURL* url = [[NSURL alloc]initWithString:SP_FILES_API];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[querybody dataUsingEncoding:NSUTF8StringEncoding]];

    NSError* error=nil;
    NSData* filelistData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if(error != nil){
        //error
        [downloadDelegate finishFileDownloadAPIWithError:error];

    }else{
        
        NSDictionary* filelistDictionary = [filelistData JSONValue];
        NSArray* filelistArray = [filelistDictionary objectForKey:@"files"];
        NSDictionary* fileDictionary = [filelistArray objectAtIndex:0];
        NSString* downloadurl = [fileDictionary objectForKey:@"download_url"];
        
        connection = [[NSURLConnection alloc]initWithRequest:
                      [NSURLRequest requestWithURL:
                       [NSURL URLWithString:downloadurl]] delegate:self];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    downloadData = [[NSMutableData alloc]init];
    totalSize = response.expectedContentLength;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //大きいファイルの場合は逐次保存してメモリを使いすぎないように修正
    [downloadData appendData:data];
    currentSize = downloadData.length;
    downloadRate = (float) currentSize / totalSize;
    [downloadDelegate progressFileDownloadAPI:downloadRate];
}

- (void)connection:(NSURLConnection *)connection 
  didFailWithError:(NSError *)error
{
    [downloadDelegate finishFileDownloadAPIWithError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [downloadData writeToFile:downloadFilePath atomically:YES];
    [downloadDelegate finishFileDownloadAPI:downloadFilePath];
}
@end
