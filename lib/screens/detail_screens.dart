import 'package:flutter/material.dart';

import '../model/user/result.dart';


class DetailScreen extends StatelessWidget {
  final int fromId;
  final List<Result> results;

  const DetailScreen({super.key, required this.fromId, required this.results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Screen'),
      ),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final result = results[index];
          return ListTile(
            title: Text('From ID: $fromId'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Text: ${result.message?.text}'),
                Text('Date: ${result.message?.date}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
