import 'package:flutter/material.dart';  
import 'package:http/http.dart' as http;  
import 'dart:convert';  
import 'package:mytodo/helpers/user_info.dart';  
import 'package:mytodo/page/login.dart';  
import 'package:mytodo/service/profile_service.dart';  
import 'package:mytodo/service/user_service.dart';  

class ProfileImageService {  
  Future<String> getProfileImageUrl() async {  
    try {  
      final response = await http.get(  
        Uri.parse('https://randomuser.me/api/'),  
      );  

      if (response.statusCode == 200) {  
        final data = json.decode(response.body);  
        return data['results'][0]['picture']['large'];  
      } else {  
        // Fallback ke gambar default  
        return 'https://via.placeholder.com/200';  
      }  
    } catch (e) {  
      print('Error fetching profile image: $e');  
      return 'https://via.placeholder.com/200';  
    }  
  }  
}  

class ProfileScreen extends StatefulWidget {  
  const ProfileScreen({Key? key}) : super(key: key);  

  @override  
  _ProfileScreenState createState() => _ProfileScreenState();  
} 
class _ProfileScreenState extends State<ProfileScreen> with AutomaticKeepAliveClientMixin {  
  String _currentUsername = '';  
  String _profileImageUrl = '';  
  final _usernameController = TextEditingController();  
  final _passwordController = TextEditingController();  
  List<String> _connectedUsers = []; // Daftar pengguna yang terhubung  
  bool _isLoading = false; 

  @override  
  bool get wantKeepAlive => true;

  @override  
  void initState() {  
    super.initState();  
    _loadProfileData();  
  }    

  Future<void> _loadProfileData() async {  
    setState(() {  
      _isLoading = true;  
    });  

    try {  
      // Load username  
      String? username = await UserInfo().getUsername();  
      
      // Load profile image  
      String imageUrl = await ProfileImageService().getProfileImageUrl();  

      // Load connected users  
      List<String> users = await UserService().getAllUsers();  
      
      setState(() {  
        _currentUsername = username ?? 'Pengguna';  
        _usernameController.text = _currentUsername;  
        _profileImageUrl = imageUrl;  
        _connectedUsers = users;  
        _isLoading = false;  
      });  
    } catch (e) {  
      setState(() {  
        _isLoading = false;  
      });  
      ScaffoldMessenger.of(context).showSnackBar(  
        SnackBar(  
          content: Text('Gagal memuat data profil'),  
          backgroundColor: Colors.red,  
        ),  
      );  
    }  
  }  

  void _showEditProfileDialog() {  
    showDialog(  
      context: context,  
      builder: (BuildContext context) {  
        return AlertDialog(  
          title: Text('Edit Profil'),  
          content: Column(  
            mainAxisSize: MainAxisSize.min,  
            children: [  
              TextField(  
                controller: _usernameController,  
                decoration: InputDecoration(  
                  labelText: 'Username Baru',  
                  border: OutlineInputBorder(),  
                ),  
              ),  
              SizedBox(height: 10),  
              TextField(  
                controller: _passwordController,  
                obscureText: true,  
                decoration: InputDecoration(  
                  labelText: 'Ganti Password Jika Perlu',  
                  border: OutlineInputBorder(),  
                ),  
              ),  
            ],  
          ),  
          actions: [  
            TextButton(  
              onPressed: () {  
                Navigator.of(context).pop();  
              },  
              child: Text('Batal'),  
            ),  
            ElevatedButton(  
              onPressed: () async {  
                // Validasi input  
                if (_usernameController.text.isEmpty) {  
                  ScaffoldMessenger.of(context).showSnackBar(  
                    SnackBar(content: Text('Username tidak boleh kosong')),  
                  );  
                  return;  
                }  

                // Panggil service untuk update profil  
                bool success = await ProfileService().updateProfile(  
                  currentUsername: _currentUsername,  
                  newUsername: _usernameController.text,  
                  newPassword: _passwordController.text.isNotEmpty   
                    ? _passwordController.text   
                    : null,  
                );  

                if (success) {  
                  // Update username di local storage  
                  await UserInfo().setUsername(_usernameController.text);  
                  
                  // Refresh tampilan  
                  await _loadProfileData();  

                  // Tutup dialog  
                  Navigator.of(context).pop();  

                  // Tampilkan pesan sukses  
                  ScaffoldMessenger.of(context).showSnackBar(  
                    SnackBar(  
                      content: Text('Profil berhasil diperbarui'),  
                      backgroundColor: Colors.green,  
                    ),  
                  );  
                } else {  
                  // Tampilkan pesan error  
                  ScaffoldMessenger.of(context).showSnackBar(  
                    SnackBar(  
                      content: Text('Gagal memperbarui profil'),  
                      backgroundColor: Colors.red,  
                    ),  
                  );  
                }  
              },  
              child: Text('Simpan'),  
            ),  
          ],  
        );  
      },  
    );  
  }  

