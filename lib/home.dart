import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Added Google Fonts for modern typography
import 'package:biodata_project/tambah.dart';
import 'package:biodata_project/models/msiswa.dart';
import 'package:biodata_project/models/api.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:async';

import 'detail.dart';

class Home extends StatefulWidget {
  @override
  Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  late Future<List<SiswaModel>> sw;

  @override
  void initState() {
    super.initState();
    sw = getSwList();
  }

  Future<List<SiswaModel>> getSwList() async {
    final response = await http.get(Uri.parse(BaseUrl.data));
    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    List<SiswaModel> sw = items.map<SiswaModel>((json) {
      return SiswaModel.fromJson(json);
    }).toList();
    return sw;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "List Data Siswa",
          style: GoogleFonts.poppins( // Modern font style
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo, // Changed AppBar color for a more modern look
        elevation: 2.0,
      ),
      body: Container(
        color: Colors.grey[100], // Light background for better contrast
        child: FutureBuilder<List<SiswaModel>>(
          future: sw,
          builder: (BuildContext context, AsyncSnapshot<List<SiswaModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No data found'));
            }

            return ListView.builder(
              padding: EdgeInsets.all(12), // Added padding for better layout
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                var data = snapshot.data![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Detail(sw: data)));
                  },
                  child: Card(
                    elevation: 4, // Softer shadow
                    margin: EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Smooth rounded corners
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16), // More padding for better touch area
                      leading: Hero( // Added hero animation for the avatar
                        tag: data.name,
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.indigoAccent,
                          child: Icon(Icons.person, color: Colors.white, size: 30),
                        ),
                      ),
                      title: Text(
                        data.name,
                        style: GoogleFonts.poppins( // Custom font for title
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        "${data.religion}, ${data.birth}",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigoAccent,
        hoverColor: Colors.purpleAccent,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => FormTambah()));
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
