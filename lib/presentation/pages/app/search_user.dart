import 'package:bank_sampah/presentation/widgets/user_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/router.dart';
import '../../../domain/entities/user.dart';

class SearchUser extends SearchDelegate {
  final List<User> users;

  SearchUser({
    required this.users,
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear_rounded),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(
        Icons.arrow_back_ios_new_rounded,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<User> matchQuery = [];
    for (var user in users) {
      if (user.fullName!.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(user);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) => UserListTile.listUser(
        user: matchQuery[index],
        enabled: true,
        onTap: () => context.goNamed(AppRouterName.adminEditUserName, pathParameters: {'userId': matchQuery[index].id}),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
