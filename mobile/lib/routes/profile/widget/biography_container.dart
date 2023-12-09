import 'package:flutter/material.dart';
import 'package:memories_app/routes/profile/model/profile_repository.dart';

const String placeholder = "Enter your biography";

class EditableBiography extends StatefulWidget {
  final String? biography;

  const EditableBiography({super.key, this.biography});

  @override
  EditableBiographyState createState() => EditableBiographyState();
}

class EditableBiographyState extends State<EditableBiography> {
  bool _isEditing = false;
  late TextEditingController _editingController;

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController(text: widget.biography);
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _isEditing
                  ? TextField(
                      controller: _editingController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 3,
                      decoration: const InputDecoration(
                        hintText: placeholder,
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.only(left: 10, top: 10, bottom: 10),
                      ),
                    )
                  : Padding(
                      padding:
                          const EdgeInsets.only(left: 10, top: 10, bottom: 10,),
                      child: Text(
                        widget.biography?.isEmpty ?? true
                            ? placeholder
                            : _editingController.text,
                      ),
                    ),
            ),
            IconButton(
              icon: Icon(_isEditing ? Icons.save : Icons.edit),
              onPressed: () {
                setState(() {
                  if (_isEditing) {
                    ProfileRepositoryImp()
                        .updateBiography(_editingController.value.text);
                  }
                  _isEditing = !_isEditing;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
