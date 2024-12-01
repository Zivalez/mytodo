import 'package:flutter/material.dart';  
import 'package:provider/provider.dart';  
import 'package:mytodo/page/themeprovider.dart';   

class HomeScreen extends StatelessWidget {  
  const HomeScreen({Key? key}) : super(key: key);  

  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      appBar: _buildAppBar(),  
      body: _buildBody(context),  
    );  
  }  

  AppBar _buildAppBar() {  
    return AppBar(  
      centerTitle: true,  
      title: const Text(  
        'Welcome',  
        style: TextStyle(fontFamily: 'SFProRounded'),  
      ),  
      backgroundColor: Colors.deepOrange,  
    );  
  }  

  Widget _buildBody(BuildContext context) {  
    final themeProvider = Provider.of<ThemeProvider>(context);  

    return SingleChildScrollView(  
      child: Center(  
        child: Column(  
          mainAxisAlignment: MainAxisAlignment.center,  
          children: [  
            const SizedBox(height: 20),  
            InkWell(  
              borderRadius: BorderRadius.circular(20), // Sesuaikan radius yang diinginkan  
              onTap: () {  
                showModalBottomSheet(  
                  context: context,  
                  builder: (BuildContext context) {  
                    return Container(  
                      padding: EdgeInsets.all(20),  
                      child: Column(  
                        mainAxisSize: MainAxisSize.min,  
                        children: [  
                          Text(  
                            '~ Tim Pengembang ~',  
                            style: TextStyle(  
                              fontSize: 24,  
                              fontWeight: FontWeight.bold,  
                              fontFamily: 'SFProRounded',  
                            ),  
                          ),  
                          SizedBox(height: 10),  
                          Text(  
                            'Aditya Dharma (17220350)\n'  
                            'Faisal Sidauruk (17220312)\n'  
                            'Dheny Pujilaksono (17220812)\n'  
                            'Dinu Kurniawan C. (17220824)\n',  
                            textAlign: TextAlign.center,  
                            style: TextStyle(  
                              fontSize: 16,  
                              fontFamily: 'SFProRounded',  
                            ),  
                          ),  
                        ],  
                      ),  
                    );  
                  },  
                );  
              },  
              child: Container(  
                width: 220,  
                height: 220,  
                decoration: BoxDecoration(  
                  borderRadius: BorderRadius.circular(20), // Ganti dari shape: BoxShape.circle  
                  boxShadow: [  
                    BoxShadow(  
                      color: Colors.black26,  
                      blurRadius: 10,  
                      offset: Offset(0, 5),  
                    )  
                  ],  
                  image: DecorationImage(  
                    image: AssetImage('assets/images/UBSI.png'),  
                    fit: BoxFit.cover,  
                  ),  
                ),  
              ),  
            ),

            const SizedBox(height: 20),  
            Text(  
              'MOBILE PROGRAMMING',  
              style: TextStyle(  
                fontSize: 24,   
                fontWeight: FontWeight.bold,  
                fontFamily: 'SFProRounded',  
              ),  
            ),  
            const SizedBox(height: 10),  
            // Daftar nama  
            ..._buildNameList(),  
            
            const SizedBox(height: 20),  
            ElevatedButton.icon(  
              onPressed: () {  
                themeProvider.toggleTheme();  
              },  
              icon: Icon(  
                themeProvider.isDarkMode   
                  ? Icons.light_mode   
                  : Icons.dark_mode  
              ),  
              label: Text(  
                themeProvider.isDarkMode   
                  ? 'Ganti ke Light Mode'   
                  : 'Ganti ke Dark Mode',  
                style: TextStyle(  
                  fontFamily: 'SFProRounded',  
                ),  
              ),  
              style: ElevatedButton.styleFrom(  
                backgroundColor: Colors.deepOrange,  
                foregroundColor: Colors.white,  
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),  
                shape: RoundedRectangleBorder(  
                  borderRadius: BorderRadius.circular(10),  
                ),  
              ),  
            ),  
          ],  
        ),  
      ),  
    );  
  }  

  // Metode untuk membuat daftar nama  
  List<Widget> _buildNameList() {  
    List<String> names = [  
      '',  
      'Menggabungkan ide dan rencana',  
      'Semua dalam satu aplikasi',  
      '',  
      'Klik logo ubsi untuk informasi anggota',  
    ];  

    return names.map((name) => Padding(  
      padding: const EdgeInsets.symmetric(vertical: 5),  
      child: Text(  
        name,  
        style: TextStyle(  
          fontSize: 20,   
          fontWeight: FontWeight.bold,  
          fontFamily: 'SFProRounded',  
        ),  
      ),  
    )).toList();  
  }  
}