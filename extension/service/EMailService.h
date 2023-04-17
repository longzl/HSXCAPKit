//
//  EMailService.h
//  EOSFramework
//
//  Created by Sam on 6/19/13.
//
//

#import <CAPKit/CAPKit.h>
#import <MessageUI/MessageUI.h>

@interface EMailService : AbstractLuaTableCompatible <IService, MFMailComposeViewControllerDelegate>

@end
