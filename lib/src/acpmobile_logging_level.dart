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

// This class is used to set the log level

enum ACPLoggingLevel { error, warning, debug, verbose }

extension ACPLoggingLevelExt on ACPLoggingLevel {
  String get value {
    switch (this) {
      case ACPLoggingLevel.error:
        return 'ACP_LOG_LEVEL_ERROR';
      case ACPLoggingLevel.warning:
        return 'ACP_LOG_LEVEL_WARNING';
      case ACPLoggingLevel.debug:
        return 'ACP_LOG_LEVEL_DEBUG';
      case ACPLoggingLevel.verbose:
        return 'ACP_LOG_LEVEL_VERBOSE';
    }
  }
}

extension ACPLoggingLevelValueExt on String {
  ACPLoggingLevel get toACPLoggingLevel {
    switch (this) {
      case 'ACP_LOG_LEVEL_ERROR':
        return ACPLoggingLevel.error;
      case 'ACP_LOG_LEVEL_WARNING':
        return ACPLoggingLevel.warning;
      case 'ACP_LOG_LEVEL_DEBUG':
        return ACPLoggingLevel.debug;
      case 'ACP_LOG_LEVEL_VERBOSE':
        return ACPLoggingLevel.verbose;
    }
    throw Exception('Invalid ACPLoggingLevel value: $this');
  }
}
