
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/app/jobs/model/job.dart';
import 'package:time_tracker_app/services/auth.dart';
import 'package:time_tracker_app/services/database.dart';
import 'app/account/screen/account_page.dart';
import 'app/entries/bloc/entries_bloc.dart';
import 'app/entries/screen/entries_page.dart';
import 'app/job_entries/screen/entry_page.dart';
import 'app/job_entries/screen/job_entries_page.dart';
import 'app/jobs/screen/edit_job_page.dart';
import 'app/jobs/screen/jobs_page.dart';
import 'common_widgets/tab_item.dart';
import 'app/landing_page.dart';
import 'common_widgets/scaffold_with_nested_navigation.dart';
import 'navigation.dart';

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
                  name: 'edit-job',
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
                  name: 'job-entry',
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
                  name: 'job-entries',
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
              pageBuilder: (context, state) => const NoTransitionPage(
                child: AccountPage(),
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
