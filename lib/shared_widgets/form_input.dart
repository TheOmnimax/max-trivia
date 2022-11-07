import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInput extends StatefulWidget {
  const TextInput({
    required this.label,
    required this.onChanged,
    this.initialValue = '',
    this.inputFormatters = const <TextInputFormatter>[],
    this.textCapitalization = TextCapitalization.sentences,
    this.validator,
    Key? key,
  }) : super(key: key);

  final String label;
  final Function(String) onChanged;
  final String initialValue;
  final String? Function(String?)? validator;
  final List<TextInputFormatter> inputFormatters;
  final TextCapitalization textCapitalization;

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    final initialValue = widget.initialValue;
    final tc = TextEditingController()
      ..text = initialValue
      ..selection =
          TextSelection.fromPosition(TextPosition(offset: initialValue.length));
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 200,
        child: TextFormField(
          controller: tc,
          decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: const Color.fromARGB(100, 237, 237, 237),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Colors.blueAccent,
                    width: 1.0,
                  )),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              labelText: widget.label),
          inputFormatters: widget.inputFormatters,
          maxLength: 20,
          maxLines: 1,
          onChanged: widget.onChanged,
          textCapitalization: widget.textCapitalization,
          validator: widget.validator,
        ),
      ),
    );
  }
}
