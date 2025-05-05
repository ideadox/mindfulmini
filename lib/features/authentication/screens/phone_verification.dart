import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';

import 'package:mindfulminis/common/widgets/gradient_scaffold.dart';
import 'package:mindfulminis/features/signup/screens/create_account.dart';

class PhoneVerification extends StatelessWidget {
  const PhoneVerification({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return GradientScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios_new)),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  'Verification',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 20),
                Text(
                  'We’ve send you the verification code on  +1 2625 0023 7615',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 30),

                OtpTextField(
                  borderWidth: 1,
                  fieldHeight: 50,
                  fieldWidth: width / 8,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  numberOfFields: 6,
                  borderColor: Color(0xFF512DA8),
                  //set to true to show as box or false to show as dash
                  showFieldAsBox: true,
                  //runs when a code is typed in
                  onCodeChanged: (String code) {
                    //handle validation or checks here
                  },
                  borderRadius: BorderRadius.circular(8),
                  //runs when every textfield is filled
                  onSubmit: (String verificationCode) {}, // end onSubmit
                ),
                SizedBox(height: 20),
                GradientButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return CreateAccount();
                        },
                      ),
                    );
                    SmartDialog.show(
                      builder: (context) {
                        return Container(
                          height: 400,
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        // border: Border.all(
                                        //   width: 0.2,
                                        //   color: Colors.grey,
                                        // ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade200,
                                            spreadRadius: 6,
                                            blurRadius: 5,
                                            offset: const Offset(
                                              1,
                                              3,
                                            ), // changes position of shadow
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                      ),
                                      child: Icon(Icons.close),
                                    ),
                                  ],
                                ),
                              ),

                              Text(
                                'Successfully Verified',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22,
                                ),
                              ),
                              SizedBox(height: 20),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          'Get ready to onboard our  mindful moments.',
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),

                              SizedBox(
                                width: 160,
                                height: 40,
                                child: GradientButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return CreateAccount();
                                        },
                                      ),
                                    );
                                  },
                                  child: Center(child: Text('Next')),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Verify',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward_outlined),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text.rich(
                      TextSpan(children: [TextSpan(text: 'Re-send code in')]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
