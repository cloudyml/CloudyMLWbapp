import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
        // backgroundColor: C,
        shadowColor: Color.fromARGB(255, 129, 31, 194),
        backgroundColor: Color.fromARGB(255, 129, 31, 194),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Container(
            // color:Colors.grey.shade700,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Privacy Policy',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Medium',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Who we are',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Medium',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'Our website address is: https://www.cloudyml.com.',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Medium',
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'Comments',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Medium',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'When visitors leave comments on the site we collect the data shown in the comments form, and also the visitor’s IP address and browser user agent string to help spam detection.',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Medium',
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'An anonymized string created from your email address (also called a hash) may be provided to the Gravatar service to see if you are using it. The Gravatar service privacy policy is available here: https://automattic.com/privacy/. After approval of your comment, your profile picture is visible to the public in the context of your comment.',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Medium',
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'Links',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Medium',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'When you click on links on our store, they may direct you away from our site. We are not responsible for the privacy practices of other sites and encourage you to read their privacy statements.',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Medium',
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'Media',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Medium',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'If you upload images to the website, you should avoid uploading images with embedded location data (EXIF GPS) included. Visitors to the website can download and extract any location data from images on the website.',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Medium',
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'PAYMENT',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Medium',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'We use Razorpay for processing payments. We/Razorpay do not store your card data on their servers. The data is encrypted through the Payment Card Industry Data Security Standard (PCI-DSS) when processing payment. Your purchase transaction data is only used as long as is necessary to complete your purchase transaction. After that is complete, your purchase transaction information is not saved.',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Medium',
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'Our payment gateway adheres to the standards set by PCI-DSS as managed by the PCI Security Standards Council, which is a joint effort of brands like Visa, MasterCard, American Express and Discover.',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Medium',
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'PCI-DSS requirements help ensure the secure handling of credit card information by our store and its service providers.',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Medium',
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'For more insight, you may also want to read terms and conditions of razorpay on https://razorpay.com',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Medium',
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'Cookies',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Medium',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'If you leave a comment on our site you may opt-in to saving your name, email address and website in cookies. These are for your convenience so that you do not have to fill in your details again when you leave another comment. These cookies will last for one year.',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Medium',
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'If you visit our login page, we will set a temporary cookie to determine if your browser accepts cookies. This cookie contains no personal data and is discarded when you close your browser.',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Medium',
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'When you log in, we will also set up several cookies to save your login information and your screen display choices. Login cookies last for two days, and screen options cookies last for a year. If you select “Remember Me”, your login will persist for two weeks. If you log out of your account, the login cookies will be removed.',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Medium',
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'If you edit or publish an article, an additional cookie will be saved in your browser. This cookie includes no personal data and simply indicates the post ID of the article you just edited. It expires after 1 day.',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Medium',
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'Embedded content from other websites',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Medium',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'Articles on this site may include embedded content (e.g. videos, images, articles, etc.). Embedded content from other websites behaves in the exact same way as if the visitor has visited the other website.',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Medium',
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'These websites may collect data about you, use cookies, embed additional third-party tracking, and monitor your interaction with that embedded content, including tracking your interaction with the embedded content if you have an account and are logged in to that website.',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Medium',
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'Who we share your data with',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Medium',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'If you request a password reset, your IP address will be included in the reset email.',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Medium',
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'How long we retain your data',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Medium',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'If you leave a comment, the comment and its metadata are retained indefinitely. This is so we can recognize and approve any follow-up comments automatically instead of holding them in a moderation queue.',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Medium',
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'For users that register on our website (if any), we also store the personal information they provide in their user profile. All users can see, edit, or delete their personal information at any time (except they cannot change their username). Website administrators can also see and edit that information.',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Medium',
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'What rights you have over your data',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Medium',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'If you have an account on this site, or have left comments, you can request to receive an exported file of the personal data we hold about you, including any data you have provided to us. You can also request that we erase any personal data we hold about you. This does not include any data we are obliged to keep for administrative, legal, or security purposes.',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Medium',
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'Where we send your data',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Medium',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'Visitor comments may be checked through an automated spam detection service.',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Medium',
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'QUESTIONS AND CONTACT INFORMATION',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Medium',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'If you would like to: access, correct, amend or delete any personal information we have about you, register a complaint, or simply want more information contact our Privacy Compliance Officer at CLOUDYML E-LEARNING (OPC) PRIVATE LIMITED or by mail at HINDUSTAN PARK, ST. NO.2, OPPT. L.I.C. ASANSOL, ASANSOL– 713304, West Bengal. ',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Medium',
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'Email Address-Team@cloudyml.com',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Medium',
                  ),
                ),
                Text(
                  'Phone No– +917003482660',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Medium',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}