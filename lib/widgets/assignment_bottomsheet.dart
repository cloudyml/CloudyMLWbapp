import 'dart:math';

import 'package:cloudyml_app2/utils/utils.dart';
import 'package:flutter/material.dart';

Future<dynamic> showAssignmentBottomSheet(
    BuildContext context, double horizontalScale, double verticalScale) {
  return showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    context: context,
    builder: (context) {
      return Container(
        // width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'As assignments cant open on mobile please open below link on Laptop browser to get Assignment and Course certificates.',
              textAlign: TextAlign.center,
              textScaleFactor: min(horizontalScale, verticalScale),
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SelectableText('https://courses.cloudyml.com/s/store',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),),
              Text('To Open LMS On Mobile Please Click Below',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Color(0xFF7860DC),
                ),
              ),
              onPressed: () {
                Utils.openLink(Url: 'https://courses.cloudyml.com/s/store');
              },
              child: Text('Open Url'),
            ),
          ],
        ),
      );
    },
  );
}
