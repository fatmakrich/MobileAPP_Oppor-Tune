
import 'package:opportune_mobile_app/Landing_Page.dart';
import 'package:flutter/material.dart';
import 'package:opportune_mobile_app/customShape.dart';
import 'package:opportune_mobile_app/addOffer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JobList extends StatelessWidget {
  const JobList({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 130,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        flexibleSpace: ClipPath(
          clipper: Customshape(),
          child: Container(
            height: 250,
            width: MediaQuery.of(context).size.width,
            color: Colors.indigo[700],
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            var userData = snapshot.data;
            if (userData != null && userData.exists) {
              var companyName = userData['companyName'];
              var logoUrl = userData['logoUrl'];
              return Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Image.network(
                      logoUrl,
                      width: 200.0,
                      height: 100.0,
                    ),
                    Text(
                      companyName,
                      style: TextStyle(
                        fontSize: 35,
                        color: Color.fromARGB(255, 9, 97, 169),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 5.0,
                        wordSpacing: 10.0,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 2.0,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return ListView(
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(20),
                              children: snapshot.data!.docs.map((document) {
                                var data = document.data() as Map<String, dynamic>;
                                return buildJobContainer(
                                  title: data['jobTitle'],
                                  description: data['requirements'],
                                  view: data['sector'],
                                  date: data['numberOfOffers'],
                                  imageUrl: data['imageUrl'],
                                  formLink: data['formLink'],
                                  onTapSeeApplications: () {
                                    // You can leave this field empty or replace it with other functionalities
                                  },
                                );
                              }).toList(),
                            );
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 2),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddOffer(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple[300],
                          minimumSize: Size(150, 45),
                        ),
                        child: const Text(
                          'ADD A NEW OFFER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 85.0, vertical: 2),
                      child: ElevatedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => FirstPage()), // Replace YourLoginPage with the actual login page
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[900],
                          minimumSize: Size(120, 45),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.exit_to_app, color: Colors.black), // Icon for "LOG OUT"
                            SizedBox(width: 6), // Space between icon and text
                            Text(
                              'LOG OUT',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: Text('User data not found'));
            }
          }
        },
      ),
    );
  }

  Widget buildJobContainer({
    required String title,
    required String description,
    required String view,
    required String date,
    required String imageUrl,
    required String? formLink,
    required VoidCallback onTapSeeApplications,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        width: 300,
                        height: 120,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          print('Error loading image: $error');
                          return const Text('Image not available');
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Job Title : $title',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Requirements : $description',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sector: $view',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            'Number of offer:$date',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          if (formLink != null)
            GestureDetector(
              onTap: () => _launchURL(formLink),
              child: Text(
                'Form Link: $formLink',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 3, 21, 36),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          const SizedBox(height: 16),
          Divider(),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
