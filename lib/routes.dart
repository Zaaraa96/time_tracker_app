
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/services/auth.dart';
import 'package:time_tracker_app/services/database.dart';

import 'app/home/account/account_page.dart';
import 'app/home/entries/entries_page.dart';
import 'app/home/jobs/jobs_page.dart';
import 'app/home/tab_item.dart';
import 'app/landing_page.dart';
import 'common_widgets/scaffold_with_nested_navigation.dart';

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorJobKey = GlobalKey<NavigatorState>(debugLabel: 'shellJob');
final _shellNavigatorEntriesKey = GlobalKey<NavigatorState>(debugLabel: 'shellEntries');
final _shellNavigatorAccountKey = GlobalKey<NavigatorState>(debugLabel: 'shellAccount');

final routers = GoRouter(
  initialLocation: '/',
  // * Passing a navigatorKey causes an issue on hot reload:
  // * https://github.com/flutter/flutter/issues/113757#issuecomment-1518421380
  // * However it's still necessary otherwise the navigator pops back to
  // * root on hot reload
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: [
    // Stateful navigation based on:
    // https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
    GoRoute(path: '/',
    builder: (context, goRouteState){
      return LandingPage(
        databaseBuilder: (uid) => FirestoreDatabase(uid: uid),
      );
    }
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNestedNavigation(navigationShell: navigationShell,
          navigationRailDestinations: TabItemData.buildRainNavigationDestination(),
          navigationDestinations: TabItemData.buildNavigationDestination(),);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorJobKey,
          routes: [
            GoRoute(
              path: '/jobs',
              pageBuilder: (context, state) =>  NoTransitionPage(
                child:  Provider<Database?>(
                create: (_) => FirestoreDatabase(uid: state.pathParameters['uid']!),
                child: JobsPage(uid: Provider.of<AuthBase>(context, listen: false).currentUser?.uid ?? ''))),
              routes: [
                GoRoute(
                  path: 'details', //todo
                  builder: (context, state) => const DetailsScreen(label: 'A'),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorEntriesKey,
          routes: [
            GoRoute(
              path: '/entries',
              pageBuilder: (context, state) => NoTransitionPage(
                child: EntriesPage.create(context),
              ),
              routes: [
                GoRoute(
                  path: 'details', //todo
                  builder: (context, state) => const DetailsScreen(label: 'A'),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorAccountKey,
          routes: [
            GoRoute(
              path: '/account',
              pageBuilder: (context, state) => NoTransitionPage(
                child: AccountPage(),
              ),
              routes: [
                GoRoute(
                  path: 'details', //todo
                  builder: (context, state) => const DetailsScreen(label: 'A'),
                ),
              ],
            ),
          ],
        ),

      ],
    ),
  ],
);


/// Widget for the root/initial pages in the bottom navigation bar.
class RootScreen extends StatelessWidget {
  /// Creates a RootScreen
  const RootScreen({required this.label, required this.detailsPath, Key? key})
      : super(key: key);

  /// The label
  final String label;

  /// The path to the detail page
  final String detailsPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tab root - $label'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Screen $label',
                style: Theme.of(context).textTheme.titleLarge),
            const Padding(padding: EdgeInsets.all(4)),
            TextButton(
              onPressed: () => context.go(detailsPath),
              child: const Text('View details'),
            ),
          ],
        ),
      ),
    );
  }
}

/// The details screen for either the A or B screen.
class DetailsScreen extends StatefulWidget {
  /// Constructs a [DetailsScreen].
  const DetailsScreen({
    required this.label,
    Key? key,
  }) : super(key: key);

  /// The label to display in the center of the screen.
  final String label;

  @override
  State<StatefulWidget> createState() => DetailsScreenState();
}

/// The state for DetailsScreen
class DetailsScreenState extends State<DetailsScreen> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details Screen - ${widget.label}'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Details for ${widget.label} - Counter: $_counter',
                style: Theme.of(context).textTheme.titleLarge),
            const Padding(padding: EdgeInsets.all(4)),
            TextButton(
              onPressed: () {
                setState(() {
                  _counter++;
                });
              },
              child: const Text('Increment counter'),
            ),
          ],
        ),
      ),
    );
  }
}
