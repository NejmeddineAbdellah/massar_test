// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:massar_test/DetailsPost/detailsPost.dart';
import 'package:massar_test/model/post.dart';
import 'package:massar_test/service/postService.dart';

class PostListWidget extends StatefulWidget {
  const PostListWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PostListWidgetState createState() => _PostListWidgetState();
}

class _PostListWidgetState extends State<PostListWidget> {
  final postService _postService = postService();
  late Future<List<Post>> _postListFuture;
  final TextEditingController _searchController = TextEditingController();
  List<Post> _allPosts = [];
  List<Post> _visiblePosts = [];
  int _currentPage = 0;
  final int _postsPerPage = 4;

  @override
  void initState() {
    super.initState();
    _postListFuture = _postService.chargerPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filterPosts,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Post>>(
              future: _postListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('An error occurred: ${snapshot.error}'),
                  );
                } else {
                  _allPosts = snapshot.data!;
                  _visiblePosts = _allPosts.sublist(
                    _currentPage * _postsPerPage,
                    (_currentPage + 1) * _postsPerPage,
                  );
                  return ListView.builder(
                    itemCount: _visiblePosts.length,
                    itemBuilder: (context, index) {
                      final post = _visiblePosts[index];
                      return Card(
                        child: ListTile(
                          title: Text(post.title),
                          subtitle: Text('Word Count: ${post.getWordCount()}'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PostDetailsScreen(post: post),
                              ),
                            );
                          },
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deletePost(post),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _currentPage == 0
                    ? null
                    : () => setState(() => _currentPage--),
                color: _currentPage == 0 ? Colors.grey : Colors.blue,
              ),
              const SizedBox(width: 20),
              Text(
                '${_currentPage + 1} / ${(_allPosts.length / _postsPerPage).ceil()}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: _currentPage >=
                        (_allPosts.length / _postsPerPage).ceil() - 1
                    ? null
                    : () => setState(() => _currentPage++),
                color: _currentPage >=
                        (_allPosts.length / _postsPerPage).ceil() - 1
                    ? Colors.grey
                    : Colors.blue,
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _deletePost(Post post) {
    setState(() {
      _allPosts.remove(post);
      _visiblePosts.remove(post);
    });
    _postService.supprimerPost(post.id);
  }

  void _filterPosts(String query) {
    List<Post> filteredPosts = _allPosts
        .where((post) =>
            post.title.toLowerCase().contains(query.toLowerCase()) ||
            post.body.toLowerCase().contains(query.toLowerCase()) ||
            post.userId
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            post.id.toString().toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      _visiblePosts.clear();
      _visiblePosts.addAll(filteredPosts);
      _currentPage = 0;
    });
  }
}
