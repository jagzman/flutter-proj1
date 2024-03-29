import 'package:flutter/material.dart';
import 'package:otp_text_field_v2/otp_text_field_v2.dart';

class otpText extends StatelessWidget {
  final OtpFieldControllerV2 otpController;
  final bool visble;
  final Function (String?) oncomplete;
  const otpText({super.key, required this.otpController, required this.visble, required this.oncomplete});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visble,
      child: OTPTextFieldV2(
        controller: otpController,
        length: 4,
        width: MediaQuery.of(context).size.width,
        textFieldAlignment: MainAxisAlignment.spaceAround,
        fieldWidth: 45,
        fieldStyle: FieldStyle.box,
        outlineBorderRadius: 15,
        style: TextStyle(fontSize: 17),
        onChanged: (pin) {
          print("Changed: " + pin);
        },
        onCompleted: (pin) {
          oncomplete(pin);
        },
      ),
    );
  }
}
