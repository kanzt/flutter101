// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i8;
import 'package:flutter/material.dart' as _i12;
import 'package:navigation_auto_route_tutorial/group_screens/group_screen.dart'
    as _i7;
import 'package:navigation_auto_route_tutorial/group_screens/tab1_screen.dart'
    as _i9;
import 'package:navigation_auto_route_tutorial/group_screens/tab2_screen.dart'
    as _i10;
import 'package:navigation_auto_route_tutorial/group_screens/tab3_screen.dart'
    as _i11;
import 'package:navigation_auto_route_tutorial/login_screens/login_screen.dart'
    as _i1;
import 'package:navigation_auto_route_tutorial/login_screens/signup_screen.dart'
    as _i2;
import 'package:navigation_auto_route_tutorial/user_screens/user_details_screen.dart'
    as _i5;
import 'package:navigation_auto_route_tutorial/user_screens/user_friends_screen.dart'
    as _i6;
import 'package:navigation_auto_route_tutorial/user_screens/user_profile_screen.dart'
    as _i4;
import 'package:navigation_auto_route_tutorial/user_screens/user_screen.dart'
    as _i3;

class AppRouter extends _i8.RootStackRouter {
  AppRouter([_i12.GlobalKey<_i12.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i8.PageFactory> pagesMap = {
    LoginScreenRoute.name: (routeData) {
      return _i8.AdaptivePage<dynamic>(
          routeData: routeData, child: _i1.LoginScreen());
    },
    SignupScreenRoute.name: (routeData) {
      return _i8.AdaptivePage<dynamic>(
          routeData: routeData, child: _i2.SignupScreen());
    },
    UserScreenRoute.name: (routeData) {
      return _i8.AdaptivePage<dynamic>(
          routeData: routeData, child: _i3.UserScreen());
    },
    UserProfileScreenRoute.name: (routeData) {
      return _i8.AdaptivePage<dynamic>(
          routeData: routeData, child: _i4.UserProfileScreen());
    },
    UserDetailsScreenRoute.name: (routeData) {
      return _i8.AdaptivePage<dynamic>(
          routeData: routeData, child: _i5.UserDetailsScreen());
    },
    UserFriendsScreenRoute.name: (routeData) {
      return _i8.AdaptivePage<dynamic>(
          routeData: routeData, child: _i6.UserFriendsScreen());
    },
    GroupScreenRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<GroupScreenRouteArgs>(
          orElse: () => GroupScreenRouteArgs(id: pathParams.getString('id')));
      return _i8.AdaptivePage<dynamic>(
          routeData: routeData, child: _i7.GroupScreen(id: args.id));
    },
    GroupTab1Router.name: (routeData) {
      return _i8.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i8.EmptyRouterPage());
    },
    GroupTab2Router.name: (routeData) {
      return _i8.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i8.EmptyRouterPage());
    },
    GroupTab3Router.name: (routeData) {
      return _i8.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i8.EmptyRouterPage());
    },
    Tab1ScreenRoute.name: (routeData) {
      return _i8.AdaptivePage<dynamic>(
          routeData: routeData, child: _i9.Tab1Screen());
    },
    Tab2ScreenRoute.name: (routeData) {
      return _i8.AdaptivePage<dynamic>(
          routeData: routeData, child: _i10.Tab2Screen());
    },
    Tab3ScreenRoute.name: (routeData) {
      return _i8.AdaptivePage<dynamic>(
          routeData: routeData, child: _i11.Tab3Screen());
    }
  };

  @override
  List<_i8.RouteConfig> get routes => [
        _i8.RouteConfig('/#redirect',
            path: '/', redirectTo: '/login', fullMatch: true),
        _i8.RouteConfig(LoginScreenRoute.name, path: '/login', children: [
          _i8.RouteConfig('*#redirect',
              path: '*',
              parent: LoginScreenRoute.name,
              redirectTo: '',
              fullMatch: true)
        ]),
        _i8.RouteConfig(SignupScreenRoute.name, path: '/signup', children: [
          _i8.RouteConfig('*#redirect',
              path: '*',
              parent: SignupScreenRoute.name,
              redirectTo: '',
              fullMatch: true)
        ]),
        _i8.RouteConfig(UserScreenRoute.name, path: '/user', children: [
          _i8.RouteConfig(UserProfileScreenRoute.name,
              path: '', parent: UserScreenRoute.name),
          _i8.RouteConfig(UserDetailsScreenRoute.name,
              path: 'details/*', parent: UserScreenRoute.name),
          _i8.RouteConfig(UserFriendsScreenRoute.name,
              path: 'friends/*', parent: UserScreenRoute.name),
          _i8.RouteConfig(GroupScreenRoute.name,
              path: 'group/:id',
              parent: UserScreenRoute.name,
              children: [
                _i8.RouteConfig(GroupTab1Router.name,
                    path: 'tab1',
                    parent: GroupScreenRoute.name,
                    children: [
                      _i8.RouteConfig(Tab1ScreenRoute.name,
                          path: '', parent: GroupTab1Router.name),
                      _i8.RouteConfig('*#redirect',
                          path: '*',
                          parent: GroupTab1Router.name,
                          redirectTo: '',
                          fullMatch: true)
                    ]),
                _i8.RouteConfig(GroupTab2Router.name,
                    path: 'tab2',
                    parent: GroupScreenRoute.name,
                    children: [
                      _i8.RouteConfig(Tab2ScreenRoute.name,
                          path: '', parent: GroupTab2Router.name),
                      _i8.RouteConfig('*#redirect',
                          path: '*',
                          parent: GroupTab2Router.name,
                          redirectTo: '',
                          fullMatch: true)
                    ]),
                _i8.RouteConfig(GroupTab3Router.name,
                    path: 'tab3',
                    parent: GroupScreenRoute.name,
                    children: [
                      _i8.RouteConfig(Tab3ScreenRoute.name,
                          path: '', parent: GroupTab3Router.name),
                      _i8.RouteConfig('*#redirect',
                          path: '*',
                          parent: GroupTab3Router.name,
                          redirectTo: '',
                          fullMatch: true)
                    ])
              ]),
          _i8.RouteConfig('*#redirect',
              path: '*',
              parent: UserScreenRoute.name,
              redirectTo: '',
              fullMatch: true)
        ]),
        _i8.RouteConfig('*#redirect',
            path: '*', redirectTo: '/login', fullMatch: true)
      ];
}

