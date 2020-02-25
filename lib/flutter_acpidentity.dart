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

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_acpcore/src/acpmobile_visitor_id.dart';

/// Adobe Experience Platform Identity API.
class FlutterACPIdentity {
  static const MethodChannel _channel =
      const MethodChannel('flutter_acpidentity');

  /// Gets the current Identity extension version.
  static Future<String> get extensionVersion async {
    final String version = await _channel.invokeMethod('extensionVersion');
    return version;
  }

  /// Appends Adobe visitor information to the query component of the specified URL.
  static Future<String> appendToUrl(String url) async {
    return _channel.invokeMethod('appendToUrl', url ?? "");
  }

  /// Returns all customer identifiers that were previously synced with the Adobe Experience Cloud.
  static Future<List<ACPMobileVisitorId>> get identifiers async {
    final List<dynamic> result = await _channel.invokeListMethod<dynamic>(
      'getIdentifiers',
    );
    return result
        ?.map<ACPMobileVisitorId>(
          (dynamic data) => ACPMobileVisitorId(data),
        )
        ?.toList();
  }

  /// Returns the Experience Cloud ID.
  static Future<String> get experienceCloudId async {
    final String id = await _channel.invokeMethod('getExperienceCloudId');
    return id;
  }

  /// Updates the given customer ID with the Adobe Experience Cloud ID Service.
  static Future<void> syncIdentifier(String identifierType, String identifier,
      ACPMobileVisitorAuthenticationState authState) async {
    await _channel.invokeMethod<void>('syncIdentifier', {
      'identifierType': identifierType,
      'identifier': identifier,
      'authState': authState.value
    });
  }

  /// Updates the given customer IDs with the Adobe Experience Cloud ID Service.
  static Future<void> syncIdentifiers(Map<String, String> identifiers) async {
    await _channel.invokeMethod<void>('syncIdentifiers', identifiers ?? {});
  }

  /// Updates the given customer IDs with the Adobe Experience Cloud ID Service.
  static Future<void> syncIdentifiersWithAuthState(
      Map<String, String> identifiers,
      ACPMobileVisitorAuthenticationState authState) async {
    await _channel.invokeMethod<void>('syncIdentifiersWithAuthState',
        {'identifiers': identifiers ?? {}, 'authState': authState.value});
  }

  /// Gets Visitor ID Service identifiers in URL query string form for consumption in hybrid mobile apps.
  static Future<String> get urlVariables async {
    final String urlVariables = await _channel.invokeMethod('urlVariables');
    return urlVariables;
  }
}
