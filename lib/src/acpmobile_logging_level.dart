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
class ACPLoggingLevel {
  final String value;

  const ACPLoggingLevel(this.value);

  static const ACPLoggingLevel ERROR =
      const ACPLoggingLevel("ACP_LOG_LEVEL_ERROR");
  static const ACPLoggingLevel WARNING =
      const ACPLoggingLevel("ACP_LOG_LEVEL_WARNING");
  static const ACPLoggingLevel DEBUG =
      const ACPLoggingLevel("ACP_LOG_LEVEL_DEBUG");
  static const ACPLoggingLevel VERBOSE =
      const ACPLoggingLevel("ACP_LOG_LEVEL_VERBOSE");
}
