import 'package:cloudyml_app2/payment_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PayNowBottomSheet extends StatelessWidget {
  ValueListenable<double> currentPosition;
  ValueListenable<double> popBottomSheetAt;
  String coursePrice;
  Map<String, dynamic> map;
  bool isItComboCourse;
  // double closeBottomSheetAt;

  PayNowBottomSheet({
    required this.currentPosition,
    required this.coursePrice,
    required this.map,
    required this.popBottomSheetAt,
    required this.isItComboCourse,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      builder: (BuildContext context) {
        return ValueListenableBuilder(
          valueListenable: currentPosition,
          builder: (BuildContext context, double value, Widget? child) {
            return ValueListenableBuilder(
              valueListenable: popBottomSheetAt,
              builder: (BuildContext context, double position, Widget? child) {
                if (value > 0.0 && /*value < 500 && */ value <= position) {
                  return Container(
                    height: 80,
                    width: MediaQuery.of(context).size.width,
                    // duration: Duration(milliseconds: 1000),
                    // curve: Curves.easeIn,
                    child: Center(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              coursePrice,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Medium',
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaymentScreen(
                                      map: map,
                                      isItComboCourse: isItComboCourse,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 60,
                                // width: 300,
                                color: Color(0xFF7860DC),
                                child: Center(
                                  child: Text(
                                    'Pay Now',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Medium',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container(
                    height: 0.1,
                  );
                }
              },
            );
          },
        );
      },
      onClosing: () {},
    );
  }
}
