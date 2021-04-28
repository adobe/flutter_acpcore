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
///
enum ACPMobileVisitorAuthenticationState { authenticated, logged_out, unknown }

extension ACPMobileVisitorAuthenticationStateExt
    on ACPMobileVisitorAuthenticationState {
  String get value {
    switch (this) {
      case ACPMobileVisitorAuthenticationState.logged_out:
        return 'ACP_VISITOR_AUTH_STATE_LOGGED_OUT';
      case ACPMobileVisitorAuthenticationState.authenticated:
        return 'ACP_VISITOR_AUTH_STATE_AUTHENTICATED';
      case ACPMobileVisitorAuthenticationState.unknown:
        return 'ACP_VISITOR_AUTH_STATE_UNKNOWN';
    }
  }
}

extension ACPMobileVisitorAuthenticationStateValueExt on String {
  ACPMobileVisitorAuthenticationState
      get toACPMobileVisitorAuthenticationState {
    switch (this) {
      case 'ACP_VISITOR_AUTH_STATE_AUTHENTICATED':
        return ACPMobileVisitorAuthenticationState.authenticated;
      case 'ACP_VISITOR_AUTH_STATE_LOGGED_OUT':
        return ACPMobileVisitorAuthenticationState.logged_out;
      case 'ACP_VISITOR_AUTH_STATE_UNKNOWN':
        return ACPMobileVisitorAuthenticationState.unknown;
    }
    throw Exception('Invalid ACPMobileVisitorAuthenticationState value: $this');
  }
}

/// This is an identifier to be used with the Experience Cloud Visitor ID Service and it contains the origin, the identifier type, the identifier,, and the authentication state of the visitor ID.
class ACPMobileVisitorId {
  final Map<dynamic, dynamic> _data;

  ACPMobileVisitorId(this._data);

  String get idOrigin => _data['idOrigin'];

  String get idType => _data['idType'];

  String get identifier => _data['identifier'];

  ACPMobileVisitorAuthenticationState get authenticationState =>
      (_data['authenticationState'] as String)
          .toACPMobileVisitorAuthenticationState;

  @override
  String toString() => '$runtimeType($_data)';
}
