import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:style_board/auth/auth_provider.dart';

class MyPicksPage extends StatelessWidget {
  const MyPicksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userId = authProvider.user!.uid;

    final Query myPicksQuery = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('myPicks')
        .orderBy('createdAt', descending: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 Pick'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: myPicksQuery.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('저장된 Pick이 없습니다.'));
          }

          final picks = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: picks.length,
            itemBuilder: (context, index) {
              final pick = picks[index];
              final pickName = pick['name'];
              final top = pick['상의'];
              final bottom = pick['하의'];
              final outer = pick['아우터'];
              final shoes = pick['신발'];

              return _PickCard(
                pickName: pickName,
                top: top,
                bottom: bottom,
                outer: outer,
                shoes: shoes,
              );
            },
          );
        },
      ),
    );
  }
}

class _PickCard extends StatefulWidget {
  final String pickName;
  final String top;
  final String bottom;
  final String outer;
  final String shoes;

  const _PickCard({
    required this.pickName,
    required this.top,
    required this.bottom,
    required this.outer,
    required this.shoes,
  });

  @override
  State<_PickCard> createState() => _PickCardState();
}

class _PickCardState extends State<_PickCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final photos = {
      '상의': widget.top,
      '하의': widget.bottom,
      '아우터': widget.outer,
      '신발': widget.shoes,
    }.entries.toList();

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Column(
          children: [
            ListTile(
              title: Text(
                widget.pickName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            if (_isExpanded)
              GridView.builder(
                padding: const EdgeInsets.all(16),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  final photoEntry = photos[index];
                  final category = photoEntry.key;
                  final imagePath = photoEntry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: imagePath.startsWith('http') ||
                                  imagePath.startsWith('https')
                              ? Image.network(
                                  imagePath,
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                  height: double.infinity,
                                )
                              : Image.file(
                                  File(imagePath),
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                        ),
                      ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
