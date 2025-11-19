import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:annapurna/providers/auth_controller.dart';
import 'package:annapurna/core/routes/app_route_const.dart';

class MainDrawer extends ConsumerWidget {
  const MainDrawer(
      {super.key,
      required this.onSelectScreen,
      required this.userName,
      required this.profileImage});

  final void Function(String identifier) onSelectScreen;
  final String? userName;
  final String? profileImage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authProvider.notifier);
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
              padding: EdgeInsetsDirectional.all(40.r), //20
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.primaryContainer
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )),
              child: Row(
                children: [
                  profileImage != null
                      ? Image.asset(
                          profileImage!,
                          height: 20.h,
                        )
                      : Icon(
                          Icons.person,
                          size: 48, // 48
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  SizedBox(
                    width: 5.h, // 18
                  ),
                  Text(
                    userName != null ? userName! : 'User',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  )
                ],
              )),
          ListTile(
            leading: Icon(
              Icons.restaurant,
              size: 26,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            title: Text(
              'Meals',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 50.sp, //24
                  ),
            ),
            onTap: () {
              onSelectScreen('meals');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              size: 26,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            title: Text(
              'Filters',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 50.sp, // 24
                  ),
            ),
            onTap: () {
              onSelectScreen('filters');
            },
          ),
          const Divider(
            thickness: 1,
          ),
          Align(
            alignment: Alignment.topRight,
            child: TextButton.icon(
                onPressed: () async {
                  auth.logOut();
                  context.go(RoutePath.login);
                },
                icon: const Icon(
                  Icons.logout_rounded,
                  size: 18,
                ),
                label: const Text('Log out')),
          )
        ],
      ),
    );
  }
}
