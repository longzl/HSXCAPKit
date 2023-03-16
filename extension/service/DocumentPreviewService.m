//
//  DocumentPreviewService.m
//  EOSFramework
//
//  Created by Sam Chang on 3/20/13.
//
//

#import "DocumentPreviewService.h"

@implementation DocumentPreviewService

+(void)load{
    [[ESRegistry getInstance] registerService: @"DocumentPreviewService" withName: @"documentpreview"];
}

-(BOOL)singleton{
    return YES;
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return [_previewItems count];
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    return [_previewItems objectAtIndex: index];
}

- (void) preview: (NSString *) uri{
    self.previewItems = @[[NSURL fileURLWithPath: uri]];
    QLPreviewController *previewCntroller = [[QLPreviewController alloc] init];
    
    previewCntroller.dataSource = self;
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController: previewCntroller
                                                                                 animated: YES
                                                                               completion: ^{
                                                                               }];
    [previewCntroller setTitle: [uri lastPathComponent]];
//    previewCntroller.navigationItem.rightBarButtonItem=nil;
}

@end
