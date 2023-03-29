import 'package:buzz_app/constants.dart';
import 'package:buzz_app/views/screens/auth/user_profile_setup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/user_prefs_controller.dart';

class UserGenrePreferencesScreen extends StatefulWidget {
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const UserGenrePreferencesScreen({
      required this.usernameController,
      required this.emailController,
      required this.passwordController,
      Key? key}) : super(key: key);

  @override
  _UserGenrePreferencesScreen createState() => _UserGenrePreferencesScreen();
}

class _UserGenrePreferencesScreen extends State<UserGenrePreferencesScreen> {

  final UserPreferencesController _genrePreferencesController = UserPreferencesController();

  List<Widget> getMainGenres() {
    List<Widget> genreChoices = [];
    for (String genre in genres.keys) {
      genreChoices.add(
        InkWell(
            onTap: () {
              setState(() {
                if (_genrePreferencesController.preferences.contains(genre)) {
                  _genrePreferencesController.removeGenre(genre);
                } else {
                  _genrePreferencesController.addGenre(genre);
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: _genrePreferencesController.preferences.contains(genre) ? green : black,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: green,
                    width: 3,
                  )
              ),
              child: Text(
              genre.capitalize!,
              style: TextStyle(
                color: _genrePreferencesController.preferences.contains(genre) ? black : white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ));
    }
    return genreChoices;
  }

  List<Widget> getSubGenres() {
    List<Widget> genreChoices = [];
    for (String genre in _genrePreferencesController.preferences) {
      if (!genres.containsKey(genre)) {
        continue;
      }
      for (String subGenre in genres[genre]!) {
        String representation = "$genre-$subGenre";
        genreChoices.add(
          InkWell(
              onTap: () {
                setState(() {
                  if (_genrePreferencesController.preferences.contains(representation)) {
                    _genrePreferencesController.removeGenre(representation);
                  } else {
                    _genrePreferencesController.addGenre(representation);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: _genrePreferencesController.preferences.contains(representation) ? blue : black,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: blue,
                      width: 3,
                    )
                ),
                child:
                Text(
                subGenre.capitalize!,
                style: TextStyle(
                  color: _genrePreferencesController.preferences.contains(representation) ? black : white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      }
    }
    return genreChoices;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          color: green,
        ),
      ),
      body: Stack(
        children:[
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select your favorite genres",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 15,
                        runSpacing: 15,
                        children: getMainGenres(),
                      ),
                      const SizedBox(height: 15,),
                      Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 15,
                        runSpacing: 15,
                        children: getSubGenres(),
                      )
                    ],
                  ),
                  const SizedBox(height: 125,)
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height-225, right: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: green,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: green,
                      width: 3,
                    )
                ),
                child: InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfileSetupScreen(
                        usernameController: widget.usernameController,
                        emailController: widget.emailController,
                        passwordController: widget.passwordController,
                        genreController: _genrePreferencesController,
                      ),
                    ),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      color: black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    )
                  ),
                ),
              ),
            ],
          ),
        ],
      )
    );
  }
}
