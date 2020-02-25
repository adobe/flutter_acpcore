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
#import "FlutterACPIdentityPlugin.h"
#import "ACPIdentity.h"
#import "FlutterACPIdentityDataBridge.h"

@implementation FlutterACPIdentityPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_acpidentity"
            binaryMessenger:[registrar messenger]];
  FlutterACPIdentityPlugin* instance = [[FlutterACPIdentityPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"extensionVersion" isEqualToString:call.method]) {
        result([ACPIdentity extensionVersion]);
    } else if ([@"appendToUrl" isEqualToString:call.method]) {
        [self handleAppendToUrl:call result:result];
    } else if ([@"getIdentifiers" isEqualToString:call.method]) {
        [self handleGetIdentifiers:call result:result];
    } else if ([@"getExperienceCloudId" isEqualToString:call.method]) {
        [self handleGetExperienceCloudId:call result:result];
    } else if ([@"syncIdentifier" isEqualToString:call.method]) {
        [self handleSyncIdentifier:call result:result];
    } else if ([@"syncIdentifiers" isEqualToString:call.method]) {
        [self handleSyncIdentifiers:call result:result];
    } else if ([@"syncIdentifiersWithAuthState" isEqualToString:call.method]) {
        [self handleSyncIdentifiersWithAuthState:call result:result];
    } else if ([@"urlVariables" isEqualToString:call.method]) {
        [self handleUrlVariables:call result:result];
    } else {
      result(FlutterMethodNotImplemented);
    }
}

- (void)handleAppendToUrl:(FlutterMethodCall *) call result:(FlutterResult)result {
    NSURL *url = [NSURL URLWithString:call.arguments];
    [ACPIdentity appendToUrl:url withCallback:^(NSURL * _Nullable urlWithVisitorData) {
        result(urlWithVisitorData.absoluteString);
    }];
}

- (void)handleGetIdentifiers:(FlutterMethodCall *) call result:(FlutterResult)result {
    [ACPIdentity getIdentifiers:^(NSArray<ACPMobileVisitorId *> * _Nullable visitorIDs) {
        NSMutableArray *visitorIDList = [NSMutableArray array];
        for (ACPMobileVisitorId *visitorID in visitorIDs) {
            NSDictionary *visitorIDDict = [FlutterACPIdentityDataBridge dictionaryFromVisitorId:visitorID];
            [visitorIDList addObject:visitorIDDict];
        }
        
        result(visitorIDList);
    }];
}

- (void)handleGetExperienceCloudId:(FlutterMethodCall *) call result:(FlutterResult)result {
    [ACPIdentity getExperienceCloudId:^(NSString * _Nullable experienceCloudId) {
        result(experienceCloudId);
    }];
}

- (void)handleSyncIdentifier:(FlutterMethodCall *) call result:(FlutterResult)result {
    NSString *identifierType = call.arguments[@"identifierType"];
    NSString *identifier = call.arguments[@"identifier"];
    ACPMobileVisitorAuthenticationState authenticationState = [FlutterACPIdentityDataBridge authStateFromString:call.arguments[@"authState"]];
    [ACPIdentity syncIdentifier:identifierType identifier:identifier authentication:authenticationState];
    result(nil);
}

- (void)handleSyncIdentifiers:(FlutterMethodCall *) call result:(FlutterResult)result {
    [ACPIdentity syncIdentifiers:call.arguments];
    result(nil);
}

- (void)handleSyncIdentifiersWithAuthState:(FlutterMethodCall *) call result:(FlutterResult)result {
    NSDictionary *identifiers = call.arguments[@"identifiers"];
    ACPMobileVisitorAuthenticationState authenticationState = [FlutterACPIdentityDataBridge authStateFromString:call.arguments[@"authState"]];
    [ACPIdentity syncIdentifiers:identifiers authentication:authenticationState];
    result(nil);
}

- (void)handleUrlVariables:(FlutterMethodCall *) call result:(FlutterResult)result {
    [ACPIdentity getUrlVariables:^(NSString * _Nullable urlVariables) {
        result(urlVariables);
    }];
}

@end
