import 'package:memories_app/util/utils.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:flutter/material.dart';

class TagsField extends StatelessWidget {
  const TagsField({
    super.key,
    required this.tags,
  });

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return TextFieldTags(
      textSeparators: [
        " ", //seperate with space
        ',' //sepearate with comma as well
      ],
      initialTags: tags,
      onTag: (tag) {
        print(tag);
        //this will give tag when entered new single tag
        tags.add(tag);
      },
      onDelete: (tag) {
        print(tag);
        //this will give single tag on delete
        tags.remove(tag);
      },
      validator: (tag) {
        //add validation for tags
        if (tag.length < 3) {
          return "Enter tag up to 3 characters.";
        }
        return null;
      },
      tagsStyler: TagsStyler(
          //styling tag style
          tagTextStyle: TextStyle(color: Colors.white),
          tagDecoration: BoxDecoration(
            color: AppColors.buttonColor,
            borderRadius: BorderRadius.circular(SpaceSizes.x8),
          ),
          tagCancelIcon: Icon(Icons.cancel, size: 18.0, color: Colors.white),
          tagPadding: EdgeInsets.all(6.0)),
      textFieldStyler: TextFieldStyler(
          //styling tag text field
          helperText: "",
          hintText: "Enter tags",
          textFieldBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SpaceSizes.x8),
              borderSide: BorderSide(color: Colors.blue, width: 2))),
    );
  }
}
