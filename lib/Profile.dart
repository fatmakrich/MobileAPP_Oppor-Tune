import 'package:opportune_mobile_app/Landing_Page.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'Blog.dart';
import 'ToolsScreen.dart';
import 'Home_Page.dart';
import 'BottomNavBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isUploading = false;
  int _currentIndex = 3;
  late String userId;
  late Map<String, dynamic> userData = Map();
  late TextEditingController phoneNumberController;
  late TextEditingController emailController;
  late TextEditingController bioController;
  late TextEditingController educationController;
  late TextEditingController experienceController;
  late List<String> educationList;
  late List<String> experienceList;
  late GlobalKey<FormState> emailFormKey;
  late GlobalKey<FormState> phoneFormKey;
  late GlobalKey<FormState> bioFormKey;
  late GlobalKey<FormState> educationFormKey;
  late GlobalKey<FormState> experienceFormKey;
  late File? pickedImage = null;
  late firebase_storage.Reference storageReference;

  @override
  void initState() {
    super.initState();
    emailFormKey = GlobalKey<FormState>();
    phoneFormKey = GlobalKey<FormState>();
    bioFormKey = GlobalKey<FormState>();
    educationFormKey = GlobalKey<FormState>();
    experienceFormKey = GlobalKey<FormState>();
    fetchUserData();
    phoneNumberController = TextEditingController();
    emailController = TextEditingController();
    bioController = TextEditingController();
    educationController = TextEditingController();
    experienceController = TextEditingController();
    educationList = [];
    experienceList = [];
    storageReference = firebase_storage.FirebaseStorage.instance.ref().child('ProfileImage');
  }

  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      userId = user.uid;

      DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();

      setState(() {
        userData = userDoc.data() as Map<String, dynamic>;
        phoneNumberController.text = userData['phoneNumber'] ?? '';
        emailController.text = userData['email'] ?? '';
        bioController.text = userData['bio'] ?? '';
        educationController.text = userData['education'] ?? '';
        experienceController.text = userData['experience'] ?? '';
        if (userData['educationList'] != null) {
          educationList = List.from(userData['educationList']);
        }
        if (userData['experienceList'] != null) {
          experienceList = List.from(userData['experienceList']);
        }
      });
    }
  }

  Future<void> _updateUserData() async {
    try {
      if (!mounted) return;

      isUploading = true;
      showLoadingSnackBar();

      String? imageUrl;
      if (pickedImage != null) {
        imageUrl = await uploadImage();
        if (!mounted) return;
      }

      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'phoneNumber': phoneNumberController.text,
        'email': emailController.text,
        'userImageUrl': imageUrl ?? userData['userImageUrl'],
        'bio': bioController.text,
        'education': educationController.text,
        'experience': experienceController.text,
        'educationList': educationList,
        'experienceList': experienceList,
        'isNotificationEnabled': userData['isNotificationEnabled'] ?? false,
      });

      await fetchUserData();

      if (!mounted) return;

      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      showSuccessSnackBar();
    } catch (error) {
      // Handle error
    } finally {
      isUploading = false;
    }
  }

  Future<String?> uploadImage() async {
    await storageReference.putFile(pickedImage!);
    return storageReference.getDownloadURL();
  }

  void showLoadingSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Updating profile...'),
      duration: Duration(minutes: 5),
    ));
  }

  void showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Profile updated successfully'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !isUploading;
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              flexibleSpace: FlexibleSpaceBar(
                background: CustomPaint(
                  painter: SemiEllipsePainter(),
                  child: Container(
                    height: 120,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  GestureDetector(
                    onTap: () {
                      _pickImage();
                    },
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        CircleAvatar(
                          radius: 80,
                          backgroundColor: Color(0xFF356899),
                          backgroundImage: pickedImage != null
                              ? FileImage(pickedImage!) as ImageProvider
                              : (userData['userImageUrl'] != null &&
                              userData['userImageUrl'].isNotEmpty
                              ? NetworkImage(userData['userImageUrl'])
                              : NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRWfQZi86lGQXqdzCSPKOAbOhCaQUBRPCexU4WUyYKB5LasBNyoynjLy_5-zg&s')),
                        ),
                        if (pickedImage == null)
                          Positioned(
                            top: 130,
                            child: Icon(
                              Icons.add_a_photo,
                              color: Colors.black,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    '${userData['firstName']} ${userData['lastName']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  buildDetailRow(Icons.person, 'User Name', '${userData['firstName']} ${userData['lastName']}'),
                  buildEditableDetailRow(Icons.email, 'Email', emailController, emailFormKey),
                  buildEditableDetailRow(Icons.phone, 'Phone Number', phoneNumberController, phoneFormKey),
                  buildEditableDetailRow(Icons.info, 'Bio', bioController, bioFormKey),
                  buildEducationSection(),
                  buildExperienceSection(),
                  ListTile(
                    leading: Icon(Icons.notifications, color: Color(0xFF356899)),
                    title: Text('Allow Notifications'),
                    trailing: Switch(
                      value: userData['isNotificationEnabled'] ?? false,
                      onChanged: (value) {
                        setState(() {
                          userData['isNotificationEnabled'] = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 100),
                  ElevatedButton(
                    onPressed: () async {
                      if (emailFormKey.currentState!.validate() &&
                          phoneFormKey.currentState!.validate() &&
                          bioFormKey.currentState!.validate()) {
                        _updateUserData();
                      }
                    },
                    child: Text('Save'),
                  ),
                  SizedBox(height: 15),
                  buildLogoutButton(), // Added logout button
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: _currentIndex,
          onTabTapped: (index) {
            switch (index) {
              case 0:
                navigateTo(HomePage(isUser: true));
                break;
              case 1:
                navigateTo(BlogPage());
                break;
              case 2:
                navigateTo(ToolsScreen());
                break;
              case 3:
                navigateTo(ProfilePage());
                break;
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (emailFormKey.currentState!.validate() &&
                phoneFormKey.currentState!.validate() &&
                bioFormKey.currentState!.validate()) {
              _updateUserData();
            }
          },
          child: Icon(Icons.save),
        ),
      ),
    );
  }

  void navigateTo(Widget page) {
    if (!isUploading) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
    }
  }

  Widget buildDetailRow(IconData icon, String label, String value, {VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Color(0xFF356899)),
      title: Text(label),
      subtitle: Text(value),
    );
  }

  Widget buildEditableDetailRow(IconData icon, String label, TextEditingController controller, GlobalKey<FormState> formKey) {
    return Form(
      key: formKey,
      child: ListTile(
        leading: Icon(icon, color: Color(0xFF356899)),
        title: Text(label),
        subtitle: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Tap to edit',
          ),
          validator: (value) {
            if (label == 'Email' && !isValidEmail(value!)) {
              return 'Invalid email address';
            }
            if (label == 'Phone Number' && !isValidPhoneNumber(value!)) {
              return 'Invalid phone number';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget buildEducationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(Icons.school, color: Color(0xFF356899)),
          title: Text('Education'),
        ),
        ...educationList.map((education) => ListTile(
          leading: Icon(Icons.star),
          title: Text(education),
        )),
        Form(
          key: educationFormKey,
          child: ListTile(
            leading: Icon(Icons.add),
            title: TextFormField(
              controller: educationController,
              decoration: InputDecoration(
                hintText: 'Add Education',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter education details';
                }
                return null;
              },
            ),
            trailing: IconButton(
              icon: Icon(Icons.add_circle),
              onPressed: () {
                if (educationFormKey.currentState!.validate()) {
                  setState(() {
                    educationList.add(educationController.text);
                    educationController.clear();
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildExperienceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(Icons.work, color: Color(0xFF356899)),
          title: Text('Experience'),
        ),
        ...experienceList.map((experience) => ListTile(
          leading: Icon(Icons.star),
          title: Text(experience),
        )),
        Form(
          key: experienceFormKey,
          child: ListTile(
            leading: Icon(Icons.add),
            title: TextFormField(
              controller: experienceController,
              decoration: InputDecoration(
                hintText: 'Add Experience',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter experience details';
                }
                return null;
              },
            ),
            trailing: IconButton(
              icon: Icon(Icons.add_circle),
              onPressed: () {
                if (experienceFormKey.currentState!.validate()) {
                  setState(() {
                    experienceList.add(experienceController.text);
                    experienceController.clear();
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  bool isValidEmail(String email) {
    RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }

  bool isValidPhoneNumber(String phone) {
    RegExp phoneRegex = RegExp(r'^\d{8}$');
    return phoneRegex.hasMatch(phone);
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        pickedImage = File(image.path);
      });
    }
  }

  Widget buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 4),
      child: ElevatedButton.icon(
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => FirstPage()),
          );
        },
        icon: Icon(Icons.logout,color: Colors.black),
        label: Text('Logout',style: TextStyle(color: Colors.black)),
        style: ElevatedButton.styleFrom(
          primary: Colors.red[900],

        ),
      ),
    );
  }
}

class SemiEllipsePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Color(0xFF303F9F);

    Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height - 50)
      ..quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 50)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}


