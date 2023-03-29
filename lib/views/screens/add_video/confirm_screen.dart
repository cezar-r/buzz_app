import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:buzz_app/controllers/upload_video_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../complex.dart';
import '../../../constants.dart';
import '../../widgets/text_input_field.dart';

class ConfirmScreen extends StatefulWidget {
  final File videoFile;
  final String videoPath;

  const ConfirmScreen({
    Key? key,
    required this.videoFile,
    required this.videoPath,
  }) : super(key: key);

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  late VideoPlayerController controller;
  late VideoPlayerController pausedController;
  TextEditingController _captionController = TextEditingController();
  TextEditingController _songNameController = TextEditingController();
  bool _includeWaveforms = true;
  bool _publicUpload = true;
  bool _isMute = false;


  UploadVideoController uploadVideoController = Get.put(UploadVideoController());

  Widget _playingVideo() {
    return InkWell(
      onTap: () {
        setState(() {
          if (_isMute) {
            controller.setVolume(1);
            _isMute = false;
          } else {
            controller.setVolume(0);
            _isMute = true;
          }
        });
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width/3,
        height: MediaQuery.of(context).size.height/3,
        child: Stack(
            children: [
              VideoPlayer(controller),
              Positioned(
                bottom: 5,
                right: 5,
                child: _isMute ? Icon(Icons.volume_off, size: 15) : Icon(Icons.volume_up, size: 15)
              ),
          ],
        ),
      ),
    );
  }

  Widget _pausedVideo() {
    return SizedBox(
      width: MediaQuery.of(context).size.width/3,
      height: MediaQuery.of(context).size.height/3,
      child: Stack(
        children: [
          VideoPlayer(pausedController),
          Container(
            color: Colors.black.withOpacity(0.5),
          )
        ],
      ),
    );
  }

  Future<List> generateWaveform(File videoFile) async {
    if (_includeWaveforms == false) {
      return [];
    }

    final bytes = await videoFile.readAsBytes();
    final int16Data = Int16List.view(bytes.buffer);
    final doubleData = int16Data.map((value) => value.toDouble()).toList();

    List<Complex> fftOutput = fft(doubleData);
    List<double> amplitudes = computeAmplitudes(fftOutput);

    return normalizeAndDownsample(amplitudes);
  }

  List<double> normalizeAndDownsample(List<double> amplitudes) {
    int targetLength = 150;

    // Calculate the maximum amplitude
    double maxAmplitude = amplitudes.reduce((a, b) => max(a, b));

    // Normalize the amplitudes
    List<double> normalizedAmplitudes = amplitudes.map((a) => a / maxAmplitude).toList();

    // Calculate the down sampling ratio
    double ratio = (normalizedAmplitudes.length - 1) / (targetLength - 1);

    // Initialize the output waveform
    List<double> outputWaveform = List<double>.filled(targetLength, 0.0);

    // Downsample the normalized amplitudes using linear interpolation
    for (int i = 0; i < targetLength; i++) {
      double position = i * ratio;
      int leftIndex = position.floor();
      int rightIndex = position.ceil();

      // Ensure that the indices are within the valid range of the list
      if (leftIndex < 0 || rightIndex >= normalizedAmplitudes.length) {
        continue;
      }

      if (leftIndex == rightIndex) {
        outputWaveform[i] = normalizedAmplitudes[leftIndex];
      } else {
        double t = position - leftIndex;
        outputWaveform[i] = (1 - t) * normalizedAmplitudes[leftIndex] + t * normalizedAmplitudes[rightIndex];
      }
    }

    return outputWaveform;
  }




  List<Complex> fft(List<double> input) {
    // Find the smallest power of two greater than or equal to the input length
    int n = pow(2, (log(input.length) / log(2)).ceil()).toInt();

    // Pad the input with zeros to the next power of two
    List<Complex> paddedInput = List<Complex>.filled(n, Complex.zero());
    for (int i = 0; i < input.length; i++) {
      paddedInput[i] = Complex(input[i], 0);
    }

    // Compute the FFT using the Cooley-Tukey algorithm
    return _cooleyTukeyFFT(paddedInput);
  }

