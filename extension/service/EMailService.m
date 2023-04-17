#import "EMailService.h"
#import "IEMailService.h"
#import <MessageUI/MessageUI.h>

@implementation EMailService

+(void)load{
    [[ESRegistry getInstance] registerService: @"EMailService" withName: @"email"];
}

-(BOOL)singleton{
    return YES;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error{
    [controller dismissViewControllerAnimated: YES
                                   completion:^{
                                       
                                   }];
}

- (void) send: (NSDictionary *) args{
    if (![args isKindOfClass: [NSDictionary class]]) {
        return;
    }
        
    if ([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;

        NSString *subject = [args valueForKey: @"subject"];
        if (subject) {
            [mailer setSubject: [subject description]];
        }
        
        NSArray *recipients = [args valueForKey: @"recipients"];
        if ([recipients isKindOfClass: [NSArray class]]) {
            [mailer setToRecipients: recipients];
        }
        
        NSArray *ccrecipients = [args valueForKey: @"ccrecipients"];
        if ([ccrecipients isKindOfClass: [NSArray class]]) {
            [mailer setCcRecipients: ccrecipients];
        }
        
        NSArray *bccrecipients = [args valueForKey: @"bccrecipients"];
        if ([bccrecipients isKindOfClass: [NSArray class]]) {
            [mailer setBccRecipients: bccrecipients];
        }

        NSString *messagebody = [args valueForKey: @"body"];
        
        if ([messagebody isKindOfClass: [NSString class]]) {
            [mailer setMessageBody: messagebody isHTML: [[args valueForKey: @"html"] boolValue]];
        }
        
        NSArray *attachments = [args valueForKey: @"attachments"];
        if ([attachments isKindOfClass: [NSArray class]]) {
            for (NSDictionary *attachment in attachments) {
                if ([attachment isKindOfClass: [NSDictionary class]]) {
                    id data = [attachment valueForKey: @"data"];
                    NSString *mime = [attachment valueForKey: @"mime"];
                    NSString *name = [attachment valueForKey: @"name"];
                    
                    if ([mime isKindOfClass: [NSString class]] && [name isKindOfClass: [NSString class]]) {
                        if ([data isKindOfClass: [LuaData class]]) {
                            [mailer addAttachmentData: ((LuaData *)data).data mimeType: mime fileName: name];
                        } else if ([data isKindOfClass: [NSData class]]) {
                            [mailer addAttachmentData: data mimeType: mime fileName: name];
                        } else if ([data isKindOfClass: [NSString class]]) {
                            [mailer addAttachmentData: [data dataUsingEncoding: NSUTF8StringEncoding] mimeType: mime fileName: name];
                        }
                    }
                }
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
            [rootViewController presentViewController: mailer
                                             animated: YES
                                           completion:^{
                                               
                                           }];
        });
    }
}

@end
