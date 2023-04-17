//
//  IDocumentPreviewService.h
//  EOSFramework
//
//  Created by Sam Chang on 3/20/13.
//
//

#import <CAPKit/CAPKit.h>

@protocol IDocumentPreviewService <NSObject>

- (void) preview: (NSString *) uri;

@end
