import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';

class CvCorrector extends StatefulWidget {
  @override
  _CvCorrectorState createState() => _CvCorrectorState();
}

class _CvCorrectorState extends State<CvCorrector> {
  int _currentIndex = 2;
  Future<void> _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      String filePath = result.files.single.path!;
      // You have the file path, you can use it as needed.
      print('Selected file: $filePath');
    } else {
      // User canceled the file picker
      print('File picking canceled');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[700],
        title: Text('CV Corrector'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              height: MediaQuery.of(context).size.height / 2,
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: Radius.circular(12),
                strokeWidth: 2,
                dashPattern: [8, 4],
                color: Colors.indigo[700]! as Color,
                child: Center(
                  child: ElevatedButton(
                    onPressed: _openFilePicker,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey[400],
                      padding: EdgeInsets.symmetric(
                        horizontal: 50.0,
                        vertical: 30.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Upload your CV here',
                      style: TextStyle(
                        color: Colors.indigo[700],
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50.0),
            ElevatedButton(
              onPressed: () {
                // Logique pour corriger le CV
                // Peut rediriger l'utilisateur vers une autre page ou afficher une boîte de dialogue, selon votre conception.
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.greenAccent,
                padding: EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 20.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Correct CV',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.indigo[700],
        unselectedItemColor: Colors.black45,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Blog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Tools',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
