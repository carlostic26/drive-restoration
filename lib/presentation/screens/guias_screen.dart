import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:recu_drive/config/styles/constants/ads/ads.dart';
import 'package:recu_drive/domain/entities/guia_entity.dart';
import 'package:recu_drive/infrastructure/sqlite_db.dart';

class GuiasScreen extends StatefulWidget {
  const GuiasScreen({super.key});

  @override
  State<GuiasScreen> createState() => _GuiasScreenState();
}

class _GuiasScreenState extends State<GuiasScreen> {
  //init ads

  late LocalDatabase localDb;
  Future<List<GuiaEntity>>? _guia;

  //initializing banner ad
  BannerAd? _anchoredAdaptiveAd;

  RecudriveAds recuAds = RecudriveAds();
  bool _isAdLoaded = false;
  bool _isLoaded = false;

  static const AdRequest request = AdRequest(
      //keywords: ['',''],
      //contentUrl: '',
      //nonPersonalizedAds: false
      );

  @override
  void initState() {
    super.initState();
    loadGuias();
    _loadAdaptativeAd();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAdaptativeAd();
  }

  Future<void> _loadAdaptativeAd() async {
    if (_isAdLoaded) {
      return;
    }

    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      //print('Unable to get height of anchored banner.');
      return;
    }

    BannerAd loadedAd = BannerAd(
      adUnitId: recuAds.bannerAd,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          //print('$ad loaded: ${ad.responseInfo}');
          setState(() {
            _anchoredAdaptiveAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Anchored adaptive banner failedToLoad: $error');
          ad.dispose();
        },
      ),
    );

    try {
      await loadedAd.load();
    } catch (e) {
      //print('Error loading anchored adaptive banner: $e');
      loadedAd.dispose();
    }
  }

  loadGuias() {
    localDb = LocalDatabase();
    localDb.initializeDB().whenComplete(() async {
      setState(() {
        _guia = getGuiasDb();
      });
    });
  }

  Future<List<GuiaEntity>> getGuiasDb() async {
    return await localDb.getGuias();
  }

  Future<void> _onRefresh() async {
    setState(() {
      //hacemos un switch para que sepa que cateogira es la que debe refrescar
      _guia = getGuiasDb();
    });
  }

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 171, 60),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Guías de recuperación',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: FutureBuilder<List<GuiaEntity>>(
        future: _guia,
        builder:
            (BuildContext context, AsyncSnapshot<List<GuiaEntity>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            var items = snapshot.data ?? <GuiaEntity>[];

            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(children: [
                  Divider(
                    thickness: 1,
                    color: index == 0 ? Colors.transparent : Colors.black,
                  ),

                  Row(
                    children: [
                      //circle
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: widthScreen * 0.1,
                          height: heightScreen * 0.04,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              (index + 1).toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 8, 8),
                        child: Text(
                          items[index].titleStep,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ],
                  ),

                  //url
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: items[index].urlImg != ''
                          ? Image.network(
                              items[index].urlImg,
                              fit: BoxFit.fill,
                            )
                          : null),

                  //desc
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 30),
                    child: Text(items[index].description),
                  ),
                ]);
              },
            );
          }
        },
      ),
      bottomNavigationBar: _anchoredAdaptiveAd != null
          ? Container(
              color: Colors.transparent,
              width: _anchoredAdaptiveAd?.size.width.toDouble(),
              height: _anchoredAdaptiveAd?.size.height.toDouble(),
              child: AdWidget(ad: _anchoredAdaptiveAd!),
            )
          : const SizedBox(),
    );
  }
}
