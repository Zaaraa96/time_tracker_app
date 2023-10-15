
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/app/services/auth.dart';
import 'package:time_tracker_app/app/services/database.dart';
import 'app/feature/account/screen/account_page.dart';
import 'app/feature/entries/bloc/entries_bloc.dart';
import 'app/feature/entries/screen/entries_page.dart';
import 'app/feature/job_entries/screen/entry_page.dart';
import 'app/feature/job_entries/screen/job_entries_page.dart';
import 'app/feature/jobs/model/job.dart';
import 'app/feature/jobs/screen/edit_job_page.dart';
import 'app/feature/jobs/screen/jobs_page.dart';
import 'app/feature/sign_in/screen/email_sign_in_page.dart';
import 'common_widgets/tab_item.dart';
import 'app/feature/landing_page.dart';
import 'common_widgets/scaffold_with_nested_navigation.dart';
import 'navigation.dart';

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorJobKey = GlobalKey<NavigatorState>(debugLabel: 'shellJob');
final _shellNavigatorEntriesKey = GlobalKey<NavigatorState>(debugLabel: 'shellEntries');
final _shellNavigatorAccountKey = GlobalKey<NavigatorState>(debugLabel: 'shellAccount');

final routers = GoRouter(
  initialLocation: '/',

  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  redirect: (context, state) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final path = state.uri.path;

    final isLoggedIn = auth.currentUser != null;
    if (isLoggedIn) {
      if (path.startsWith('/sign-in') || path == '/') {
        return '/jobs';
      }
    } else {
      if (path.startsWith('/jobs') ||
          path.startsWith('/entries') ||
          path.startsWith('/account')) {
        return '/';
      }
    }
    return null;
  },
  refreshListenable: GoRouterRefreshStream(Auth().authStateChanges()),
  routes: [
    GoRoute(path: '/',
    name: landing,
    builder: (context, goRouteState){
      return LandingPage(
        databaseBuilder: (uid) => FirestoreDatabase(uid: uid),
      );
    },
    routes: [
    GoRoute(
    path: 'sign-in',
    name: signIn,
    pageBuilder: (context, state)
    {
      return MaterialPage(
          fullscreenDialog: true,
          child: EmailSignInPage());
    }
),],
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
              name: jobs,
              pageBuilder: (context, state)
              {
                final uid = Provider.of<AuthBase>(context, listen: false).currentUser?.uid ?? '';
                return NoTransitionPage(
                  child: Provider<Database?>(
                      create: (_) =>
                          FirestoreDatabase(uid:uid),
                      child: JobsPage(uid: uid)));
                },
              routes: [
                GoRoute(
                  path: 'edit',
                  name: editJob,
                  pageBuilder: (context, state)
                  {
                    final job = state.extra as Job?;
                    final uid = Provider.of<AuthBase>(context, listen: false).currentUser?.uid ?? '';
                    return MaterialPage(
                        fullscreenDialog: true,
                        child: EditJobPage(database: FirestoreDatabase(uid: uid), job: job,));}
                ),
                GoRoute(
                  path: 'entry',
                  name: jobEntry,
                  pageBuilder: (context, state)
                  {
                    final entryJob = state.extra as EntryJobCombinedModel;
                    final uid = Provider.of<AuthBase>(context, listen: false).currentUser?.uid ?? '';
                    return  MaterialPage(
                      child: EntryPage(database: FirestoreDatabase(uid: uid), job: entryJob.job, entry: entryJob.entry),
                      fullscreenDialog: true,
                    );}
                ),
                GoRoute(
                  path: 'entries',
                  name: jobEntries,
                  pageBuilder: (context, state)
                  {
                    final job = state.extra as Job;
                    final uid = Provider.of<AuthBase>(context, listen: false).currentUser?.uid ?? '';
                    return
                      CupertinoPage(
                        fullscreenDialog: false,
                        child: JobEntriesPage(database: FirestoreDatabase(uid: uid), job: job),
                      );
                  }
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
              name: entries,
              pageBuilder: (context, state)
              {
                final uid = Provider.of<AuthBase>(context, listen: false).currentUser?.uid ?? '';
                return NoTransitionPage(
                  child: Provider<Database?>(
                    create: (_) =>
                        FirestoreDatabase(uid: uid),
                    child: Consumer<Database>(
                      builder: (BuildContext context, value, Widget? child) {
                        return Provider<EntriesBloc>(
                          create: (_) => EntriesBloc(database: value),
                          child: const EntriesPage(),
                        );
                      },
                    ),
                  ));},
              routes: const [],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorAccountKey,
          routes: [
            GoRoute(
              path: '/account',
              name: account,
              pageBuilder: (context, state) => NoTransitionPage(
                child: AccountPage.create(context),
              ),
              routes: const [
              ],
            ),
          ],
        ),

      ],
    ),
  ],
);

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}