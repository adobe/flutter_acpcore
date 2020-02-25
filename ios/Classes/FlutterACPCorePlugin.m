/*
Copyright 2020 Adobe. All rights reserved.
This file is licensed to you under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License. You may obtain a copy
of the License at http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software distributed under
the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
OF ANY KIND, either express or implied. See the License for the specific language
governing permissions and limitations under the License.
*/
#import "FlutterACPCorePlugin.h"
#import "FlutterACPIdentityPlugin.h"
#import "FlutterACPLifecyclePlugin.h"
#import "FlutterACPSignalPlugin.h"
#import "ACPCore.h"
#import "ACPExtensionEvent+Flutter.h"
#import "FlutterACPCoreDataBridge.h"

@implementation FlutterACPCorePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_acpcore"
            binaryMessenger:[registrar messenger]];
  FlutterACPCorePlugin* instance = [[FlutterACPCorePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];

  [FlutterACPIdentityPlugin registerWithRegistrar: registrar];
  [FlutterACPLifecyclePlugin registerWithRegistrar: registrar];
  [FlutterACPSignalPlugin registerWithRegistrar: registrar];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"extensionVersion" isEqualToString:call.method]) {
        result([ACPCore extensionVersion]);
    } else if ([@"track" isEqualToString:call.method]) {
        [self handleTrackCall:call];
        result(nil);
    } else if ([@"downloadRules" isEqualToString:call.method]) {
        [ACPCore downloadRules];
        result(nil);
    } else if ([@"setAdvertisingIdentifier" isEqualToString:call.method]) {
        NSString *aid = call.arguments;
        [ACPCore setAdvertisingIdentifier:aid];
        result(nil);
    } else if ([@"lifecycleStart" isEqualToString:call.method]) {
        NSDictionary *contextData = call.arguments;
        [ACPCore lifecycleStart:contextData];
        result(nil);
    } else if ([@"dispatchEvent" isEqualToString:call.method]) {
        [self handleDispatchEvent:call result:result];
    } else if ([@"dispatchEventWithResponseCallback" isEqualToString:call.method]) {
        [self handleDispatchEventWithResponseCallback:call result:result];
    } else if ([@"dispatchResponseEvent" isEqualToString:call.method]) {
        [self handleDispatchResponseEvent:call result:result];
    } else if ([@"getSdkIdentities" isEqualToString:call.method]) {
        [self handleGetSdkIdentities:call result:result];
    } else if ([@"getPrivacyStatus" isEqualToString:call.method]) {
        [self handleGetPrivacyStatus:call result:result];
    } else if ([@"setLogLevel" isEqualToString:call.method]) {
        NSString *logLevel = call.arguments;
        [ACPCore setLogLevel:[FlutterACPCoreDataBridge logLevelFromString:logLevel]];
        result(nil);
    } else if ([@"updateConfiguration" isEqualToString:call.method]) {
        NSDictionary *configUpdate = call.arguments;
        [ACPCore updateConfiguration:configUpdate];
        result(nil);
    } else if ([@"lifecyclePause" isEqualToString:call.method]) {
        [ACPCore lifecyclePause];
        result(nil);
    } else if ([@"setPrivacyStatus" isEqualToString:call.method]) {
        [ACPCore setPrivacyStatus:[FlutterACPCoreDataBridge privacyStatusFromString:call.arguments]];
        result(nil);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)handleTrackCall:(FlutterMethodCall *) call {
    NSDictionary *dict = (NSDictionary *) call.arguments;
    NSString *type = (NSString *) dict[@"type"];
    NSString *name = (NSString *) dict[@"name"];
    NSDictionary *data = (NSDictionary *) dict[@"data"];

    if ([type isEqualToString:@"state"]) {
        [ACPCore trackState:name data:data];
    } else if ([type isEqualToString:@"action"]) {
        [ACPCore trackAction:name data:data];
    }
    
}

- (void)handleDispatchEvent:(FlutterMethodCall *) call result:(FlutterResult)result {
    NSDictionary *eventDict = (NSDictionary *) call.arguments;
    ACPExtensionEvent *event = [ACPExtensionEvent eventFromDictionary:eventDict];
    
    NSError* error = nil;
    if ([ACPCore dispatchEvent:event error:&error]) {
        result(@(YES));
    } else {
        result([self flutterErrorFromNSError:error]);
    }
}

- (void)handleDispatchEventWithResponseCallback:(FlutterMethodCall *) call result:(FlutterResult)result {
    NSDictionary *eventDict = (NSDictionary *) call.arguments;
    ACPExtensionEvent *event = [ACPExtensionEvent eventFromDictionary:eventDict];
    
    NSError *error = nil;
    if ([ACPCore dispatchEventWithResponseCallback:event responseCallback:^(ACPExtensionEvent * _Nonnull responseEvent) {
        result([ACPExtensionEvent dictionaryFromEvent:responseEvent]);
    } error:&error]) {
        // nothing
    } else if (error) {
        result([self flutterErrorFromNSError:error]);
    }
}

- (void)handleDispatchResponseEvent:(FlutterMethodCall *) call result:(FlutterResult)result {
    NSDictionary *responseEventDict = call.arguments[@"responseEvent"];
    NSDictionary *requestEventDict = call.arguments[@"requestEvent"];

    ACPExtensionEvent *responseEvent = [ACPExtensionEvent eventFromDictionary:responseEventDict];
    ACPExtensionEvent *requestEvent = [ACPExtensionEvent eventFromDictionary:requestEventDict];
    
    NSError* error = nil;
    if ([ACPCore dispatchResponseEvent:responseEvent requestEvent:requestEvent error:&error]) {
        result(@(YES));
    } else {
        result([self flutterErrorFromNSError:error]);
    }
}

- (void)handleGetSdkIdentities:(FlutterMethodCall *) call result:(FlutterResult)result {
    [ACPCore getSdkIdentities:^(NSString * _Nullable content) {
        result(content);
    }];
}

- (void)handleGetPrivacyStatus:(FlutterMethodCall *) call result:(FlutterResult)result {
    [ACPCore getPrivacyStatus:^(ACPMobilePrivacyStatus status) {
        result([FlutterACPCoreDataBridge stringFromPrivacyStatus:status]);
    }];
}

- (FlutterError *)flutterErrorFromNSError:(NSError *) error {
    return [FlutterError errorWithCode:[NSString stringWithFormat:@"%ld", (long)error.code]
                             message:error.localizedDescription
                             details:error.domain];
}

@end
