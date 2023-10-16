// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../../social_sign_in_button.dart';
import 'stub.dart';

/// Renders a SIGN IN button that calls `handleSignIn` onclick.
Widget buildSignInButton({HandleSignInFn? onPressed}) {
  return SocialSignInButton(
    assetName: 'images/google-logo.png',
    text: 'Sign in with Google',
    textColor: Colors.black87,
    color: Colors.white,
    onPressed: onPressed,
  );
}
