import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/MyAccount/ChangeEmail.dart';
import 'package:cloudyml_app2/MyAccount/ChangePassword.dart';
import 'package:cloudyml_app2/MyAccount/PhoneVerify.dart';
import 'package:cloudyml_app2/Providers/AppProvider.dart';
import 'package:cloudyml_app2/Providers/UserProvider.dart';
import 'package:cloudyml_app2/authentication/loginform.dart';
import 'package:cloudyml_app2/authentication/phoneauthnew.dart';
import 'package:cloudyml_app2/globals.dart';
import 'package:cloudyml_app2/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String? _username;
  String? _email;
  String? _phoneauthemail;
  String? _mobile;
  XFile? _image;
  bool changeemailreauthenticate = false;
  bool phoneVisibleEdit = false;


  void initState() {
    Provider.of<UserProvider>(context, listen: false).reloadUserModel();
    _email=Provider.of<UserProvider>(context, listen: false).userModel?.email.toString();
    _username=Provider.of<UserProvider>(context, listen: false).userModel?.name.toString();
    _mobile=Provider.of<UserProvider>(context, listen: false).userModel?.mobile.toString();
  }

  GlobalKey<FormState> _formKey = GlobalKey();
  GlobalKey<FormState> _emailformKey = GlobalKey();
  FirebaseFirestore _firestore =FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final userprovider=Provider.of<UserProvider>(context);
    final appprovider=Provider.of<AppProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var verticalScale = height / mockUpHeight;
    var horizontalScale = width / mockUpWidth;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(0),
          children:[
            Stack(
              children: [
                Container(
                  height: 207*verticalScale,
                  width: width,
                  decoration:  BoxDecoration(
                    color: HexColor('7A62DE'),
                    borderRadius: BorderRadius.only(
                      bottomLeft:  Radius.circular(min(horizontalScale,verticalScale)*25),
                      bottomRight:  Radius.circular(min(horizontalScale,verticalScale)*25),
                    ),
                  ),
                ),
                Positioned(
                  top: 41*verticalScale,
                  left: 26*horizontalScale,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back,color: Colors.white,size: 36*min(horizontalScale,verticalScale),),
                    onPressed: () async{
                      FocusScope.of(context).requestFocus(new FocusNode());
                      await Future.delayed(Duration(milliseconds: 60));
                      Navigator.pop(context);
                    },
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: verticalScale*41,
                      ),
                      Text(
                        'Edit Profile',
                        textScaleFactor: min(horizontalScale,verticalScale),
                        style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'SemiBold',
                            color: Colors.white
                        ),
                      ),
                      SizedBox(height: verticalScale*51,),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: InkWell(
                          onTap: (){
                            final _picker=ImagePicker();
                            _selectImagex(_picker.pickImage(source: ImageSource.gallery));
                          },
                          child: SizedBox(
                            child: Container(
                              height: verticalScale*158,
                              width: horizontalScale*158,
                              child: CircleAvatar(
                                radius: min(horizontalScale,verticalScale)*32.0,
                                backgroundColor: HexColor('6153D3'),
                                child: Container(
                                  height: verticalScale*154,
                                  width: horizontalScale*154,
                                  child: CircleAvatar(
                                      radius: min(horizontalScale,verticalScale)*30.0,
                                      backgroundImage:_displayChild(),
                                      backgroundColor: Colors.transparent,
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: CircleAvatar(
                                          radius: min(horizontalScale,verticalScale)*26,
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            Icons.edit,
                                            size: min(horizontalScale,verticalScale)*30,
                                            color: HexColor('6153D3'),
                                          ),
                                        ),
                                      )
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: verticalScale*40,),
                      Text(
                        'Edit Details',
                        textScaleFactor: min(horizontalScale,verticalScale),
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Bold',
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding:  EdgeInsets.fromLTRB(horizontalScale*24,verticalScale*22,horizontalScale*24,verticalScale*24),
                              child: TextFormField(
                                initialValue: _username,
                                decoration: InputDecoration(
                                    hintText: 'Update Your Name',
                                    hintStyle: TextStyle(
                                      fontSize: 20 * min(horizontalScale, verticalScale),
                                    ),
                                    labelText: 'Name',
                                    floatingLabelStyle: TextStyle(
                                        fontSize: 18 * min(horizontalScale, verticalScale),
                                        fontWeight: FontWeight.w500,
                                        color: HexColor('7B62DF')),
                                    labelStyle: TextStyle(
                                      fontSize: 18 * min(horizontalScale, verticalScale),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                        BorderSide(color: HexColor('7B62DF'), width: 2)),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: HexColor('7B62DF'), width: 2),
                                    ),
                                    suffixIcon: Icon(
                                      Icons.person,
                                      color: HexColor('6153D3'),
                                    )),
                                onSaved: (value){
                                  _username=value;
                                },
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter Name';
                                  } else if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                                    return 'Please enter a valid Name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            (userprovider.userModel?.authType=='phoneAuth')?
                            Padding(
                              padding: EdgeInsets.fromLTRB(horizontalScale*24,verticalScale*0,horizontalScale*24,verticalScale*24),
                              child: TextFormField(
                                initialValue: _email,
                                //readOnly: (userprovider.userModel?.authType=='googleAuth')?true:false,
                                //autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                    hintText: 'Update Your Email',
                                    hintStyle: TextStyle(
                                      fontSize: 20 * min(horizontalScale, verticalScale),
                                    ),
                                    labelText: 'Enter New Email',
                                    floatingLabelStyle: TextStyle(
                                        fontSize: 18 * min(horizontalScale, verticalScale),
                                        fontWeight: FontWeight.w500,
                                        color: HexColor('7B62DF')),
                                    labelStyle: TextStyle(
                                      fontSize: 18 * min(horizontalScale, verticalScale),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                        BorderSide(color: HexColor('7B62DF'), width: 2)),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: HexColor('7B62DF'), width: 2),
                                    ),
                                    suffixIcon: Icon(
                                      Icons.email,
                                      color: HexColor('6153D3'),
                                    )),
                                keyboardType: TextInputType.emailAddress,
                                onSaved: (value){
                                  _phoneauthemail=value;
                                },
                                onChanged: (value){
                                  setState((){
                                    _phoneauthemail=value;
                                  });
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter email address';
                                  } else if (!RegExp(
                                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?"
                                      r"(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                      .hasMatch(value)) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                              ),
                            ):Container(),
                            Padding(
                              padding:  EdgeInsets.fromLTRB(horizontalScale*24,verticalScale*0,horizontalScale*24,verticalScale*10),
                              child: TextFormField(
                                initialValue: _mobile,
                                //(userprovider.userModel?.authType=='emailAuth' && userprovider.userModel?.phoneVerified==true)?
                                readOnly: ((userprovider.userModel?.authType=='emailAuth' && userprovider.userModel?.phoneVerified==true)||userprovider.userModel?.authType=='phoneAuth')?true:false,
                                decoration: InputDecoration(
                                    counterText: '',
                                    hintText: 'Update Your Number',
                                    hintStyle: TextStyle(
                                      fontSize: 20 * min(horizontalScale, verticalScale),
                                    ),
                                    labelText: 'Phone Number',
                                    floatingLabelStyle: TextStyle(
                                        fontSize: 18 * min(horizontalScale, verticalScale),
                                        fontWeight: FontWeight.w500,
                                        color: HexColor('7B62DF')),
                                    labelStyle: TextStyle(
                                      fontSize: 18 * min(horizontalScale, verticalScale),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                        BorderSide(color: HexColor('7B62DF'), width: 2)),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: HexColor('7B62DF'), width: 2),
                                    ),
                                    suffixIcon: Icon(
                                      Icons.phone,
                                      color: HexColor('6153D3'),
                                    )

                                ),
                                onSaved: (value){
                                  _mobile=value;
                                },
                                onChanged: (value){
                                  setState((){
                                    _mobile=value;
                                  });
                                },
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter Phone No';
                                  } else if (!RegExp(
                                      r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$')
                                      .hasMatch(value)) {
                                    return 'Please enter a valid Phone Number';
                                  } else if (value.length < 10) {
                                    return 'Enter 10 digit Phone number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      (userprovider.userModel?.phoneVerified==true && FirebaseAuth.instance.currentUser?.phoneNumber=="+91"+_mobile.toString())?
                      Padding(
                        padding: EdgeInsets.fromLTRB(horizontalScale*24,verticalScale*0,horizontalScale*24,verticalScale*2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Verified ',
                              textScaleFactor: min(horizontalScale, verticalScale),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                                //HexColor('#d91f2a'),
                              ),
                            ),
                            Icon(
                              Icons.check_circle_rounded,
                              color: Colors.green,
                              size: 22*min(horizontalScale, verticalScale),
                            )
                          ],
                        ),
                      )
                      :
                      Padding(
                        padding: EdgeInsets.fromLTRB(horizontalScale*24,verticalScale*0,horizontalScale*24,verticalScale*2),
                        child: InkWell(
                          onTap: (){
                            if(_formKey.currentState!.validate()){
                                setState(() {
                                  phoneVisibleEdit = true;
                                });

                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                ' VERIFY ?',
                                textScaleFactor: min(horizontalScale, verticalScale),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: HexColor('#d91f2a'),
                                  //backgroundColor: Colors.red[100]
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: verticalScale * 4,
                      ),
                      (userprovider.userModel?.authType=='emailAuth' && userprovider.userModel?.phoneVerified==true)?
                      Padding(
                        padding:  EdgeInsets.fromLTRB(horizontalScale*24,verticalScale*0,horizontalScale*24,verticalScale*0),
                        child: Text('Note: To change the phone number you have to unlink the phone from the account.',
                          textScaleFactor: min(horizontalScale,verticalScale),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color:  HexColor('#d91f2a'),
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ):Container(),
                      (userprovider.userModel?.authType=='emailAuth' && userprovider.userModel?.phoneVerified==true)?
                      ElevatedButton(
                        onPressed: () async{
                          FocusScope.of(context).requestFocus(new FocusNode());
                          await Future.delayed(Duration(milliseconds: 70));
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    title: Center(
                                      child: Text(
                                        'Unlink?',
                                        textScaleFactor: min(horizontalScale, verticalScale),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    content: Text(
                                      'Do you really want to unlink phone number from these account.You will not be able to undo this action.',
                                      textAlign: TextAlign.center,
                                      textScaleFactor: min(horizontalScale, verticalScale),
                                      style: TextStyle(fontSize: 16,color: Colors.grey[600]),
                                    ),
                                    actions: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () async{
                                              FocusScope.of(context).requestFocus(new FocusNode());
                                              await Future.delayed(Duration(milliseconds: 70));
                                              Navigator.pop(context);
                                            },
                                            child: Padding(
                                              padding:  EdgeInsets.all(min(horizontalScale,verticalScale)*11),
                                              child: Text(
                                                'NO',
                                                textScaleFactor: min(horizontalScale,verticalScale),
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'Bold',
                                                    color: Colors.black
                                                ),
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(min(horizontalScale,verticalScale)*10), // <-- Radius
                                              ),
                                            ),

                                          ),
                                          ElevatedButton(
                                            onPressed: () async{
                                              FocusScope.of(context).requestFocus(new FocusNode());
                                              await Future.delayed(Duration(milliseconds: 70));
                                              User? usernew=FirebaseAuth.instance.currentUser;
                                              List<UserInfo> providerData= usernew!.providerData;
                                              for (UserInfo userInfo in providerData ) {
                                                String providerId = userInfo.providerId;
                                                print("providerId = " + providerId);
                                                //Log.d(TAG, "providerId = " + providerId);
                                              }
                                              usernew.unlink('phone');
                                              _firestore.collection('Users')
                                                  .doc(userprovider.userModel!.id)
                                                  .update({
                                                'phoneVerified':false
                                              });
                                              userprovider.reloadUserModel();
                                               Navigator.pop(context);
                                               //Navigator.pop(context);
                                              //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Phone Unlinked')));
                                            },
                                            child: Padding(
                                              padding:  EdgeInsets.all(min(horizontalScale,verticalScale)*11),
                                              child: Text(
                                                'Yes',
                                                textScaleFactor: min(horizontalScale,verticalScale),
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'Bold',
                                                    color: Colors.white
                                                ),
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: HexColor('7A62DE'),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(min(horizontalScale,verticalScale)*10), // <-- Radius
                                              ),
                                            ),

                                          ),
                                        ],
                                      ),

                                    ]);
                              });
                        },
                        child: Padding(
                          padding:  EdgeInsets.all(min(horizontalScale,verticalScale)*11),
                          child: Text(
                            'Unlink Phone',
                            textScaleFactor: min(horizontalScale,verticalScale),
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Bold',
                                color: Colors.black
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(min(horizontalScale,verticalScale)*10), // <-- Radius
                          ),
                        ),

                      ):Container(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                            ElevatedButton(
                                onPressed: () async{
                                  FocusScope.of(context).requestFocus(new FocusNode());
                                  await Future.delayed(Duration(milliseconds: 70));
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding:  EdgeInsets.all(min(horizontalScale,verticalScale)*11),
                                  child: Text(
                                      'Discard Changes',
                                    textScaleFactor: min(horizontalScale,verticalScale),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Bold',
                                      color: Colors.black
                                    ),
                                  ),
                                ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(min(horizontalScale,verticalScale)*10), // <-- Radius
                                ),
                              ),

                            ),
                          appprovider.isLoading?
                              Loading()
                          : ElevatedButton(
                            onPressed: () async{
                              FocusScope.of(context).requestFocus(new FocusNode());
                              _formKey.currentState!.save();
                              if(_formKey.currentState!.validate()){
                                appprovider.changeIsLoading();
                                if(_image!=null){
                                  late String imageurl;
                                  final FirebaseStorage storage=FirebaseStorage.instance;
                                  final picture ='${userprovider.userModel!.name.toString()} Id:--- ${userprovider.userModel!.id.toString()} Time: ${DateTime.now().microsecondsSinceEpoch.toString()}.jpg';
                                  final File _imagep=File(_image!.path);
                                  UploadTask task =storage.ref().child('Users/${picture}').putFile(_imagep);
                                  TaskSnapshot snapshot=(await task.whenComplete(() => task.snapshot));
                                  await task.whenComplete(() async{
                                    imageurl=await snapshot.ref.getDownloadURL();
                                  });
                                  String image=imageurl;
                                  (userprovider.userModel?.authType=='phoneAuth')?
                                  _firestore.collection('Users')
                                      .doc(userprovider.userModel!.id)
                                      .update({
                                    'name':_username,
                                    'email':_phoneauthemail,
                                    'mobilenumber':_mobile,
                                    'image':image
                                  }): _firestore.collection('Users')
                                      .doc(userprovider.userModel!.id)
                                      .update({
                                    'name':_username,
                                    'mobilenumber':_mobile,
                                    'phoneVerified':(FirebaseAuth.instance.currentUser?.phoneNumber=="+91"+_mobile.toString())?true:false,
                                    'image':image
                                  });
                                  userprovider.reloadUserModel();
                                  await Future.delayed(Duration(seconds: 2));
                                  appprovider.changeIsLoading();
                                  Fluttertoast.showToast(msg: 'Changes Saved');
                                  Navigator.pop(context);
                                }else{
                                  // Fluttertoast.showToast(
                                  //     msg: 'Profile image must be provided');
                                  (userprovider.userModel?.authType=='phoneAuth')?
                                  _firestore.collection('Users')
                                      .doc(userprovider.userModel!.id)
                                      .update({
                                    'name':_username,
                                    'email':_phoneauthemail,
                                    'mobilenumber':_mobile,
                                  }):
                                  _firestore.collection('Users')
                                      .doc(userprovider.userModel!.id)
                                      .update({
                                    'name':_username,
                                    'mobilenumber':_mobile,
                                    'phoneVerified':(FirebaseAuth.instance.currentUser?.phoneNumber=="+91"+_mobile.toString())?true:false,
                                  });
                                  userprovider.reloadUserModel();
                                  await Future.delayed(Duration(seconds: 2));
                                  appprovider.changeIsLoading();
                                  Fluttertoast.showToast(msg: 'Changes Saved');
                                  Navigator.pop(context);
                                  User? user=FirebaseAuth.instance.currentUser;
                                  user!.reload();
                                  print(user.phoneNumber);
                                }
                              }

                            },
                            child: Padding(
                              padding:  EdgeInsets.all(min(horizontalScale,verticalScale)*11),
                              child: Text(
                                'Save Changes',
                                textScaleFactor: min(horizontalScale,verticalScale),
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Bold',
                                    color: Colors.white
                                ),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: HexColor('7A62DE'),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(min(horizontalScale,verticalScale)*10), // <-- Radius
                              ),
                            ),

                          ),

                        ],
                      ),
                      (userprovider.userModel?.authType=='phoneAuth')?
                      Container()
                      :Column(
                        children: [
                          Divider(thickness: 2,),
                          SizedBox(height: 12*verticalScale,),
                          Padding(
                              padding: EdgeInsets.fromLTRB(horizontalScale*24,verticalScale*0,horizontalScale*24,verticalScale*4),
                              child: (userprovider.userModel?.authType=='googleAuth')
                                  ?Text(
                                'Gmail address',
                                textScaleFactor: min(horizontalScale,verticalScale),
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500
                                ),
                              ):Text(
                                'Update your email address',
                                textScaleFactor: min(horizontalScale,verticalScale),
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500
                                ),
                              )
                          ),
                          Form(
                            key: _emailformKey,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(horizontalScale*24,verticalScale*22,horizontalScale*24,verticalScale*10),
                              child: TextFormField(
                                initialValue: _email,
                                readOnly: (userprovider.userModel?.authType=='googleAuth')?true:false,
                                //autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                    hintText: (userprovider.userModel?.authType=='googleAuth')?'Email':'Update Your Email',
                                    hintStyle: TextStyle(
                                      fontSize: 20 * min(horizontalScale, verticalScale),
                                    ),
                                    labelText: (userprovider.userModel?.authType=='googleAuth')?'Email':'Enter New Email',
                                    floatingLabelStyle: TextStyle(
                                        fontSize: 18 * min(horizontalScale, verticalScale),
                                        fontWeight: FontWeight.w500,
                                        color: HexColor('7B62DF')),
                                    labelStyle: TextStyle(
                                      fontSize: 18 * min(horizontalScale, verticalScale),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                        BorderSide(color: HexColor('7B62DF'), width: 2)),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: HexColor('7B62DF'), width: 2),
                                    ),
                                    suffixIcon: Icon(
                                      Icons.email,
                                      color: HexColor('6153D3'),
                                    )),
                                keyboardType: TextInputType.emailAddress,
                                onSaved: (value){
                                  _email=value;
                                },
                                onChanged: (value){
                                  setState((){
                                    _email=value;
                                  });
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter email address';
                                  } else if (!RegExp(
                                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?"
                                      r"(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                      .hasMatch(value)) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          (FirebaseAuth.instance.currentUser?.emailVerified==true && _email==userprovider.userModel?.email)?
                          Padding(
                            padding: EdgeInsets.fromLTRB(horizontalScale*24,verticalScale*0,horizontalScale*24,verticalScale*2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Verified ',
                                  textScaleFactor: min(horizontalScale, verticalScale),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green,
                                    //HexColor('#d91f2a'),
                                  ),
                                ),
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: Colors.green,
                                  size: 22*min(horizontalScale, verticalScale),
                                )
                              ],
                            ),
                          )
                              :Padding(
                            padding: EdgeInsets.fromLTRB(horizontalScale*24,verticalScale*0,horizontalScale*24,verticalScale*2),
                            child: InkWell(
                              onTap: (){
                                // if(_formKey.currentState!.validate()){
                                //     setState(() {
                                //       phoneVisibleEdit = true;
                                //     });
                                //}
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    ' VERIFY ?',
                                    textScaleFactor: min(horizontalScale, verticalScale),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: HexColor('#d91f2a'),
                                      //backgroundColor: Colors.red[100]
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          (userprovider.userModel?.authType=='googleAuth')
                              ?Text('Note: Gmail address cannot be changed',
                            textScaleFactor: min(horizontalScale,verticalScale),
                            style: TextStyle(
                                color:  HexColor('#d91f2a'),
                                fontWeight: FontWeight.w500
                            ),
                          ):(userprovider.userModel?.authType=='emailAuth')?
                          (FirebaseAuth.instance.currentUser?.emailVerified==true && _email==userprovider.userModel?.email)?
                          Container()
                              :ElevatedButton(
                            onPressed: () async{
                              if(_emailformKey.currentState!.validate()){
                                FocusScope.of(context).requestFocus(new FocusNode());
                                await Future.delayed(Duration(milliseconds: 60));
                                userprovider.reloadUserModel();
                                setState((){
                                  changeemailreauthenticate=true;
                                });
                              }
                            },
                            child: Padding(
                              padding:  EdgeInsets.all(min(horizontalScale,verticalScale)*11),
                              child: Text(
                                'Update and Verify Email',
                                textScaleFactor: min(horizontalScale,verticalScale),
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Bold',
                                    color: Colors.white
                                ),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: HexColor('7A62DE'),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(min(horizontalScale,verticalScale)*10), // <-- Radius
                              ),
                            ),

                          ):Container()
                        ],
                      ),
                    ],
                  ),
                ),
                (changeemailreauthenticate)
                    ? Container(
                      height: height,
                      color: Colors.black54,
                      alignment: Alignment.center,
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                width * 0.06)),
                                      ),
                                      child: Text('Reauthenticate',
                                          textScaleFactor:
                                          min(horizontalScale, verticalScale),
                                          style: TextStyle(
                                            color: HexColor('6153D3'),
                                            fontSize: 18,
                                          ))),
                                  SizedBox(
                                    width: horizontalScale * 17,
                                  ),
                                  IconButton(
                                      color: Colors.white,
                                      onPressed: () {
                                        setState(() {
                                          changeemailreauthenticate = false;
                                        });
                                      },
                                      icon: Icon(Icons.clear))
                                ],
                              ),
                              Container(
                                child: AnimatedSwitcher(
                                  duration: Duration(milliseconds: 200),
                                  child: ChangeEmail(newEmail: _email.toString(),),
                                ),
                              )
                            ],
                          ),
                  ),
                      ),
                )
                    : Container(),
                  (phoneVisibleEdit)
                    ? Container(
                      height: height,
                      color: Colors.black54,
                      alignment: Alignment.center,
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                width * 0.06)),
                                      ),
                                      child: Text('Reauthenticate',
                                          textScaleFactor:
                                          min(horizontalScale, verticalScale),
                                          style: TextStyle(
                                            color: HexColor('6153D3'),
                                            fontSize: 18,
                                          ))),
                                  SizedBox(
                                    width: horizontalScale * 17,
                                  ),
                                  IconButton(
                                      color: Colors.white,
                                      onPressed: () {
                                        setState(() {
                                          phoneVisibleEdit = false;
                                        });
                                      },
                                      icon: Icon(Icons.clear))
                                ],
                              ),
                              Container(
                                child: AnimatedSwitcher(
                                  duration: Duration(milliseconds: 200),
                                  child: phoneVerify(number: _mobile.toString(),),
                                ),
                              )
                            ],
                          ),
                  ),
                      ),
                )
                    : Container()

              ],
            ),
          ]

        ),
      ),
    );
  }


  void _selectImagex(Future<XFile?> image) async{
    XFile? tempImage =await image;
    setState((){
      _image=tempImage;
    });
  }

  _displayChild() {
      final userprovider =Provider.of<UserProvider>(context);
      if(_image==null){
          return (userprovider.userModel?.image=='')?AssetImage('assets/user.jpg'):NetworkImage(userprovider.userModel?.image??'');
      }else{
        final File _imagex=File(_image!.path);
        //Image.file(File(_imagex.path));
         return FileImage(_imagex) ;
      }
  }

  }


