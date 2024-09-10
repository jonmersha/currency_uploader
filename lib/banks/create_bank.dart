import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BankRegistrationForm extends StatefulWidget {
  @override
  _BankRegistrationFormState createState() => _BankRegistrationFormState();
}

class _BankRegistrationFormState extends State<BankRegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _shortNameController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  File? _logoFile;
  bool _isLoading = false;

  Future<void> _pickLogo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _logoFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final formData = {
      'short_name': _shortNameController.text,
      'bank_name': _bankNameController.text,
      'address': _addressController.text,
      'phone_land_line': _phoneController.text,
      'email_address': _emailController.text,
    };

    final uri = Uri.parse('https://service.besheger.com/forex/add/0');
    //final request = http.MultipartRequest('POST', uri);

    // Add text fields to request
    //request.fields.addAll(formData);

    // Add image if selected
    // if (_logoFile != null) {
    //   request.files.add(await http.MultipartFile.fromPath('logo', _logoFile!.path));
    // }

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(formData),
      );

      if (response.statusCode == 200) {
        final responseBody = await response.body;
        final result = json.decode(responseBody);

        setState(() {
          _isLoading = false;
        });

        _showSuccessDialog(result['message'] ?? 'Registration successful!');
      } else {
        setState(() {
          _isLoading = false;
        });

        _showErrorDialog(
            'Registration failed with status: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      _showErrorDialog('An error occurred: $e');
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _clearForm();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _clearForm() {
    _shortNameController.clear();
    _bankNameController.clear();
    _addressController.clear();
    _phoneController.clear();
    _emailController.clear();
    setState(() {
      _logoFile = null;
    });
  }

  @override
  void dispose() {
    _shortNameController.dispose();
    _bankNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank Registration Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _shortNameController,
                      decoration: InputDecoration(labelText: 'Short Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the short name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _bankNameController,
                      decoration: InputDecoration(labelText: 'Bank Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the bank name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(labelText: 'Address'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(labelText: 'Phone Landline'),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email Address'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the email address';
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                            .hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Text('Upload Logo:'),
                        const SizedBox(width: 10),
                        _logoFile != null
                            ? Image.file(_logoFile!, height: 50, width: 50)
                            : Text('No logo selected'),
                        Spacer(),
                        ElevatedButton(
                          onPressed: _pickLogo,
                          child: const Text('Choose File'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
