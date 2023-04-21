# flutter_acpcore

[![pub package](https://img.shields.io/pub/v/flutter_acpcore.svg)](https://pub.dartlang.org/packages/flutter_acpcore) ![Build](https://github.com/adobe/flutter_acpcore/workflows/Dart%20Unit%20Tests%20+%20Android%20Build%20+%20iOS%20Build/badge.svg) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

`flutter_acpcore` is a flutter plugin for the iOS and Android [AEP Core SDK](https://developer.adobe.com/client-sdks/previous-versions/documentation/mobile-core/) to allow for integration with flutter applications. Functionality to enable the Core extension is provided entirely through Dart documented below.

## Contents
- [Installation](#installation)
- [Tests](#tests)
- [Usage](#usage)
	- [Initializing](#initializing)
	- [Core](#core)
	- [Identity](#identity)
	- [Lifecycle](#lifecycle)
	- [Signal](#signal)

## Installation

Install instructions for this package can be found [here](https://pub.dev/packages/flutter_acpcore#-installing-tab-).

> Note: After you have installed the SDK, don't forget to run `pod install` in your `ios` directory to link the libraries to your Xcode project.

After you have installed Core, you can install additional AEP Flutter extensions.

| Extension    | Package                                            |
| ------------ | ------------------------------------------------------------ |
| Analytics    | [![pub package](https://img.shields.io/pub/v/flutter_acpanalytics.svg)](https://pub.dartlang.org/packages/flutter_acpanalytics) |
| Assurance | [![pub package](https://img.shields.io/pub/v/flutter_assurance.svg)](https://pub.dartlang.org/packages/flutter_assurance) |

## Tests

Run:

```bash
flutter test
```

## Usage

### Initializing:

Initializing the SDK should be done in native code, documentation on how to initalize the SDK can be found [here](https://developer.adobe.com/client-sdks/previous-versions/documentation/mobile-core/api-reference/#registerextensions). The linked documentation initalizes the User Profile extension which is not required or supported in Flutter. 

#### iOS: 
Add the initialization code in [AppDelegate.m or AppDelegate.swift](https://github.com/adobe/flutter_acpcore/blob/master/example/ios/Runner/AppDelegate.m#L13) file of the generated iOS project.

#### Android: 
Create an [Application class](https://github.com/adobe/flutter_acpcore/blob/master/example/android/app/src/main/java/com/adobe/marketing/mobile/flutter/flutter_acpcore_example/MyApplication.java) which extends [FlutterApplication](https://api.flutter.dev/javadoc/io/flutter/app/FlutterApplication.html) and add the initialization code. Change your [AndroidManifest.xml](https://github.com/adobe/flutter_acpcore/blob/master/example/android/app/src/main/AndroidManifest.xml#L9) to reference this new class. 

Once you have added the initialization code to your app, be sure to set the SDK wrapper type to Flutter before you start the SDK.

###### iOS:
Swift:
```swift
ACPCore.setWrapperType(.flutter)
```

Objective-C:
```objective-c
[ACPCore setWrapperType:ACPMobileWrapperTypeFlutter];
```

###### Android:
```java
MobileCore.setWrapperType(WrapperType.FLUTTER);
```

### [Core](https://developer.adobe.com/client-sdks/previous-versions/documentation/mobile-core/)

##### Importing Core:
```dart
import 'package:flutter_acpcore/flutter_acpcore.dart';
```

##### Getting Core version:
 ```dart
String version = await FlutterACPCore.extensionVersion;
 ```

##### Updating the SDK configuration:

```dart
FlutterACPCore.updateConfiguration({"key" : "value"});
```

##### Controlling the log level of the SDK:
```dart
import 'package:flutter_acpcore/src/acpmobile_logging_level.dart';

FlutterACPCore.setLogLevel(ACPLoggingLevel.ERROR);
FlutterACPCore.setLogLevel(ACPLoggingLevel.WARNING);
FlutterACPCore.setLogLevel(ACPLoggingLevel.DEBUG);
FlutterACPCore.setLogLevel(ACPLoggingLevel.VERBOSE);
```

##### Getting the current privacy status:
```dart
import 'package:flutter_acpcore/src/acpmobile_privacy_status.dart';

ACPPrivacyStatus result;

try {
  result = await FlutterACPCore.privacyStatus;
} on PlatformException {
  log("Failed to get privacy status");
}
```

##### Setting the privacy status:
```dart
import 'package:flutter_acpcore/src/acpmobile_privacy_status.dart';

FlutterACPCore.setPrivacyStatus(ACPPrivacyStatus.OPT_IN);
FlutterACPCore.setPrivacyStatus(ACPPrivacyStatus.OPT_OUT);
FlutterACPCore.setPrivacyStatus(ACPPrivacyStatus.UNKNOWN);
```

##### Getting the SDK identities:
```dart
String result = "";

try {
  result = await FlutterACPCore.sdkIdentities;
} on PlatformException {
  log("Failed to get sdk identities");
}
```

##### Dispatching an Event Hub event:
```dart
import 'package:flutter_acpcore/src/acpextension_event.dart';

final ACPExtensionEvent event = ACPExtensionEvent.createEvent("eventName", "eventType", "eventSource", {"testDataKey": "testDataValue"});

bool result;
try {
  result = await FlutterACPCore.dispatchEvent(event);
} on PlatformException catch (e) {
  log("Failed to dispatch event '${e.message}''");
}
```

##### Dispatching an Event Hub event with callback:
```dart
import 'package:flutter_acpcore/src/acpextension_event.dart';

ACPExtensionEvent result;
final ACPExtensionEvent event ACPExtensionEvent.createEvent("eventName", "eventType", "eventSource", {"testDataKey": "testDataValue"});

try {
  result = await FlutterACPCore.dispatchEventWithResponseCallback(event);
} on PlatformException catch (e) {
  log("Failed to dispatch event '${e.message}''");
}
```

##### Dispatching an Event Hub response event:
```dart
import 'package:flutter_acpcore/src/acpextension_event.dart';

bool result;
final ACPExtensionEvent responseEvent = ACPExtensionEvent.createEvent("eventName", "eventType", "eventSource", {"testDataKey": "testDataValue"});
final ACPExtensionEvent requestEvent = ACPExtensionEvent.createEvent("eventName", "eventType", "eventSource", {"testDataKey": "testDataValue"});

try {
  result = await FlutterACPCore.dispatchResponseEvent(responseEvent, requestEvent);
} on PlatformException catch (e) {
  log("Failed to dispatch events '${e.message}''");
}
```

### [Identity](https://developer.adobe.com/client-sdks/previous-versions/documentation/mobile-core/identity/)
##### Importing Identity:
```dart
import 'package:flutter_acpcore/flutter_acpidentity.dart';
```

##### Getting Identity version:
```dart
String version = await FlutterACPIdentity.extensionVersion;
```

##### Sync Identifier:
```dart
import 'package:flutter_acpcore/src/acpmobile_visitor_id.dart';

FlutterACPIdentity.syncIdentifier("identifierType", "identifier", ACPMobileVisitorAuthenticationState.AUTHENTICATED);
```

##### Sync Identifiers:
```dart
FlutterACPIdentity.syncIdentifiers({"idType1":"idValue1",
                                    "idType2":"idValue2",
                                    "idType3":"idValue3"});
```

##### Sync Identifiers with Authentication State:
```dart
import 'package:flutter_acpcore/src/acpmobile_visitor_id.dart';

FlutterACPIdentity.syncIdentifiersWithAuthState({"idType1":"idValue1", "idType2":"idValue2", "idType3":"idValue3"}, ACPMobileVisitorAuthenticationState.AUTHENTICATED);

```

Note: `ACPMobileVisitorAuthenticationState` is defined as:

```dart
enum ACPMobileVisitorAuthenticationState {UNKNOWN, AUTHENTICATED, LOGGED_OUT}
```

##### Append visitor data to a URL:

```dart
String result = "";

try {
  result = await FlutterACPIdentity.appendToUrl("www.myUrl.com");
} on PlatformException {
  log("Failed to append URL");
}
```

##### Setting the advertising identifier:

```dart
FlutterACPCore.setAdvertisingIdentifier("ad-id");
```

##### Get visitor data as URL query parameter string:

```dart
String result = "";

try {
  result = await FlutterACPIdentity.urlVariables;
} on PlatformException {
  log("Failed to get url variables");
}
```

##### Get Identifiers:

```dart
List<ACPMobileVisitorId> result;

try {
  result = await FlutterACPIdentity.identifiers;
} on PlatformException {
  log("Failed to get identifiers");
}
```

##### Get Experience Cloud IDs:
```dart
String result = "";

try {
  result = await FlutterACPIdentity.experienceCloudId;
} on PlatformException {
  log("Failed to get experienceCloudId");
}
```

##### ACPMobileVisitorId Class:
```dart
import 'package:flutter_acpcore/src/acpmobile_visitor_id.dart';

class ACPMobileVisitorId {
  String get idOrigin;
  String get idType;
  String get identifier;
  ACPMobileVisitorAuthenticationState get authenticationState;
}
```

### [Lifecycle](https://developer.adobe.com/client-sdks/previous-versions/documentation/mobile-core/lifecycle/)

> Note: It is required to implement Lifecycle in native [Android and iOS code]https://developer.adobe.com/client-sdks/previous-versions/documentation/mobile-core/lifecycle/).

### [Signal](https://developer.adobe.com/client-sdks/previous-versions/documentation/mobile-core/signal/)
##### Importing Signal:
```dart
import 'package:flutter_acpcore/flutter_acpsignal.dart';
```

##### Getting Signal version:
 ```dart
String version = await FlutterACPSignal.extensionVersion;
 ```


## Contributing
See [CONTRIBUTING](CONTRIBUTING.md)

## License
See [LICENSE](LICENSE)
