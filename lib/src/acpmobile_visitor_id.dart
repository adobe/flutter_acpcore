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

/// This is used to indicate the authentication state for the current ACPMobileVisitorId
class ACPMobileVisitorAuthenticationState {
  final String value;

  const ACPMobileVisitorAuthenticationState(this.value);

  static const ACPMobileVisitorAuthenticationState UNKNOWN =
      const ACPMobileVisitorAuthenticationState(
          "ACP_VISITOR_AUTH_STATE_UNKNOWN");
  static const ACPMobileVisitorAuthenticationState AUTHENTICATED =
      const ACPMobileVisitorAuthenticationState(
          "ACP_VISITOR_AUTH_STATE_AUTHENTICATED");
  static const ACPMobileVisitorAuthenticationState LOGGED_OUT =
      const ACPMobileVisitorAuthenticationState(
          "ACP_VISITOR_AUTH_STATE_LOGGED_OUT");
}

/// This is an identifier to be used with the Experience Cloud Visitor ID Service and it contains the origin, the identifier type, the identifier,, and the authentication state of the visitor ID.
class ACPMobileVisitorId {
  final Map<dynamic, dynamic> _data;

  ACPMobileVisitorId(this._data);

  String get idOrigin => _data['idOrigin'];
  String get idType => _data['idType'];
  String get identifier => _data['identifier'];
  ACPMobileVisitorAuthenticationState get authenticationState =>
      _data['authenticationState'];

  @override
  String toString() {
    return '$runtimeType($_data)';
  }
}
