import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String FB_INTERSTITIAL_AD_ID = "IMG_16_9_APP_INSTALL#2312433698835503_2650502525028617";
  bool isInterstitialAdLoaded = false;

  @override
  void initState() {
    FacebookAudienceNetwork.init(
      testingId: "37b1da9d-b48c-4103-a393-2e095e734bd6", //optional
    );

    _loadInterstitialAd();

    super.initState();
  }

  void _loadInterstitialAd() {
    FacebookInterstitialAd.loadInterstitialAd(
        placementId: FB_INTERSTITIAL_AD_ID,
        listener: (result, value) {
          if (result == InterstitialAdResult.LOADED) {
            isInterstitialAdLoaded = true;
          }

          if (result == InterstitialAdResult.DISMISSED && value["invalidated"] == true) {
            isInterstitialAdLoaded = false;
            _loadInterstitialAd();
          }
        });
  }

  _showInterstitialAd() {
    if (isInterstitialAdLoaded == true) {
      FacebookInterstitialAd.showInterstitialAd();
    } else {
      print("Ad not loaded yet");
    }
  }

  Widget _bannerAd = SizedBox(width: 0, height: 0);

  void loadBannerAd() {
    setState(() {
      _bannerAd = FacebookBannerAd(
        placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2964944860251047",
        bannerSize: BannerSize.STANDARD,
        listener: (result, value) {
          print("$result == $value");
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Facebook Audience Network")),
      body: Column(
        children: [
          FlatButton(
            child: Text("Load Banner Ad"),
            onPressed: () => loadBannerAd(),
          ),
          FlatButton(child: Text("Load Interstitial Ad"), onPressed: () => _showInterstitialAd()),
          Flexible(
            child: Container(),
            flex: 1,
            fit: FlexFit.tight,
          ),
          _bannerAd
        ],
      ),
    );
  }
}
