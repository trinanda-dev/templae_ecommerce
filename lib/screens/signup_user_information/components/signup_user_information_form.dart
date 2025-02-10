import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/signup_user_informations/signup_user_information_provider.dart';

import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import '../../complete_profile/complete_profile_screen.dart';

class SignupUserInformationForm extends StatefulWidget {
  const SignupUserInformationForm({super.key});

  @override
  State<SignupUserInformationForm> createState() => _SignupUserInformationFormState();
}

class _SignupUserInformationFormState extends State<SignupUserInformationForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  String? name;
  String? storeName;
  String? phoneNumber;

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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            onSaved: (newValue) => name = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kNamelNullError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kNamelNullError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Nama",
              hintText: "Masukkan nama Anda",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            onSaved: (newValue) => storeName = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kStoreNameNullError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kStoreNameNullError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Nama Toko",
              hintText: "Masukkan nama toko Anda",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            keyboardType: TextInputType.phone,
            onSaved: (newValue) => phoneNumber = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kPhoneNumberNullError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kPhoneNumberNullError);
                return "";
              } else if (!phoneNumberValidatorRegExp.hasMatch(value)) {
                addError(error: kInvalidPhoneNumber);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Nomor HP",
              hintText: "Masukkan nomor telepon Anda",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
            ),
          ),
          const SizedBox(height: 20),
          FormError(errors: errors),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                // Simpan data di SignupUserInformation provider
                Provider.of<SignupUserInformationProvider>(context, listen: false).setSignUpData(
                  name: name,
                  storeName: storeName,
                  phoneNumber: phoneNumber,
                );
                // If all data are correct then save form.
                Navigator.push(
                  context, 
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: const CompleteProfileScreen(),
                  )
                );
              }
            },
            child: const Text("Selanjutnya"),
          ),
        ],
      ),
    );
  }
}
