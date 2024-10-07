import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:biodata_project/models/api.dart';
import 'package:biodata_project/models/msiswa.dart';
import 'edit.dart';

class Detail extends StatefulWidget {
  final SiswaModel sw;
  Detail({required this.sw});

  @override
  State<StatefulWidget> createState() => DetailState();
}

class DetailState extends State<Detail> {
  void deleteSiswa(context) async {
    http.Response response = await http.post(
      Uri.parse(BaseUrl.hapus),
      body: {
        'id': widget.sw.id.toString(),
      },
    );
    final data = json.decode(response.body);
    if (data['success']) {
      _showToast();
      Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    }
  }

  void _showToast() {
    Fluttertoast.showToast(
      msg: "Data deletion successful",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void confirmDelete(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Confirmation", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: Text('Are you sure you want to delete this data?', style: GoogleFonts.poppins()),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
              child: Text('Cancel', style: GoogleFonts.poppins()),
            ),
            ElevatedButton(
              onPressed: () => deleteSiswa(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Delete', style: GoogleFonts.poppins()),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Student Details",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 4.0,
        actions: [
          IconButton(
            onPressed: () => confirmDelete(context),
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(Icons.perm_identity, 'ID: ', widget.sw.id.toString()),
            Divider(),
            _buildDetailRow(Icons.person, 'Name: ', widget.sw.name),
            Divider(),
            _buildDetailRow(Icons.wc, 'Gender: ', widget.sw.gender),
            Divider(),
            _buildDetailRow(Icons.cake, 'Birth: ', widget.sw.birth),
            Divider(),
            _buildDetailRow(Icons.book, 'Religion: ', widget.sw.religion),
            Divider(),
            _buildDetailRow(Icons.location_on, 'Address: ', widget.sw.address),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => Edit(sw: widget.sw)),
        ),
        child: Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 28, color: Colors.blue),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            '$label$value',
            style: GoogleFonts.poppins(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
