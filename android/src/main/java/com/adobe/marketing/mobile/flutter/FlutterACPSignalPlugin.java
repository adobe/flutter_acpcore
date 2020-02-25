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

package com.adobe.marketing.mobile.flutter;

import com.adobe.marketing.mobile.Signal;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class FlutterACPSignalPlugin implements MethodChannel.MethodCallHandler {

    static void registerWith(PluginRegistry.Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_acpsignal");
        channel.setMethodCallHandler(new FlutterACPSignalPlugin());
    }

    @Override
    public void onMethodCall(MethodCall call,MethodChannel.Result result) {
        if ("extensionVersion".equals(call.method)) {
            result.success(Signal.extensionVersion());
        } else {
            result.notImplemented();
        }
    }
}
