//
//  FrameWidget.h
//  CAPKit
//
//  Created by Sam Chang on 21/09/2017.
//  Copyright © 2017 CAP. All rights reserved.
//

#import <CAPKit/CAPKit.h>
#import "CAPFrameM.h"

@interface CAPFrameWidget : CAPAbstractUIWidget

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (nonatomic, readonly) CAPFrameM *model;
@property (nonatomic, readonly) CAPFrameM *stableModel;
#pragma clang diagnostic pop

@property (nonatomic, readonly) CAPRenderView *renderView;

@end
