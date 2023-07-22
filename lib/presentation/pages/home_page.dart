import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('coba'),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              List<Row> dataTest = [];
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasData) {
                final tests = snapshot.data?.docs.reversed.toList();
                for (var test in tests!) {
                  final testWidget = Row(
                    children: [
                      Text(test['name']),
                      Text(test['role']),
                    ],
                  );
                  dataTest.add(testWidget);
                }
              } else {
                return const Text('kosong');
              }

              return Expanded(
                child: ListView(
                  children: dataTest,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
