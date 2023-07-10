import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/custom_colors.dart';
import '../theme.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    Key? key,
    required TextEditingController controller,
    required FocusNode focusNode,
    required TextInputType keyboardType,
    required TextInputAction inputAction,
    required String label,
    required String hint,
    required Function(String value) validator,
    this.isObscure = false,
    this.isCapitalized = false,
  })  : _emailController = controller,
        _emailFocusNode = focusNode,
        _keyboardtype = keyboardType,
        _inputAction = inputAction,
        _label = label,
        _hint = hint,
        _validator = validator,
        super(key: key);

  final TextEditingController _emailController;
  final FocusNode _emailFocusNode;
  final TextInputType _keyboardtype;
  final TextInputAction _inputAction;
  final String _label;
  final String _hint;
  final bool isObscure;
  final bool isCapitalized;
  final Function(String) _validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: _emailController,
        focusNode: _emailFocusNode,
        keyboardType: _keyboardtype,
        obscureText: isObscure,
        textCapitalization:
            isCapitalized ? TextCapitalization.words : TextCapitalization.none,
        textInputAction: _inputAction,
        cursorColor: Colors.blue,
        style: subStyle,
        validator: (value) => _validator(value!),
        decoration: InputDecoration(
          labelText: _label,
          labelStyle: TextStyle(color: Colors.blue.shade200),
          hintText: _hint,
          hintStyle: subStyle,
          errorStyle: TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: Colors.blue.shade200,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: Colors.redAccent,
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: Colors.redAccent,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}


