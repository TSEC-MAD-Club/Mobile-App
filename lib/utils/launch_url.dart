import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchUrl(String url, BuildContext context) async {
  if (await canLaunch(url))
    launch(url);
  else
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cannot open URL")),
    );
}
