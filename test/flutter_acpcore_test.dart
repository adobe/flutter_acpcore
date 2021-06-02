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

import 'package:flutter/services.dart';
import 'package:flutter_acpcore/flutter_acpcore.dart';
import 'package:flutter_acpcore/src/acpextension_event.dart';
import 'package:flutter_acpcore/src/acpmobile_logging_level.dart';
import 'package:flutter_acpcore/src/acpmobile_privacy_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_acpcore');

  TestWidgetsFlutterBinding.ensureInitialized();

  group('extensionVersion', () {
    final String testVersion = "2.5.0";
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return testVersion;
      });
    });

    test('invokes correct method', () async {
      await FlutterACPCore.extensionVersion;

      expect(log, <Matcher>[
        isMethodCall(
          'extensionVersion',
          arguments: null,
        ),
      ]);
    });

    test('returns correct result', () async {
      expect(await FlutterACPCore.extensionVersion, testVersion);
    });
  });

  group('trackAction', () {
    final String testAction = "myTestAction";
    final Map<String, String> testContextData = {
      "context1Key": "context1Value"
    };
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });
    });

    test('invokes correct method', () async {
      await FlutterACPCore.trackAction(testAction, data: testContextData);

      expect(log, <Matcher>[
        isMethodCall(
          'track',
          arguments: {
            "type": "action",
            "name": testAction,
            "data": testContextData
          },
        ),
      ]);
    });
  });

  group('trackState', () {
    final String testState = "myTestState";
    final Map<String, String> testContextData = {
      "context1Key": "context1Value"
    };
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });
    });

    test('invokes correct method', () async {
      await FlutterACPCore.trackState(testState, data: testContextData);

      expect(log, <Matcher>[
        isMethodCall(
          'track',
          arguments: {
            "type": "state",
            "name": testState,
            "data": testContextData
          },
        ),
      ]);
    });
  });

  group('setAdvertisingIdentifier', () {
    final String testAdId = "test-aid";
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });
    });

    test('invokes correct method', () async {
      await FlutterACPCore.setAdvertisingIdentifier(testAdId);

      expect(log, <Matcher>[
        isMethodCall(
          'setAdvertisingIdentifier',
          arguments: testAdId,
        ),
      ]);
    });
  });

  group('dispatchEvent', () {
    final Map<dynamic, dynamic> eventConstructorData = {
      "eventName": "testresponseEvent",
      "eventType": "testresponseEvent",
      "eventSource": "testEventSource",
      "eventData": {"eventDataKey": "eventDataValue"}
    };
    final ACPExtensionEvent expectedEvent =
        ACPExtensionEvent(eventConstructorData);
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return true;
      });
    });

    test('invokes correct method', () async {
      await FlutterACPCore.dispatchEvent(expectedEvent);

      expect(log, <Matcher>[
        isMethodCall(
          'dispatchEvent',
          arguments: eventConstructorData,
        ),
      ]);
    });

    test('returns correct result', () async {
      expect(await FlutterACPCore.dispatchEvent(expectedEvent), true);
    });
  });

  group('dispatchEventWithResponseCallback', () {
    final Map<dynamic, dynamic> eventConstructorData = {
      "eventName": "testresponseEvent",
      "eventType": "testresponseEvent",
      "eventSource": "testEventSource",
      "eventData": {"eventDataKey": "eventDataValue"}
    };
    final ACPExtensionEvent expectedEvent =
        ACPExtensionEvent(eventConstructorData);
    final ACPExtensionEvent returnedEvent = ACPExtensionEvent({
      "eventName": "testrequestEvent",
      "eventType": "testrequestEvent",
      "eventSource": "testEventSource",
      "eventData": {"eventDataKey": "eventDataValue"}
    });

    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return returnedEvent.data;
      });
    });

    test('invokes correct method', () async {
      await FlutterACPCore.dispatchEventWithResponseCallback(expectedEvent);

      expect(log, <Matcher>[
        isMethodCall(
          'dispatchEventWithResponseCallback',
          arguments: eventConstructorData,
        ),
      ]);
    });

    test('returns correct result', () async {
      final actualEvent =
          await FlutterACPCore.dispatchEventWithResponseCallback(expectedEvent);
      expect(actualEvent.eventName, returnedEvent.eventName);
    });
  });

  group('downloadRules', () {
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });
    });

    test('invokes correct method', () async {
      await FlutterACPCore.downloadRules();

      expect(log, <Matcher>[
        isMethodCall(
          'downloadRules',
          arguments: null,
        ),
      ]);
    });
  });

  group('ACPExtensionEvent', () {
    final String eventName = "testEventName";
    final String eventType = "testEventType";
    final String eventSource = "testEventSource";
    final Map<dynamic, dynamic> eventData = {"testEventKey": "testEventValue"};
    final Map<dynamic, dynamic> eventConstructorData = {
      "eventName": eventName,
      "eventType": eventType,
      "eventSource": eventSource,
      "eventData": eventData
    };

    final ACPExtensionEvent event = ACPExtensionEvent.createEvent(
        eventName, eventType, eventSource, eventData);

    test('returns correct result', () async {
      expect(event.eventName, eventName);
      expect(event.eventType, eventType);
      expect(event.eventSource, eventSource);
      expect(event.eventData, eventData);
      expect(event.data, eventConstructorData);
    });
  });

  group('getSdkIdentities', () {
    final String testSdkIdentities = "sdkIdentities";
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return testSdkIdentities;
      });
    });

    test('invokes correct method', () async {
      await FlutterACPCore.sdkIdentities;

      expect(log, <Matcher>[
        isMethodCall(
          'getSdkIdentities',
          arguments: null,
        ),
      ]);
    });

    test('returns correct result', () async {
      String? sdkIdentitiesResult = await FlutterACPCore.sdkIdentities;
      expect(sdkIdentitiesResult, testSdkIdentities);
    });
  });

  group('getPrivacyStatus', () {
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return ACPPrivacyStatus.opt_in.value;
      });
    });

    test('invokes correct method', () async {
      await FlutterACPCore.privacyStatus;

      expect(log, <Matcher>[
        isMethodCall(
          'getPrivacyStatus',
          arguments: null,
        ),
      ]);
    });

    test('returns correct result', () async {
      ACPPrivacyStatus privacyStatus = await FlutterACPCore.privacyStatus;
      expect(privacyStatus.value, ACPPrivacyStatus.opt_in.value);
    });
  });

  group('setLogLevel', () {
    final ACPLoggingLevel logLevel = ACPLoggingLevel.error;
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });
    });

    test('invokes correct method', () async {
      await FlutterACPCore.setLogLevel(logLevel);

      expect(log, <Matcher>[
        isMethodCall(
          'setLogLevel',
          arguments: logLevel.value,
        ),
      ]);
    });
  });

  group('setPrivacyStatus', () {
    final ACPPrivacyStatus privacyStatus = ACPPrivacyStatus.opt_in;
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });
    });

    test('invokes correct method', () async {
      await FlutterACPCore.setPrivacyStatus(privacyStatus);

      expect(log, <Matcher>[
        isMethodCall(
          'setPrivacyStatus',
          arguments: privacyStatus.value,
        ),
      ]);
    });
  });

  group('updateConfiguration', () {
    final Map<String, String> testConfig = {"configKey": "configValue"};
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });
    });

    test('invokes correct method', () async {
      await FlutterACPCore.updateConfiguration(testConfig);

      expect(log, <Matcher>[
        isMethodCall(
          'updateConfiguration',
          arguments: testConfig,
        ),
      ]);
    });
  });
}
