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

// This class is used to set the privacy status
enum ACPPrivacyStatus { opt_in, opt_out, unknown }

extension ACPPrivacyStatusExt on ACPPrivacyStatus {
  String get value {
    switch (this) {
      case ACPPrivacyStatus.opt_in:
        return 'ACP_PRIVACY_STATUS_OPT_IN';
      case ACPPrivacyStatus.opt_out:
        return 'ACP_PRIVACY_STATUS_OPT_OUT';
      case ACPPrivacyStatus.unknown:
        return 'ACP_PRIVACY_STATUS_UNKNOWN';
    }
  }
}

extension ACPPrivacyStatusValueExt on String {
  ACPPrivacyStatus get toACPPrivacyStatus {
    switch (this) {
      case 'ACP_PRIVACY_STATUS_OPT_IN':
        return ACPPrivacyStatus.opt_in;
      case 'ACP_PRIVACY_STATUS_OPT_OUT':
        return ACPPrivacyStatus.opt_out;
      case 'ACP_PRIVACY_STATUS_UNKNOWN':
        return ACPPrivacyStatus.unknown;
    }
    throw Exception('Invalid ACPPrivacyStatus value: $this');
  }
}
