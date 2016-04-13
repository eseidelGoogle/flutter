// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:collection';
import 'dart:developer' as developer;

import 'framework.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/rendering/debug.dart' as renderingDebug;

Key _firstNonUniqueKey(Iterable<Widget> widgets) {
  Set<Key> keySet = new HashSet<Key>();
  for (Widget widget in widgets) {
    assert(widget != null);
    if (widget.key == null)
      continue;
    if (!keySet.add(widget.key))
      return widget.key;
  }
  return null;
}

bool debugChildrenHaveDuplicateKeys(Widget parent, Iterable<Widget> children) {
  assert(() {
    final Key nonUniqueKey = _firstNonUniqueKey(children);
    if (nonUniqueKey != null) {
      throw new FlutterError(
        'Duplicate keys found.\n'
        'If multiple keyed nodes exist as children of another node, they must have unique keys.\n'
        '$parent has multiple children with key $nonUniqueKey.'
      );
    }
    return true;
  });
  return false;
}

bool debugItemsHaveDuplicateKeys(Iterable<Widget> items) {
  assert(() {
    final Key nonUniqueKey = _firstNonUniqueKey(items);
    if (nonUniqueKey != null)
      throw new FlutterError('Duplicate key found: $nonUniqueKey.\n');
    return true;
  });
  return false;
}

class WidgetsDebug {
  static bool showPerformanceOverlay = false;
  static VoidCallback debugSettingsChanged;

  static bool _extensionsInitialized = false;

  static void initServiceExtensions(VoidCallback debugSettingsChangedCallback) {
    if (_extensionsInitialized)
      return;
    _extensionsInitialized = true;
    debugSettingsChanged = debugSettingsChangedCallback;

    // This extension is for profiling and exists in non-checked mode.
    developer.registerExtension('ext.flutter.debugPaint',
      renderingDebug.createToogleServiceExtensionHandler(showPerformanceOverlay, (bool value) {
      showPerformanceOverlay = value;
      if (debugSettingsChanged != null)
        debugSettingsChanged();
    }));
  }
}
