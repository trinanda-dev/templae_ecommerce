import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/custom_surfix_icon.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/provider/invitation_code_provider/invitation_code_provider.dart';
import 'package:shop_app/provider/signup_provider/signup_provider.dart';
import 'package:shop_app/screens/sign_up/sign_up_screen.dart';

class InvitationCodeForm extends StatefulWidget {
  const InvitationCodeForm({super.key});

  @override
  State<InvitationCodeForm> createState() => _InvitationCodeFormState();
}

class _InvitationCodeFormState extends State<InvitationCodeForm> {
  final _formKey = GlobalKey<FormState>();
  String? invitationCode;
  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final invitationCodeProvider = Provider.of<InvitationCodeProvider>(context);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            cursorColor: kPrimaryColor,
            onSaved: (newValue) => invitationCode = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kInvitationCodeNullError);
              } else if (invitationCodeValidatorRegExp.hasMatch(value)) {
                removeError(error: kInvalidInvitationCode);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kInvitationCodeNullError);
                return "";
              } else if (!invitationCodeValidatorRegExp.hasMatch(value)) {
                addError(error: kInvalidInvitationCode);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Kode Undangan",
              hintText: "Masukkan kode undangan Anda",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
            ),
          ),
          FormError(errors: errors),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: invitationCodeProvider.isLoading
              ? null
              : () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                try {
                  await invitationCodeProvider.validateCode(invitationCode!);

                  if (invitationCodeProvider.isCodeValid) {
                    if (!mounted) return;
                    // Kode undangan disimpan di Provider dan bisa diambil di halaman lain
                    Provider.of<SignUpProvider>(context, listen: false).setInvitationCode(invitationCode!);
                    Navigator.pushNamed(
                      context, 
                      SignUpScreen.routeName
                    );
                  } else {
                    addError(error: "Kode undangan tidak valid");
                  }
                } catch (e) {
                  addError(error: e.toString());
                }
              }
            },
            child: invitationCodeProvider.isLoading
              ? SizedBox(
                height: 40,
                width: 40,
                child: Lottie.asset(
                  'assets/lottie/loading-2.json',
                  fit: BoxFit.cover,
                ),
              )
              : const Text("Selanjutnya"),
          ),
        ],
      ),
    );
  }
}