  List<double> computeAmplitudes(List<Complex> fftOutput) {
    return fftOutput.map((complex) => complex.abs()).toList();
  }



  List<Complex> _cooleyTukeyFFT(List<Complex> x) {
    int n = x.length;

    // Base case: if the input has only one element, return it
    if (n <= 1) return x;

    // Split the input into even and odd parts
    List<Complex> even = List<Complex>.generate(n ~/ 2, (i) => x[i * 2]);
    List<Complex> odd = List<Complex>.generate(n ~/ 2, (i) => x[i * 2 + 1]);

    // Recursively compute the FFT of the even and odd parts
    List<Complex> evenFFT = _cooleyTukeyFFT(even);
    List<Complex> oddFFT = _cooleyTukeyFFT(odd);

    // Combine the even and odd FFTs
    List<Complex> combined = List<Complex>.filled(n, Complex.zero());
    for (int i = 0; i < n ~/ 2; i++) {
      Complex t = Complex.polar(1, -2 * pi * i / n) * oddFFT[i];
      combined[i] = evenFFT[i] + t;
      combined[i + n ~/ 2] = evenFFT[i] - t;
    }

    return combined;
  }



  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      controller = VideoPlayerController.file(widget.videoFile);
      pausedController = VideoPlayerController.file(widget.videoFile);
    });
    controller.initialize();
    pausedController.initialize();
    controller.play();
    pausedController.pause();
    controller.setVolume(1);
    controller.setLooping(true);
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
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // video, margin from top
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    // left video w/ opacity
                    _pausedVideo(),
                    // main video
                    _playingVideo(),
                    // right video w/ opacity
                    _pausedVideo(),
                  ],
                ),
              ),
              // caption
              SizedBox(height: 20,),
              TextInputField(
                controller: _captionController,
                icon: Icons.format_quote,
                labelText: "Caption",
                themeColor: white,
              ),
              // song name
              SizedBox(height: 20,),
              TextInputField(
                controller: _songNameController,
                icon: Icons.music_note,
                labelText: "Song name",
                themeColor: white,
              ),
              // tag friends (coming soon)
              // show waveforms
              SizedBox(height: 20,),
              ListTile(
                title: Text(
                  "Show waveforms",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: CupertinoSwitch(
                    activeColor: green,
                    value: _includeWaveforms,
                    // title: Text("Show waveforms"),
                    onChanged: (bool newValue) {
                      setState(() {
                        _includeWaveforms = newValue;
                      });
                    }
                ),
              ),
              SizedBox(height: 10,),
              ListTile(
                title: Text(
                  "Public upload",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: CupertinoSwitch(
                    activeColor: green,
                    value: _publicUpload,
                    // title: Text("Show waveforms"),
                    onChanged: (bool newValue) {
                      setState(() {
                        _publicUpload = newValue;
                      });
                    }
                ),
              ),
              // public
              // upload button, margin from bottom
              SizedBox(height: 10,),
              Center(
                child: InkWell(
                  onTap: () async {
                    Get.snackbar('Uploading video', "This will take a couple seconds");
                    final List waveforms = await generateWaveform(widget.videoFile);
                    print(authController.user.uid);
                    DocumentSnapshot userDoc = await firestore.collection('users').doc(authController.user.uid).get();
                    bool isVerified = (userDoc.data() as Map<String, dynamic>)['isVerified'] == true;

                    uploadVideoController.uploadVideo(
                        widget.videoPath,
                        _captionController.text,
                        _songNameController.text,
                        _includeWaveforms,
                        _publicUpload,
                        waveforms,
                        isVerified,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              blue,
                              green,
                            ],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                          ),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: green,
                            width: 3,
                          )
                      ),
                      padding: const EdgeInsets.all(15),
                      child: const Text(
                        "Upload",
                        style: TextStyle(
                          color: black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}
