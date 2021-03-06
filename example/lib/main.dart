import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_acpcore/flutter_acpcore.dart';
import 'package:flutter_acpcore/flutter_acpcore_data.dart';
import 'package:flutter_acpcore/flutter_acpidentity.dart';
import 'package:flutter_acpcore/flutter_acplifecycle.dart';
import 'package:flutter_acpcore/flutter_acpsignal.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _coreVersion = 'Unknown';
  String _identityVersion = 'Unknown';
  String _lifecycleVersion = 'Unknown';
  String _signalVersion = 'Unknown';
  String _appendToUrlResult = "";
  String _experienceCloudId = "";
  String _getUrlVariablesResult = "";
  String _getIdentifiersResult = "";
  String _sdkIdentities = "";
  String _privacyStatus = "";

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    late String coreVersion, lifecycleVersion, signalVersion, identityVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      coreVersion = await FlutterACPCore.extensionVersion;
      identityVersion = await FlutterACPIdentity.extensionVersion;
      lifecycleVersion = await FlutterACPLifecycle.extensionVersion;
      signalVersion = await FlutterACPSignal.extensionVersion;
    } on PlatformException {
      log("Failed to get extension versions");
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _coreVersion = coreVersion;
      _identityVersion = identityVersion;
      _lifecycleVersion = lifecycleVersion;
      _signalVersion = signalVersion;
    });
  }

  Future<void> appendUrl() async {
    String result = "";

    try {
      result = await FlutterACPIdentity.appendToUrl("www.myUrl.com");
    } on PlatformException {
      log("Failed to append URL");
    }

    if (!mounted) return;
    setState(() {
      _appendToUrlResult = result;
    });
  }

  Future<void> getExperienceCloudId() async {
    String result = "";

    try {
      result = await FlutterACPIdentity.experienceCloudId;
    } on PlatformException {
      log("Failed to get experienceCloudId");
    }

    if (!mounted) return;
    setState(() {
      _experienceCloudId = result;
    });
  }

  Future<void> syncIdentifiers() async {
    FlutterACPIdentity.syncIdentifiers({
      "idType1": "idValue1",
      "idType2": "idValue2",
      "idType3": "idValue3",
    });
  }

  Future<void> syncIdentifiersWithAuthState() async {
    FlutterACPIdentity.syncIdentifiersWithAuthState(
      {
        "idType1": "idValue1",
        "idType2": "idValue2",
        "idType3": "idValue3",
      },
      ACPMobileVisitorAuthenticationState.authenticated,
    );
  }

  Future<void> syncIdentifier() async {
    FlutterACPIdentity.syncIdentifier(
      "idType1",
      "idValue1",
      ACPMobileVisitorAuthenticationState.authenticated,
    );
  }

  Future<void> getUrlVariables() async {
    String result = "";

    try {
      result = await FlutterACPIdentity.urlVariables;
    } on PlatformException {
      log("Failed to get url variables");
    }

    if (!mounted) return;
    setState(() {
      _getUrlVariablesResult = result;
    });
  }

  Future<void> getSdkIdentities() async {
    String result = "";

    try {
      result = await FlutterACPCore.sdkIdentities;
    } on PlatformException {
      log("Failed to get sdk identities");
    }

    if (!mounted) return;
    setState(() {
      _sdkIdentities = result;
    });
  }

  Future<void> getPrivacyStatus() async {
    late ACPPrivacyStatus result;

    try {
      result = await FlutterACPCore.privacyStatus;
    } on PlatformException {
      log("Failed to get privacy status");
    }

    if (!mounted) return;
    setState(() {
      _privacyStatus = result.value;
    });
  }

  Future<void> getIdentifiers() async {
    late List<ACPMobileVisitorId> result;

    try {
      result = await FlutterACPIdentity.identifiers;
    } on PlatformException {
      log("Failed to get identifiers");
    }

    if (!mounted) return;
    setState(() {
      _getIdentifiersResult = result.toString();
    });
  }

  Future<void> setAdvertisingIdentifier() async {
    FlutterACPCore.setAdvertisingIdentifier("ad-id");
  }

  Future<void> dispatchEvent() async {
    final ACPExtensionEvent event = ACPExtensionEvent({
      "eventName": "testEventName",
      "eventType": "testEventType",
      "eventSource": "testEventSource",
      "eventData": {"eventDataKey": "eventDataValue"}
    });
    try {
      await FlutterACPCore.dispatchEvent(event);
    } on PlatformException catch (e) {
      log("Failed to dispatch event '${e.message}''");
    }
  }

  Future<void> dispatchEventWithResponseCallback() async {
    final ACPExtensionEvent event = ACPExtensionEvent({
      "eventName": "testEventName",
      "eventType": "testEventType",
      "eventSource": "testEventSource",
      "eventData": {"eventDataKey": "eventDataValue"}
    });
    try {
      await FlutterACPCore.dispatchEventWithResponseCallback(event);
    } on PlatformException catch (e) {
      log("Failed to dispatch event '${e.message}''");
    }
  }

  Future<void> dispatchResponseEvent() async {
    final ACPExtensionEvent responseEvent = ACPExtensionEvent({
      "eventName": "testresponseEvent",
      "eventType": "testresponseEvent",
      "eventSource": "testEventSource",
      "eventData": {"eventDataKey": "eventDataValue"}
    });
    final ACPExtensionEvent requestEvent = ACPExtensionEvent({
      "eventName": "testrequestEvent",
      "eventType": "testrequestEvent",
      "eventSource": "testEventSource",
      "eventData": {"eventDataKey": "eventDataValue"}
    });
    try {
      await FlutterACPCore.dispatchResponseEvent(responseEvent, requestEvent);
    } on PlatformException catch (e) {
      log("Failed to dispatch events '${e.message}''");
    }
  }

  Future<void> downloadRules() async {
    FlutterACPCore.downloadRules();
  }

  // UTIL
  RichText getRichText(String label, String value) {
    return new RichText(
      text: new TextSpan(
        // Note: Styles for TextSpans must be explicitly defined.
        // Child text spans will inherit styles from parent
        style: new TextStyle(
          fontSize: 14.0,
          color: Colors.black,
        ),
        children: <TextSpan>[
          new TextSpan(
              text: label, style: new TextStyle(fontWeight: FontWeight.bold)),
          new TextSpan(text: value),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Text('Core'),
              Text('Identity'),
            ],
          ),
          title: Text('Flutter ACPCore'),
        ),
        body: TabBarView(
          children: [
            Center(
              child: ListView(shrinkWrap: true, children: <Widget>[
                getRichText('ACPCore extension version: ', '$_coreVersion\n'),
                getRichText(
                    'ACPLifecycle extension version: ', '$_lifecycleVersion\n'),
                getRichText(
                    'ACPSignal extension version: ', '$_signalVersion\n'),
                getRichText('SDK Identities = ', '$_sdkIdentities\n'),
                getRichText('Privacy status = ', '$_privacyStatus\n'),
                ElevatedButton(
                  child: Text("FlutterACPCore.sdkIdentities"),
                  onPressed: () => getSdkIdentities(),
                ),
                ElevatedButton(
                  child: Text("FlutterACPCore.privacyStatus"),
                  onPressed: () => getPrivacyStatus(),
                ),
                ElevatedButton(
                  child: Text("FlutterACPCore.setLogLevel"),
                  onPressed: () =>
                      FlutterACPCore.setLogLevel(ACPLoggingLevel.error),
                ),
                ElevatedButton(
                  child: Text("FlutterACPCore.setPrivacyStatus(...)"),
                  onPressed: () =>
                      FlutterACPCore.setPrivacyStatus(ACPPrivacyStatus.opt_in),
                ),
                ElevatedButton(
                  child: Text("FlutterACPCore.updateConfiguration(...)"),
                  onPressed: () =>
                      FlutterACPCore.updateConfiguration({"key": "value"}),
                ),
                ElevatedButton(
                  child: Text("FlutterACPCore.setAdvertisingIdentifier(...)"),
                  onPressed: () => setAdvertisingIdentifier(),
                ),
                ElevatedButton(
                  child: Text("FlutterACPCore.dispatchEvent(...)"),
                  onPressed: () => dispatchEvent(),
                ),
                ElevatedButton(
                  child: Text(
                      "FlutterACPCore.dispatchEventWithResponseCallback(...)"),
                  onPressed: () => dispatchEventWithResponseCallback(),
                ),
                ElevatedButton(
                  child: Text("FlutterACPCore.dispatchResponseEvent(...)"),
                  onPressed: () => dispatchResponseEvent(),
                ),
                ElevatedButton(
                  child: Text("FlutterACPCore.downloadRules()"),
                  onPressed: () => downloadRules(),
                ),
              ]),
            ),
            Center(
              child: ListView(shrinkWrap: true, children: <Widget>[
                getRichText(
                    'ACPIdentity extension version: ', '$_identityVersion\n'),
                getRichText('Append to URL result = ', '$_appendToUrlResult\n'),
                getRichText('Experience Cloud ID = ', '$_experienceCloudId\n'),
                getRichText(
                    'Get URL variables result = ', '$_getUrlVariablesResult\n'),
                getRichText('Identifiers = ', '$_getIdentifiersResult\n'),
                ElevatedButton(
                  child: Text("FlutterACPIdentity.appendToUrl(...)"),
                  onPressed: () => appendUrl(),
                ),
                ElevatedButton(
                  child: Text("FlutterACPIdentity.identifiers"),
                  onPressed: () => getIdentifiers(),
                ),
                ElevatedButton(
                  child: Text("FlutterACPIdentity.experienceCloudId"),
                  onPressed: () => getExperienceCloudId(),
                ),
                ElevatedButton(
                  child: Text("FlutterACPIdentity.syncIdentifier(...)"),
                  onPressed: () => syncIdentifier(),
                ),
                ElevatedButton(
                  child: Text("FlutterACPIdentity.syncIdentifiers(...)"),
                  onPressed: () => syncIdentifiers(),
                ),
                ElevatedButton(
                  child: Text(
                      "FlutterACPIdentity.syncIdentifiersWithAuthState(...)"),
                  onPressed: () => syncIdentifiersWithAuthState(),
                ),
                ElevatedButton(
                  child: Text("FlutterACPIdentity.urlVariables"),
                  onPressed: () => getUrlVariables(),
                ),
              ]),
            ),
          ],
        ),
      ),
    ));
  }
}
