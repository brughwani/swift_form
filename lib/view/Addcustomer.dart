import 'package:flutter/material.dart';

class AddCustomer extends StatelessWidget {
  const AddCustomer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Customer Name',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Address',
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            
            // Handle submit logic here
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}