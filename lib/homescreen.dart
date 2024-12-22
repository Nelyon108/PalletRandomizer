import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  Random random = Random();
  Color mainColor = Colors.transparent;
  Color blackColor = Colors.transparent;
  Color borderColor = Colors.transparent;
  Color secondaryColor = Colors.transparent;
  Color whiteColor = Colors.transparent;
  String colorText = '';
  String blackText = '';
  String borderText = '';
  String secondaryText = '';
  String whiteText = '';

  bool _isAdLoaded = false;
  late BannerAd myBanner;


  @override
  void initState() {
    super.initState();
    _generateRandomColor();

     myBanner = BannerAd(
      adUnitId: 'ca-app-pub-2328790188643990/7553432907', // Replace with your Ad Unit ID
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          // Use setState here to update the UI after ad is loaded
          if (mounted) {  // Make sure widget is still mounted
            setState(() {
              _isAdLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // Dispose of the ad and update the state
          ad.dispose();
          if (mounted) {
            setState(() {
              _isAdLoaded = false;
            });
          }
        },
      ),
    );

    myBanner.load(); // Load the ad after initialization
  }
  

  void _generateRandomColor() {
    // Random color generation logic remains unchanged
    mainColor = Color.fromARGB(
      200 + random.nextInt(256 - 200 + 1),
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );

    blackColor = Color.fromARGB(204 + random.nextInt(256 - 204 + 1), 0, 0, 0);

    HSLColor borderHSL = HSLColor.fromColor(mainColor);
    borderColor = borderHSL
        .withHue((borderHSL.hue + 25) % 360)
        .withLightness((borderHSL.lightness + 0.2).clamp(0.5, 0.7))
        .withSaturation((borderHSL.saturation - 0.2).clamp(0.0, 0.6))
        .toColor()
        .withOpacity(0.5 + random.nextDouble() * (0.81 - 0.5));

    HSLColor secondaryHSL = HSLColor.fromColor(mainColor);
    secondaryColor = secondaryHSL
        .withHue((secondaryHSL.hue + 25) % 360)
        .withLightness((secondaryHSL.lightness + 0.2).clamp(0.45, 1.0))
        .withSaturation((secondaryHSL.saturation - 0.2).clamp(0.5, 1.0))
        .toColor()
        .withOpacity(0.7 + random.nextDouble() * (0.91 - 0.7));

    whiteColor = Color.fromARGB(242 + random.nextInt(256 - 242 + 1), 255, 255, 255);

    colorText = '#${mainColor.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
    blackText = '#${blackColor.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
    borderText = '#${borderColor.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
    secondaryText = '#${secondaryColor.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
    whiteText = '#${whiteColor.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }

  @override
  Widget build(BuildContext context) {
    List<Color> colorList = [mainColor, blackColor, borderColor, secondaryColor, whiteColor];
    List<String> colorsText = [colorText, blackText, borderText, secondaryText, whiteText];

    // Use MediaQuery to get the screen size
    // double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;

    // Calculate item height and width based on the screen size
    // double containerHeight = screenHeight * 0.15;
    // double containerWidth = screenWidth * 0.25;
    // double bannerHeight = screenHeight * 0.1;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            colorText,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
          backgroundColor: mainColor,
        ),
        body: Column(
          children: [
            Expanded(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(child: 
              Column(children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.015),
              ..._buildColorRows(colorList, colorsText),
              ],),),
            ),),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    _generateRandomColor(); // Generate a new color when button is pressed
                  });
                },
                child: const Text("Change Color Palette"),
              ),
              _isAdLoaded?const SizedBox(height: 5.0,):const SizedBox(height: 20.0,),
            if (_isAdLoaded)
              Container(
                alignment: Alignment.center,
                width: myBanner.size.width.toDouble(),
                height: myBanner.size.height.toDouble(),
                child: 
                AdWidget(ad: myBanner),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildColorRows(List<Color> colorList, List<String> colorsText) {
    return List.generate(colorList.length, (index) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.015),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.height * 0.13,
              height: MediaQuery.of(context).size.height * 0.13,
              color: colorList[index],
            ),
            const SizedBox(width: 10),
            Text(
              '${_getColorLabel(index)}: ${colorsText[index]}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      );
    });
  }

  String _getColorLabel(int index) {
    switch (index) {
      case 0:
        return 'Brand';
      case 1:
        return 'Black';
      case 2:
        return 'Border';
      case 3:
        return 'Secondary';
      case 4:
        return 'White';
      default:
        return 'Color';
    }
  }
}
