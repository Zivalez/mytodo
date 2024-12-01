import 'package:flutter/material.dart';  
import 'package:http/http.dart' as http;  
import 'dart:convert';  

class SearchScreen extends StatefulWidget {  
  @override  
  _SearchScreenState createState() => _SearchScreenState();  
}  

class _SearchScreenState extends State<SearchScreen> {  
  final TextEditingController _searchController = TextEditingController();  
  List<dynamic> _searchResults = [];  
  bool _isSearching = false;  

  Future<void> _performSearch(String query) async {  
    if (query.isEmpty) {  
      setState(() {  
        _searchResults = [];  
        _isSearching = false;  
      });  
      return;  
    }  

    setState(() {  
      _isSearching = true;  
    });  

    try {  
      final apiUrl = 'https://6735a0a75995834c8a936f0e.mockapi.io/api/v5/items';  
      final response = await http.get(Uri.parse(apiUrl));  

      if (response.statusCode == 200) {  
        List<dynamic> allItems = json.decode(response.body);  

        // Tambahkan print untuk debugging  
        print('Total Items: ${allItems.length}');  
        print('Item Types: ${allItems.map((item) => item['type']).toSet()}');  

        final results = allItems.where((item) {  
          // Debugging print untuk setiap item  
          print('Item: ${item['type']}, Task: ${item['task']}');  

          return (item['type'] == 'todo' || item['type'] == 'notes') &&  
                item['task'].toString().toLowerCase().contains(query.toLowerCase());  
        }).toList();  

        setState(() {  
          _searchResults = results;  
          print('Search Results: ${_searchResults.length}');  
        });  
      } else {  
        print('Gagal melakukan pencarian');  
        setState(() {  
          _searchResults = [];  
        });  
      }  
    } catch (e) {  
      print('Error dalam pencarian: $e');  
      setState(() {  
        _searchResults = [];  
      });  
    }  
  }

  Widget _buildSearchResultItem(dynamic item) {  
  return ListTile(  
    title: Text(item['task']),  
    subtitle: Text('Tipe: ${item['type'] == 'todo' ? 'Tugas' : 'Catatan'}'),  
    trailing: item['type'] == 'todo'  
        ? Checkbox(  
            value: item['completed'] ?? false,  
            onChanged: null,  
          )  
        : null,  
  );  
}

  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      appBar: AppBar(  
        centerTitle: true,  
        title: Text('Pencarian'),  
      ),  
      body: Column(  
        children: [  
          // Search Input  
          Padding(  
            padding: const EdgeInsets.all(8.0),  
            child: TextField(  
              controller: _searchController,  
              decoration: InputDecoration(  
                hintText: 'Cari tugas atau catatan...',  
                prefixIcon: Icon(Icons.search),  
                suffixIcon: IconButton(  
                  icon: Icon(Icons.clear),  
                  onPressed: () {  
                    _searchController.clear();  
                    _performSearch('');  
                  },  
                ),  
                border: OutlineInputBorder(  
                  borderRadius: BorderRadius.circular(10),  
                ),  
              ),  
              onChanged: _performSearch,  
            ),  
          ),  

          // Hasil Pencarian  
          Expanded(  
            child: _isSearching  
                ? (_searchResults.isEmpty  
                    ? Center(child: Text('Tidak ada hasil'))  
                    : ListView.separated(  
                        itemCount: _searchResults.length,  
                        separatorBuilder: (context, index) => Divider(),  
                        itemBuilder: (context, index) {  
                          return _buildSearchResultItem(_searchResults[index]);  
                        },  
                      ))  
                : Center(child: Text('Cari Catatan atau Tugas...')),  
          ),  
        ],  
      ),  
    );  
  }  
}