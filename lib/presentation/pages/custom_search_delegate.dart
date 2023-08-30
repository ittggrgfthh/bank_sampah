import 'package:flutter/material.dart';

import '../../core/constant/default_data.dart';

class CustomSearchDelegate extends SearchDelegate {
  List<String> dummyMonths = DefaultData.months;

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
    List<String> matchQuery = [];
    for (var month in dummyMonths) {
      if (month.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(month);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) => ListTile(title: Text(matchQuery[index])),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var month in dummyMonths) {
      if (month.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(month);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) => ListTile(title: Text(matchQuery[index])),
    );
  }
}
