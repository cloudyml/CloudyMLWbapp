import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatelessWidget {
  AboutUs({Key? key}) : super(key: key);

  final LinearGradient _gradient = const LinearGradient(colors: [
    Color.fromARGB(255, 9, 235, 16),
    Color.fromARGB(255, 9, 130, 230)
  ]);
  final Uri _linkedin = Uri.parse('https://www.linkedin.com/company/cloudyml/');
  final Uri _instagram = Uri.parse('https://www.instagram.com/cloudyml.akash/');
  final Uri _youtube = Uri.parse('https://www.youtube.com/c/cloudyML/videos');
  final Uri _facebook = Uri.parse('https://www.facebook.com/cloudymlakash');
  final Uri _telegram = Uri.parse('https://web.telegram.org/k/');

  @override
  Widget build(BuildContext context) {
    //final Image = imageTemp('asset/cloudyml.jpeg');
    final ImageFounder = imageFounder('assets/image.jpeg');
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: const [
                    Image(
                      // height: MediaQuery.of(context).size.height / 3,
                      // fit: BoxFit.cover,
                      image: AssetImage('assets/about_us.png'),
                    ),
                    Positioned(
                      bottom: -50.0,
                      right: 40,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage('assets/image01.jpg'),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 70,
                ),
                // Container(
                //   child: ImageFounder,
                // ),
                const SizedBox(
                  height: 20,
                ),
                ShaderMask(
                    shaderCallback: (Rect rect) {
                      return _gradient.createShader(rect);
                    },
                    child: Column(
                      children: [
                        Text(
                          'AKASH RAJ',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 237, 235, 247)),
                        ),
                        Text(
                          'Data Scientist @Tredence Analytics',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 237, 235, 247)),
                        ),
                        Text(
                          'Ex - TCS Digital | YouTuber',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 237, 235, 247)),
                        ),
                        Text(
                          'Founder : CLOUDYML',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 237, 235, 247)),
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 20,
                ),
                // Container(
                //     //alignment: Alignment.center,
                //     width: double.infinity,
                //     height: 120,
                //     decoration: const BoxDecoration(
                //         gradient: LinearGradient(colors: [
                //       Color.fromARGB(255, 39, 7, 218),
                //       Color.fromARGB(255, 157, 58, 238),
                //       // Color.fromARGB(255, 45, 218, 60),
                //     ])),
                //     child: const Padding(
                //         padding: EdgeInsets.all(10.0),
                //         child: Text.rich(TextSpan(
                //             text: 'AKASH RAJ \n',
                //             style: TextStyle(
                //                 fontSize: 25,
                //                 fontWeight: FontWeight.bold,
                //                 color: Colors.white),
                //             children: [
                //               TextSpan(
                //                 text: 'Data Scientist @ Tredence Analytics\n',
                //                 style: TextStyle(
                //                     fontSize: 19,
                //                     fontWeight: FontWeight.bold,
                //                     color: Colors.white),
                //               ),
                //               TextSpan(
                //                 text: 'Ex-TCS Digital | Youtuber \n',
                //                 style: TextStyle(
                //                     fontSize: 19,
                //                     fontWeight: FontWeight.bold,
                //                     color: Colors.white),
                //               ),
                //               TextSpan(
                //                 text: 'Founder : CLOUDYML',
                //                 style: TextStyle(
                //                     fontSize: 19,
                //                     fontWeight: FontWeight.bold,
                //                     color: Colors.white),
                //               ),
                //             ])))),
                Container(
                    //alignment: Alignment.center,
                    width: double.infinity,
                    height: 100,
                    // decoration: const BoxDecoration(
                    //     gradient: LinearGradient(colors: [
                    //   Color.fromARGB(255, 39, 7, 218),
                    //   Color.fromARGB(255, 157, 58, 238),
                    //   // Color.fromARGB(255, 45, 218, 60),
                    // ]),),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'I have 3+ years experience in Machine Learning. I have done 4 industrial IoT Machine Learning projects which includes data-preprocessing, data cleaning, feature selection, model building, optimization and deployment to AWS Sagemaker.  Now, I even started my YouTube channel for sharing my ML and AWS knowledge.',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    )),
                    // SizedBox(height: 10,),
                Container(
                    //alignment: Alignment.center,
                    width: double.infinity,
                    height: 100,
                    // decoration: const BoxDecoration(
                    //     gradient: LinearGradient(colors: [
                    //   Color.fromARGB(255, 39, 7, 218),
                    //   Color.fromARGB(255, 157, 58, 238),
                    //   // Color.fromARGB(255, 45, 218, 60),
                    // ])),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Currently, I work with Tredence Inc. as a Data Scientist for the AI CoE (Center of Excellence) team. Here I work on challenging R&D projects and building various PoCs for winning new client projects for the company.',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    )),
                Container(
                    //alignment: Alignment.center,
                    width: double.infinity,
                    height: 135,
                    // decoration: const BoxDecoration(
                    //     gradient: LinearGradient(colors: [
                    //   Color.fromARGB(255, 39, 7, 218),
                    //   Color.fromARGB(255, 157, 58, 238),
                    //   // Color.fromARGB(255, 45, 218, 60),
                    // ])),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'When I had put papers in previous company, I practically had no offer. First 2 months were very difficult and disappointing as I couldn’t land any offer. But things suddenly started working out in the last month and I was able to bag 8 offers from various banks, analytical companies and some startups.',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    )),
                Container(
                    //alignment: Alignment.center,
                    width: double.infinity,
                    height: 80,
                    // decoration: const BoxDecoration(
                    //     gradient: LinearGradient(colors: [
                    //   Color.fromARGB(255, 39, 7, 218),
                    //   Color.fromARGB(255, 157, 58, 238),
                    //   // Color.fromARGB(255, 45, 218, 60),
                    // ])),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'I made this website to use all my interview experiences to help people land their dream job.',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    )),
                // const SizedBox(
                //   height: 20,
                // ),
                Container(
                  child: ShaderMask(
                    shaderCallback: (Rect rect) {
                      return _gradient.createShader(rect);
                    },
                    child: Text(
                      'FOLLOW US ON SOCIAL MEDIA',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 84, 238, 84)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: _linkedInUrl,
                          icon: const Icon(
                            FontAwesomeIcons.linkedin,
                            color: Color.fromARGB(255, 4, 39, 238),
                            size: 40,
                          )),
                      const SizedBox(
                        width: 15,
                      ),
                      IconButton(
                          onPressed: _instagramUrl,
                          icon: const Icon(
                            FontAwesomeIcons.instagram,
                            color: Color.fromARGB(255, 238, 5, 180),
                            size: 40,
                          )),
                      const SizedBox(
                        width: 15,
                      ),
                      IconButton(
                          onPressed: _facebookUrl,
                          icon: const Icon(
                            FontAwesomeIcons.facebook,
                            color: Color.fromARGB(255, 13, 64, 202),
                            size: 40,
                          )),
                      const SizedBox(
                        width: 15,
                      ),
                      IconButton(
                          onPressed: _youtubeUrl,
                          icon: const Icon(
                            FontAwesomeIcons.youtube,
                            color: Colors.red,
                            size: 40,
                          )),
                      const SizedBox(
                        width: 15,
                      ),
                      IconButton(
                          onPressed: _telegramUrl,
                          icon: const Icon(
                            FontAwesomeIcons.telegram,
                            color: Colors.lightBlue,
                            size: 40,
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget imageTemp(String url) {
    return Image.asset(
      url,
      width: 50,
      height: 50,
    );
  }

  Widget imageFounder(String url) {
    return Image.asset(
      url,
      height: 640,
      width: 360,
    );
  }

  void _linkedInUrl() async {
    if (!await launchUrl(_linkedin)) throw 'Could not launch $_linkedin';
  }

  void _instagramUrl() async {
    if (!await launchUrl(_instagram)) throw 'Could not launch $_instagram';
  }

  void _facebookUrl() async {
    if (!await launchUrl(_facebook)) throw 'Could not launch $_facebook';
  }

  void _youtubeUrl() async {
    if (!await launchUrl(_youtube)) throw 'Could not launch $_youtube';
  }

  void _telegramUrl() async {
    if (!await launchUrl(_telegram)) throw 'Could not launch $_telegram';
  }
}