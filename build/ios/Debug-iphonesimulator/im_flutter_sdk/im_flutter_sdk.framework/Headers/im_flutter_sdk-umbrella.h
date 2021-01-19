#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "EMChatManagerWrapper.h"
#import "EMChatroomManagerWrapper.h"
#import "EMClientWrapper.h"
#import "EMContactManagerWrapper.h"
#import "EMConversationWrapper.h"
#import "EMGroupManagerWrapper.h"
#import "EMHelper.h"
#import "EMPushManagerWrapper.h"
#import "EMSDKMethod.h"
#import "EMWrapper.h"
#import "ImFlutterSdkPlugin.h"

FOUNDATION_EXPORT double im_flutter_sdkVersionNumber;
FOUNDATION_EXPORT const unsigned char im_flutter_sdkVersionString[];

