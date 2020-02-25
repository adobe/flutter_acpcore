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

/// The ACPExtensionEvent class contains the event that is used by the internal Event Hub.
class ACPExtensionEvent {
  Map<dynamic, dynamic> _data;

  ACPExtensionEvent(this._data);

  ACPExtensionEvent.createEvent(final String eventName, final String eventType,
      final String eventSource, final Map<dynamic, dynamic> eventData) {
    final Map<dynamic, dynamic> eventConstructorData = {
      "eventName": eventName,
      "eventType": eventType,
      "eventSource": eventSource,
      "eventData": eventData ?? {}
    };
    this._data = eventConstructorData;
  }

  set data(Map<dynamic, dynamic> val) => _data = val;

  /// Dictionary representation of this event, not to be confused with 'eventData'
  Map<dynamic, dynamic> get data => _data;

  /// The name of this event.
  String get eventName => _data['eventName'];

  /// The type of this event.
  String get eventType => _data['eventType'];

  /// The source of this event.
  String get eventSource => _data['eventSource'];

  /// The event data for this event.
  Map<dynamic, dynamic> get eventData => _data['eventData'] ?? {};
}
