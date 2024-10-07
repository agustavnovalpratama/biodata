import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:biodata_project/models/api.dart';
import 'package:biodata_project/models/msiswa.dart';
import 'package:http/http.dart' as http;

import 'form.dart';

class Edit extends StatefulWidget {
  final SiswaModel sw;

  Edit({required this.sw});

  @override
  State<StatefulWidget> createState() => EditState();
}

class EditState extends State<Edit> {
  final formkey = GlobalKey<FormState>();

  late TextEditingController nameController, birthController, religionController, genderController, addressController;

  Future editSw() async {
    return await http.post(
        Uri.parse(BaseUrl.edit),
        body: {
          "id": widget.sw.id.toString(),
          "name": nameController.text,
          "birth": birthController.text,
          "religion": religionController.text,
          "gender": genderController.text,
          "address": addressController.text
        }
    );
  }

  void _showToast() {
    Fluttertoast.showToast(
      msg: "Data updated successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _onConfirm(context) async {
    http.Response response = await editSw();
    final data = json.decode(response.body);
    if (data['success']) {
      _showToast();
      Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    nameController = TextEditingController(text: widget.sw.name);
    birthController = TextEditingController(text: widget.sw.birth);
    religionController = TextEditingController(text: widget.sw.religion);
    genderController = TextEditingController(text: widget.sw.gender);
    addressController = TextEditingController(text: widget.sw.address);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Student",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 4.0,
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          child: Text(
            "Update",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.orange,
            padding: EdgeInsets.symmetric(vertical: 15),
          ),
          onPressed: () {
            _onConfirm(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Update Student Information",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 20),
            AppForm(
              formkey: formkey,
              nameController: nameController,
              birthController: birthController,
              religionController: religionController,
              addressController: addressController,
              genderController: genderController,
            ),
          ],
        ),
      ),
    );
  }
}
