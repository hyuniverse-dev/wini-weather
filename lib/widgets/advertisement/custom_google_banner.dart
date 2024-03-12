import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CustomGoogleBanner extends StatefulWidget {
  final String adUnitId;

  const CustomGoogleBanner({
    Key? key,
    required this.adUnitId,
  }) : super(key: key);

  @override
  _CustomGoogleBannerState createState() => _CustomGoogleBannerState();
}

class _CustomGoogleBannerState extends State<CustomGoogleBanner> {
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();

    _bannerAd = BannerAd(
      adUnitId: widget.adUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return _isBannerAdReady
        ? Container(
            width: _bannerAd.size.width.toDouble(),
            height: _bannerAd.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd),
          )
        : Container();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }
}
