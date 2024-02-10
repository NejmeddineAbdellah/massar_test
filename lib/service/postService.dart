// ignore_for_file: file_names

import 'dart:convert';

import 'package:massar_test/model/post.dart';
import 'package:http/http.dart' as http;

// ignore: camel_case_types
class postService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<Post>> chargerPosts() async {
    try {
      final reponse = await http.get(Uri.parse(baseUrl));

      if (reponse.statusCode == 200) {
        final List<dynamic> donnees = json.decode(reponse.body);
        return donnees.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Échec du chargement des Posts');
      }
    } catch (e) {
      throw Exception('Une erreur s\'est produite: $e');
    }
  }

  Future<void> supprimerPost(int id) async {
    try {
      final reponse = await http.delete(Uri.parse('$baseUrl/$id'));

      if (reponse.statusCode != 204) {
        throw Exception('Échec de la suppression du post');
      }
    } catch (e) {
      throw Exception('Une erreur s\'est produite lors de la suppression: $e');
    }
  }
}
