import 'dart:convert';
import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:bandsintown_flutter/src/models/_models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BITPlayerBanner extends StatefulWidget {
  final String proxyUrl, pageUrl;

  ///The name of the track
  final String? track;

  ///The name of the album
  final String? album;

  ///The name of the artist
  final String? artist;

  ///Width of screen
  final double viewportWidth;

  final EdgeInsets margin;

  ///Function called when the user taps on the player
  final Function()? onTap;
  ///Function called when the user loads the ad
  final Function()? onAdLoaded;

  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  const BITPlayerBanner({
    super.key,
    required this.proxyUrl,
    required this.pageUrl,
    required this.viewportWidth,
    this.track,
    this.album,
    this.artist,
    this.margin = const EdgeInsets.only(top: 8, left: 15, right: 15),
    this.onTap,
    this.onAdLoaded,
    this.titleStyle,
    this.subtitleStyle,
  });

  @override
  State<BITPlayerBanner> createState() => _BITPlayerBannerState();
}

class _BITPlayerBannerState extends State<BITPlayerBanner>
    with AutomaticKeepAliveClientMixin {
  bool noAdFound = false;
  CreativeInfo? ad;

  @override
  void initState() {
    if (ad == null && !noAdFound) {
      getAd();
    }
    super.initState();
  }

  void getAd() async {
    List<String> parameters = [];
    //Required info
    parameters.add('url=${widget.pageUrl}');
    parameters.add('viewport_width=${widget.viewportWidth.toInt().toString()}');

    //Track name
    if (widget.track != null) {
      parameters.add('track=${widget.track!}');
    }
    //Album name
    if (widget.album != null) {
      parameters.add('album=${widget.album!}');
    }
    //Artist name
    if (widget.artist != null) {
      parameters.add('artist=${widget.artist!}');
    }

    //Get request
    var url = Uri.parse('${widget.proxyUrl}/proxy?${parameters.join('&')}');
    var response = await http.get(url);

    //Ad found
    if (response.statusCode == 200) {
      ad = CreativeInfo.fromJson(jsonDecode(response.body));
      if (mounted) setState(() {});

      //Ad loaded function
      if (widget.onAdLoaded != null) {
        widget.onAdLoaded!();
      }
    } else {
      noAdFound = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnimatedSizeAndFade(
      child: ad != null ? buildAd(ad!) : const SizedBox(),
    );
  }

  Widget buildAd(CreativeInfo ad) {
    return GestureDetector(
      onTap: () {
        //Launch click url
        launchUrlString(
          ad.clickUrl,
          mode: LaunchMode.externalApplication,
        );
        //Sent tap event to app
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      child: Container(
        margin: widget.margin,
        color: Colors.transparent,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 4),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    spreadRadius: 1,
                    blurRadius: 15,
                  )
                ],
                color: Theme.of(context).cardColor,
              ),
              height: 50,
              width: 50,
              child: const Icon(
                Symbols.play_arrow_rounded,
                size: 33,
                fill: 1,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    ad.creative.title,
                    style: widget.titleStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: LinearProgressIndicator(
                      value: 0.1,
                      color: Theme.of(context).primaryColor,
                      backgroundColor:
                          Theme.of(context).primaryColor.withOpacity(0.25),
                    ),
                  ),
                  Text(
                    ad.creative.subtitle,
                    style: widget.subtitleStyle,
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 4),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    spreadRadius: 1,
                    blurRadius: 15,
                  )
                ],
                color: Theme.of(context).cardColor,
              ),
              height: 50,
              width: 50,
              child: const Icon(
                Symbols.volume_up_rounded,
                size: 33,
                fill: 1,
              ),
            ),
            //Pixel tracking
            if (ad.pixels.firstOrNull != null)
              SizedBox(
                height: 1,
                width: 1,
                child: Image.network(
                  ad.pixels.first,
                  width: 1,
                  height: 1,
                ),
              )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
