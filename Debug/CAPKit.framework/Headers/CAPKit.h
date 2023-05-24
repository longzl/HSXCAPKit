//
//  CAPKit.h
//  CAPKit
//
//  Created by Sam Chang on 26/09/2016.
//  Copyright © 2016 CAP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//! Project version number for CAPKit.
FOUNDATION_EXPORT double CAPKitVersionNumber;

//! Project version string for CAPKit.
FOUNDATION_EXPORT const unsigned char CAPKitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <CAPKit/PublicHeader.h>


#ifndef CAPKit

#define AppContext NSMutableDictionary

#import <lua53/lua.h>
#import <lua53/lualib.h>
#import <lua53/lauxlib.h>

#import <CAPKit/caplua.h>
#import <HSXluafan/bytearray.h>

#import <CAPKit/LuaRef.h>
#import <CAPKit/LuaFunction.h>
#import <CAPKit/LuaFunctionWatcher.h>
#import <CAPKit/LuaObjectProxy.h>
#import <CAPKit/LuaProxyObject.h>
#import <CAPKit/LuaObjectProxyCompatible.h>
#import <CAPKit/LuaState.h>
#import <CAPKit/LuaTable.h>
#import <CAPKit/LuaTableCompatible.h>
#import <CAPKit/ILuaReference.h>
#import <CAPKit/AbstractLuaTableCompatible.h>
#import <CAPKit/LuaData.h>

#import <CAPKit/LuaLightUserdata.h>
#import <CAPKit/ILuaError.h>
#import <CAPKit/LuaProxyBuilder.h>

#import <CAPKit/LuaObjCBridge.h>

#import <CAPKit/SettingsManager.h>
#import <CAPKit/ImageCache.h>

#import <CAPKit/CAPContainerOption.h>
#import <CAPKit/CAPCenter.h>
#import <CAPKit/PagePanel.h>
#import <CAPKit/CAPRenderView.h>
#import <CAPKit/CAPContainer.h>

#import <CAPKit/PNum.h>
#import <CAPKit/EOSMapInterface.h>
#import <CAPKit/EOSListInterface.h>
#import <CAPKit/EOSMap.h>
#import <CAPKit/EOSList.h>
#import <CAPKit/PackedArray.h>

#import <CAPKit/CAPLuaImage.h>
#import <CAPKit/ModelBuilder.h>

#import <CAPKit/EventConstants.h>
#import <CAPKit/BaseEvent.h>
#import <CAPKit/BaseEvent+Private.h>
#import <CAPKit/BroadcastEvent.h>
#import <CAPKit/UnicastEvent.h>

#import <CAPKit/EventAction.h>
#import <CAPKit/EventActionWrapper.h>
#import <CAPKit/EventDispatcher.h>

#import <CAPKit/UIWidgetM.h>
#import <CAPKit/CAPViewM.h>
#import <CAPKit/CAPPageM.h>
#import <CAPKit/ManifestM.h>

#import <CAPKit/IAbstractUIWidget.h>
#import <CAPKit/CAPAbstractUIWidget.h>

#import <CAPKit/IViewWidget.h>
#import <CAPKit/CAPViewWidget.h>

#import <CAPKit/WidgetMap.h>

#import <CAPKit/IService.h>
#import <CAPKit/ESRegistry.h>

#import <CAPKit/DefaultSandboxInterface.h>
#import <CAPKit/DefaultSandbox.h>

#import <CAPKit/GlobalSandboxInterface.h>
#import <CAPKit/GlobalSandboxDelegate.h>
#import <CAPKit/GlobalSandbox.h>

#import <CAPKit/AppSandboxInterface.h>
#import <CAPKit/AppLifecycle.h>
#import <CAPKit/ScreenScale.h>
#import <CAPKit/CAPAppSandbox.h>

#import <CAPKit/PageSandboxInterface.h>
#import <CAPKit/PageSandboxDelegate.h>
#import <CAPKit/PageLifecycle.h>
#import <CAPKit/CAPPageSandbox.h>

#import <CAPKit/WidgetBuilder.h>

#import <CAPKit/Param.h>
#import <CAPKit/ControllerMap.h>

#import <CAPKit/OSUtils.h>
#import <CAPKit/AppManagementService.h>

#import <CAPKit/RootViewController.h>
#import <CAPKit/CAPAppDelegate.h>

#import <Bugly/Bugly.h>

#endif
