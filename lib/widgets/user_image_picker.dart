import 'package:flutter/material.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key});

  @override
  State<UserImagePicker> createState() {
    return _UserImagePickerState();
  }
}

class _UserImagePickerState extends State<UserImagePicker> {
  @override
  Widget build(context) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage: ...,
        ),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.upload_file),
          label: Text(
            'Add an Image',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
        )
      ],
    );
  }
}
