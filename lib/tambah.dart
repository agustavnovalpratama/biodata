import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:biodata_project/models/api.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart'; // Added Google Fonts

class FormTambah extends StatefulWidget {
  const FormTambah({super.key});

  @override
  State<StatefulWidget> createState() => FormTambahState();
}

class FormTambahState extends State<FormTambah> {
  final formkey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController birthController = TextEditingController();
  TextEditingController religionController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  String _genderWarga = "";
  final _status = ["Pria", "Wanita"];

  final List<String> items = [
    'Islam',
    'Kristen',
    'Katolik',
    'Hindu',
    'Budha',
    'Konghucu',
  ];
  String? selectedValue;

  Future createSw() async {
    return await http.post(
      Uri.parse(BaseUrl.tambah),
      body: {
        'name': nameController.text,
        'gender': _genderWarga,
        'birth': birthController.text,
        'religion': selectedValue ?? 'Tidak Dipilih',
        'address': addressController.text,
      },
    );
  }

  void _onConfirm(context) async {
    http.Response response = await createSw();
    final data = json.decode(response.body);
    if (data['success']) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tambah Data Siswa",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigoAccent, // Modern color for the AppBar
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Better padding for mobile
          child: Form(
            key: formkey,
            child: Column(
              children: [
                _textboxName(),
                _textboxGender(),
                _textboxBirth(),
                _textboxReligion(),
                _textboxAddress(),
                const SizedBox(height: 30.0), // Give space between the form and button
                _tombolSimpan(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _textboxName() {
    return _buildTextField(
      controller: nameController,
      label: "Student Name",
      icon: Icons.person,
    );
  }

  _textboxGender() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.wc, color: Colors.indigoAccent),
              const SizedBox(width: 10.0),
              Text(
                "Student Gender",
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          RadioGroup<String>.builder(
            groupValue: _genderWarga,
            onChanged: (value) => setState(() {
              _genderWarga = value ?? '';
            }),
            items: _status,
            itemBuilder: (item) => RadioButtonBuilder(
              item,
              textPosition: RadioButtonTextPosition.right,
            ),
            activeColor: Colors.indigoAccent,
            fillColor: Colors.indigoAccent,
          ),
        ],
      ),
    );
  }

  _textboxReligion() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      decoration: _boxDecoration(),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Student Religion',
          labelStyle: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
          prefixIcon: Icon(Icons.mosque, color: Colors.indigoAccent),
          border: InputBorder.none,
        ),
        isExpanded: true,
        items: items
            .map((String item) => DropdownMenuItem<String>(
          value: item,
          child: Text(item, style: GoogleFonts.poppins(fontSize: 14)),
        ))
            .toList(),
        value: selectedValue,
        onChanged: (String? value) {
          setState(() {
            selectedValue = value;
          });
        },
      ),
    );
  }

  _textboxBirth() {
    return _buildTextField(
      controller: birthController,
      label: "Student Birthday",
      icon: Icons.cake,
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );

        if (pickedDate != null) {
          setState(() {
            birthController.text = "${pickedDate.toLocal()}".split(' ')[0];
          });
        }
      },
    );
  }

  _textboxAddress() {
    return _buildTextField(
      controller: addressController,
      label: "Student Address",
      icon: Icons.add_home,
    );
  }

  _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      decoration: _boxDecoration(),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
          prefixIcon: Icon(icon, color: Colors.indigoAccent),
          border: InputBorder.none,
        ),
      ),
    );
  }

  _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  _tombolSimpan() {
    return ElevatedButton(
      onPressed: () {
        _onConfirm(context);
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5.0,
        shadowColor: Colors.grey.withOpacity(0.5),
      ),
      child: Text(
        'Submit',
        style: GoogleFonts.poppins(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