  @override  
  Widget build(BuildContext context) {  
    super.build(context); // Diperlukan untuk AutomaticKeepAliveClientMixin  
    return Scaffold(  
      appBar: AppBar(  
        title: Text('Profil Pengguna'),  
        actions: [  
          IconButton(  
            icon: Icon(Icons.refresh),  
            onPressed: _loadProfileData,  
          ),  
        ],  
      ),  
      body: RefreshIndicator(  
        onRefresh: _loadProfileData,  
        child: _isLoading   
          ? Center(child: CircularProgressIndicator())  
          : Padding(  
          padding: const EdgeInsets.all(16.0),  
          child: Column(  
            crossAxisAlignment: CrossAxisAlignment.center,  
            children: [  
              // Foto profil dari API  
              CircleAvatar(  
                radius: 60,  
                backgroundImage: _profileImageUrl.isNotEmpty  
                  ? NetworkImage(_profileImageUrl)  
                  : null,  
                child: _profileImageUrl.isEmpty   
                  ? Icon(Icons.person, size: 80)   
                  : null,  
              ),  
              SizedBox(height: 20),  

              // Username aktif  
              Text(  
                _currentUsername,  
                style: TextStyle(  
                  fontSize: 24,  
                  fontWeight: FontWeight.bold,  
                ),  
              ),  
              SizedBox(height: 10),  

              // Tombol Edit Username  
              ElevatedButton.icon(  
                onPressed: _showEditProfileDialog,  
                icon: Icon(Icons.edit),  
                label: Text('Edit Username'),   
              ),  
              SizedBox(height: 10),  

              // Spacer untuk mendorong konten ke atas  
              Spacer(),  

              // Daftar pengguna yang terhubung  
              Row(  
                mainAxisAlignment: MainAxisAlignment.center,  
                children: [  
                  Text(  
                    'User Connected: ${_connectedUsers.length}',  
                    style: TextStyle(  
                      fontSize: 18,  
                      fontWeight: FontWeight.bold,  
                    ),  
                  ),  
                  SizedBox(width: 10),  
                  // Tombol untuk melihat detail pengguna  
                  ElevatedButton(  
                    onPressed: () {  
                      _showConnectedUsersDialog(context);  
                    },  
                    child: Text('Lihat Daftar'),  
                    style: ElevatedButton.styleFrom(  
                      minimumSize: Size(50, 30),  
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),  
                    ),  
                  ),  
                ],  
              ),  
              SizedBox(height: 20),  

              // Tombol Logout  
              Container(  
                width: double.infinity,  
                padding: EdgeInsets.symmetric(horizontal: 16),  
                child: ElevatedButton(  
                  style: ElevatedButton.styleFrom(  
                    backgroundColor: Colors.red,  
                  ),  
                  onPressed: () async {  
                    // Hapus token  
                    await UserInfo().clearToken();  
                    
                    // Navigasi ke halaman login  
                    Navigator.of(context).pushAndRemoveUntil(  
                      MaterialPageRoute(builder: (context) => Login()),   
                      (Route<dynamic> route) => false  
                    );  
                  },  
                  child: Text(  
                    'Logout',  
                    style: TextStyle(color: Colors.white),  
                  ),  
                ),  
              ),  
            ],  
          ),  
        ),  
      ),  
    );  
  }  

  // Method untuk menampilkan dialog daftar pengguna  
  void _showConnectedUsersDialog(BuildContext context) {  
    showDialog(  
      context: context,  
      builder: (BuildContext context) {  
        return AlertDialog(  
          title: Text('Daftar Pengguna Terhubung'),  
          content: Container(  
            width: double.maxFinite,  
            child: ListView.builder(  
              shrinkWrap: true,  
              itemCount: _connectedUsers.length,  
              itemBuilder: (context, index) {  
                return ListTile(  
                  title: Text(_connectedUsers[index]),  
                  leading: Icon(Icons.person),  
                );  
              },  
            ),  
          ),  
          actions: [  
            TextButton(  
              onPressed: () {  
                Navigator.of(context).pop();  
              },  
              child: Text('Tutup'),  
            ),  
          ],  
        );  
      },  
    );  
  }  
}