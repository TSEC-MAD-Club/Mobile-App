import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

Future<void> launchUrl(String url, BuildContext context) async {
  if (await canLaunchUrlString(url))
    launchUrlString(url);
  else
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cannot open URL")),
    );
}
