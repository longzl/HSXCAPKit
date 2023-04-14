//
//  DocumentPreviewService.h
//  EOSFramework
//
//  Created by Sam Chang on 3/20/13.
//
//

#import <UIKit/UIKit.h>
#import <CAPKit/CAPKit.h>
#import "IDocumentPreviewService.h"
#import <QuickLook/QuickLook.h>

@interface DocumentPreviewService : AbstractLuaTableCompatible <IService, IDocumentPreviewService, QLPreviewControllerDataSource>{
}

@property (nonatomic, strong) NSArray *previewItems;

@end