/// generated route for [_i1.LoginScreen]
class LoginScreenRoute extends _i8.PageRouteInfo<void> {
  const LoginScreenRoute({List<_i8.PageRouteInfo>? children})
      : super(name, path: '/login', initialChildren: children);

  static const String name = 'LoginScreenRoute';
}

/// generated route for [_i2.SignupScreen]
class SignupScreenRoute extends _i8.PageRouteInfo<void> {
  const SignupScreenRoute({List<_i8.PageRouteInfo>? children})
      : super(name, path: '/signup', initialChildren: children);

  static const String name = 'SignupScreenRoute';
}

/// generated route for [_i3.UserScreen]
class UserScreenRoute extends _i8.PageRouteInfo<void> {
  const UserScreenRoute({List<_i8.PageRouteInfo>? children})
      : super(name, path: '/user', initialChildren: children);

  static const String name = 'UserScreenRoute';
}

/// generated route for [_i4.UserProfileScreen]
class UserProfileScreenRoute extends _i8.PageRouteInfo<void> {
  const UserProfileScreenRoute() : super(name, path: '');

  static const String name = 'UserProfileScreenRoute';
}

/// generated route for [_i5.UserDetailsScreen]
class UserDetailsScreenRoute extends _i8.PageRouteInfo<void> {
  const UserDetailsScreenRoute() : super(name, path: 'details/*');

  static const String name = 'UserDetailsScreenRoute';
}

/// generated route for [_i6.UserFriendsScreen]
class UserFriendsScreenRoute extends _i8.PageRouteInfo<void> {
  const UserFriendsScreenRoute() : super(name, path: 'friends/*');

  static const String name = 'UserFriendsScreenRoute';
}

/// generated route for [_i7.GroupScreen]
class GroupScreenRoute extends _i8.PageRouteInfo<GroupScreenRouteArgs> {
  GroupScreenRoute({required String id, List<_i8.PageRouteInfo>? children})
      : super(name,
            path: 'group/:id',
            args: GroupScreenRouteArgs(id: id),
            rawPathParams: {'id': id},
            initialChildren: children);

  static const String name = 'GroupScreenRoute';
}

class GroupScreenRouteArgs {
  const GroupScreenRouteArgs({required this.id});

  final String id;

  @override
  String toString() {
    return 'GroupScreenRouteArgs{id: $id}';
  }
}

/// generated route for [_i8.EmptyRouterPage]
class GroupTab1Router extends _i8.PageRouteInfo<void> {
  const GroupTab1Router({List<_i8.PageRouteInfo>? children})
      : super(name, path: 'tab1', initialChildren: children);

  static const String name = 'GroupTab1Router';
}

/// generated route for [_i8.EmptyRouterPage]
class GroupTab2Router extends _i8.PageRouteInfo<void> {
  const GroupTab2Router({List<_i8.PageRouteInfo>? children})
      : super(name, path: 'tab2', initialChildren: children);

  static const String name = 'GroupTab2Router';
}

/// generated route for [_i8.EmptyRouterPage]
class GroupTab3Router extends _i8.PageRouteInfo<void> {
  const GroupTab3Router({List<_i8.PageRouteInfo>? children})
      : super(name, path: 'tab3', initialChildren: children);

  static const String name = 'GroupTab3Router';
}

/// generated route for [_i9.Tab1Screen]
class Tab1ScreenRoute extends _i8.PageRouteInfo<void> {
  const Tab1ScreenRoute() : super(name, path: '');

  static const String name = 'Tab1ScreenRoute';
}

/// generated route for [_i10.Tab2Screen]
class Tab2ScreenRoute extends _i8.PageRouteInfo<void> {
  const Tab2ScreenRoute() : super(name, path: '');

  static const String name = 'Tab2ScreenRoute';
}

/// generated route for [_i11.Tab3Screen]
class Tab3ScreenRoute extends _i8.PageRouteInfo<void> {
  const Tab3ScreenRoute() : super(name, path: '');

  static const String name = 'Tab3ScreenRoute';
}
