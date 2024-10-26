import 'package:flutter/material.dart';
import 'package:opportune_mobile_app/jobList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddOffer extends StatefulWidget {
  const AddOffer({Key? key}) : super(key: key);

  static const routeName = '/add offer';

  @override
  _AddOfferState createState() => _AddOfferState();
}

class _AddOfferState extends State<AddOffer> {
  // Add your variables for form input (replace with the actual data types)
  String jobTitle = '';
  String sector = '';
  String numberOfOffers = '';
  String requirements = '';
  String imageUrl = '';
  String formLink = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: ListView(
          children: [
            const SizedBox(height: 40),
            // Add text below
            const Text(
              "ADD A NEW OFFER",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                letterSpacing: 5.0,
                wordSpacing: 10.0,
              ),
            ),
            const SizedBox(height: 20),
            // Create form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    // First set of Text and TextFormField
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        const Text(
                          'Job Title',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 6, 68, 119),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Container with TextFormField
                        Container(
                          width: 600,
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: TextFormField(
                            onChanged: (value) {
                              jobTitle = value;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Enter your job title',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Second set of Text and TextFormField
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        const Text(
                          'Sector',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 6, 68, 119),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Container with TextFormField
                        Container(
                          width: 600,
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: TextFormField(
                            onChanged: (value) {
                              sector = value;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Specify your sector',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    // Third set of Text and TextFormField
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        const Text(
                          'Number of offers',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 6, 68, 119),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Container with TextFormField
                        Container(
                          width: 600,
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: TextFormField(
                            onChanged: (value) {
                              numberOfOffers = value;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Specify number of offers available',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    // Forth set of Text and TextFormField
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        const Text(
                          'Requirements',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 6, 68, 119),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Container with TextFormField
                        Container(
                          width: 600,
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: TextFormField(
                            onChanged: (value) {
                              requirements = value;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Enter requirements',
                              border: InputBorder.none,
                            ),
                            maxLines: null,
                            textInputAction: TextInputAction.newline,
                          ),
                        ),
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        const Text(
                          'Form Link',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 6, 68, 119),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Container with TextFormField for Form Link
                        Container(
                          width: 600,
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: TextFormField(
                            onChanged: (value) {
                              formLink = value;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Enter form link',
                              border: InputBorder.none,
                            ),
                            maxLines: null,
                            textInputAction: TextInputAction.newline,
                          ),
                        ),
                      ],
                    ),

                    // Sixth set of Text and TextFormField for Image URL
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        const Text(
                          'Image URL',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 6, 68, 119),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Container with TextFormField for Image URL
                        Container(
                          width: 600,
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: TextFormField(
                            onChanged: (value) {
                              imageUrl = value;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Insert image URL here',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ElevatedButton
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 10),
              child: ElevatedButton(
                onPressed: () async {
                  // Retrieve current user's UID
                  String? uid;
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    uid = user.uid;
                  }

                  // Firestore code to add a document to the 'posts' collection
                  await FirebaseFirestore.instance.collection('posts').add({
                    'jobTitle': jobTitle,
                    'sector': sector,
                    'numberOfOffers': numberOfOffers,
                    'requirements': requirements,
                    'formLink': formLink,
                    'imageUrl': imageUrl,
                    'uid': uid, // Add the user's UID to the post
                    'timestamp': FieldValue.serverTimestamp(),
                  }).then((value) {
                    print("Offer added to Firestore");
                  }).catchError((error) {
                    print("Failed to add offer to Firestore: $error");
                  });

                  // Navigate to the JobList page or perform any other action
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const JobList(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[200],
                  minimumSize: const Size(200, 55),
                ),
                child: const Text(
                  'POST',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
