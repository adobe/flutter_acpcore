# flutter_acpcore

⚠️ This package is currently in beta, we are actively working to a release candidate. If you have any feedback please log an issue or submit a pull request.

`flutter_acpcore` is a flutter plugin for the iOS and Android [AEP Core SDK](https://aep-sdks.gitbook.io/docs/using-mobile-extensions/mobile-core) to allow for integration with flutter applications. Functionality to enable the Core extension is provided entirely through Dart documented below.

## Contents
- [Installation](#installation)
- [Tests](#tests)
- [Usage](#usage)
	- [Core](#core)
	- [Identity](#identity)
	- [Lifecycle](#lifecycle)
	- [Signal](#signal)

## Installation

Add `flutter_acpcore` to your dependencies in `pubspec.yaml`

```yaml
dependencies:
  flutter_acpcore: ^0.0.1
```

Then fetch the packages with:

```bash
flutter pub get
```

## Tests

Run:

```bash
flutter test
```

## Usage
### [Core](https://aep-sdks.gitbook.io/docs/using-mobile-extensions/mobile-core)
##### Initializing the SDK:

**iOS:**

```objective-c
// Import the SDK
#import "ACPCore.h"
#import "ACPLifecycle.h"
#import "ACPIdentity.h"
#import "ACPSignal.h"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  //...
  [ACPCore configureWithAppId:@"yourAppId"];
  [ACPCore setWrapperType:ACPMobileWrapperTypeFlutter];
  [ACPIdentity registerExtension];
  [ACPLifecycle registerExtension];
  [ACPSignal registerExtension];
  // Register any additional extensions

  [ACPCore start:nil];
}
```

**Android:**

```java
// Import the SDK
import com.adobe.marketing.mobile.MobileCore;
import com.adobe.marketing.mobile.Identity;
import com.adobe.marketing.mobile.Lifecycle;
import com.adobe.marketing.mobile.Signal;
import com.adobe.marketing.mobile.WrapperType;

@Override
public void onCreate() {
  //...
  MobileCore.setApplication(this);
  MobileCore.configureWithAppID("yourAppId");
  // MobileCore.setWrapperType(WrapperType.FLUTTER); COMING SOON
  try {
    Identity.registerExtension();
    Lifecycle.registerExtension();
    Signal.registerExtension();
    // Register any additional extensions
  } catch (Exception e) {
    // handle exception
  }

  MobileCore.start(null);
}
```

##### Importing Core:
```dart
import 'package:flutter_acpcore/flutter_acpcore.dart';
```

##### Getting Core version:
 ```dart
String version = FlutterACPCore.extensionVersion;
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

### [Identity](https://aep-sdks.gitbook.io/docs/using-mobile-extensions/mobile-core/identity)
##### Importing Identity:
```dart
import 'package:flutter_acpcore/flutter_acpidentity.dart';
```

##### Getting Identity version:
```dart
String version = FlutterACPIdentity.extensionVersion;
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

FlutterACPIdentity.syncIdentifiersWithAuthState({"idType1":"idValue1", "idType2":"idValue2", "idType3":"idValue3"}, ACPMobileVisitorAuthenticationState.authenticated);

```

Note: `ACPMobileVisitorAuthenticationState` is defined as:

```dart
enum ACPMobileVisitorAuthenticationState {unknown, authenticated, loggedOut}
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

### [Lifecycle](https://aep-sdks.gitbook.io/docs/using-mobile-extensions/mobile-core/lifecycle)

> Note: Implementing Lifecycle via Dart may lead to inaccurate Lifecycle metrics, therefore we recommend implementing Lifecycle in native [Android and iOS code](https://aep-sdks.gitbook.io/docs/using-mobile-extensions/mobile-core/lifecycle). However, these APIs are still provided in Dart to support flexible Lifecycle implementations.

##### Importing Lifecycle:
```dart
import 'package:flutter_acpcore/flutter_acplifecycle.dart';
```

##### Getting Lifecycle version:
 ```dart
String version = FlutterACPLifecycle.extensionVersion;
 ```

##### Starting a Lifecycle event:
```dart
FlutterACPCore.lifecycleStart({"contextKey": "contextValue"});
```

##### Pausing a Lifecycle event:
```dart
FlutterACPCore.lifecyclePause();
```

### [Signal](https://aep-sdks.gitbook.io/docs/using-mobile-extensions/mobile-core/signals)
##### Importing Signal:
```dart
import 'package:flutter_acpcore/flutter_acpsignal.dart';
```

##### Getting Signal version:
 ```dart
String version = FlutterACPSignal.extensionVersion;
 ```


## Contributing
See [CONTRIBUTING](CONTRIBUTING.md)

## License
See [LICENSE](LICENSE)
