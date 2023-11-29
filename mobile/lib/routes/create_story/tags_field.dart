import 'package:memories_app/util/utils.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:flutter/material.dart';

class TagsField extends StatelessWidget {
  const TagsField({
    required this.tags,
    super.key,
  });

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return TextFieldTags(
      textSeparators: const <String>[
        " ", //seperate with space
        ',' //sepearate with comma as well
      ],
      initialTags: tags,
      onTag: (String tag) {
        //this will give tag when entered new single tag
        tags.add(tag);
      },
      onDelete: (String tag) {
        //this will give single tag on delete
        tags.remove(tag);
      },
      validator: (String tag) {
        //add validation for tags
        if (tag.length < 3) {
          return "Enter tag up to 3 characters.";
        }
        return null;
      },
      tagsStyler: TagsStyler(
          //styling tag style
          tagTextStyle: const TextStyle(color: Colors.white),
          tagDecoration: BoxDecoration(
            color: AppColors.buttonColor,
            borderRadius: BorderRadius.circular(SpaceSizes.x8),
          ),
          tagCancelIcon:
              const Icon(Icons.cancel, size: 18.0, color: Colors.white),
          tagPadding: const EdgeInsets.all(6.0)),
      textFieldStyler: TextFieldStyler(
          //styling tag text field
          helperText: '',
          hintText: "Enter tags",
          textFieldBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SpaceSizes.x8),
              borderSide: const BorderSide(color: Colors.blue, width: 2))),
    );
  }
}
