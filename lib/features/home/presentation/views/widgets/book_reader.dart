import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class BookReaderScreen extends StatefulWidget {
  final String bookUrl;
  final String bookTitle;

  const BookReaderScreen({
    super.key,
    required this.bookUrl,
    required this.bookTitle,
  });

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  late InAppWebViewController webController;
  double progress = 0;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => webController.reload(),
          ),
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: _openInBrowser,
          ),
        ],
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.bookUrl)),
            onWebViewCreated: (controller) => webController = controller,
            onLoadStart: (_, __) => setState(() => isLoading = true),
            onLoadStop: (_, __) => setState(() => isLoading = false),
            onProgressChanged: (_, progress) => setState(() => this.progress = progress / 100),
          ),
          if (isLoading)
            LinearProgressIndicator(
              value: progress,
              color: Colors.orangeAccent,
            ),
        ],
      ),
    );
  }

  Future<void> _openInBrowser() async {
    if (await canLaunchUrl(Uri.parse(widget.bookUrl))) {
      await launchUrl(Uri.parse(widget.bookUrl));
    }
  }
}
