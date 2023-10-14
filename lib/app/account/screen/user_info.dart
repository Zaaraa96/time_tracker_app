

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../common_widgets/avatar.dart';

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Avatar(
          photoUrl: user.photoURL,
          radius: 50,
        ),
        const SizedBox(height: 8),
        if (user.displayName != null)
          Text(
            user.displayName!,
            style: const TextStyle(color: Colors.white),
          ),
        const SizedBox(height: 8),
      ],
    );
  }
}
