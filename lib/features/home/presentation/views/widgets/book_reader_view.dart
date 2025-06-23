import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:untitled5/features/home/domain_layer/entities/book_entity.dart';
import 'package:url_launcher/url_launcher.dart';

class BookReaderView extends StatefulWidget {
  final BookEntity book;

  const BookReaderView({super.key, required this.book});

  @override
  State<BookReaderView> createState() => _BookReaderViewState();
}

class _BookReaderViewState extends State<BookReaderView> {
  late InAppWebViewController _webViewController;
  double _progress = 0;
  bool _isLoading = true;
  bool _hasError = false;
  bool _isFavorite = false;
  double _scrollPosition = 0;

  @override
  void initState() {
    super.initState();
    _initHive();
    _checkIfFavorite();
  }

  Future<void> _initHive() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(BookEntityAdapter());
    }
  }

  Future<void> _checkIfFavorite() async {
    final favoritesBox = await Hive.openBox('favorites');
    setState(() {
      _isFavorite = favoritesBox.containsKey(widget.book.bookId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.book.title,style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: _toggleFavorite,
          ),
          IconButton(
            icon: const Icon(Icons.refresh,color: Colors.white),
            onPressed: _reloadPage,
          ),
          IconButton(
            icon: const Icon(Icons.open_in_browser,color: Colors.white),
            onPressed: _openInExternalBrowser,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.bookmark),
        onPressed: _saveReadingProgress,
      ),
    );
  }

  Widget _buildBody() {
    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Failed to load book content'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _reloadPage,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri( 'https://books.google.com/books?id=${widget.book.bookId}'),
          ),
          onWebViewCreated: (controller) {
            _webViewController = controller;
            _loadReadingProgress();
          },
          onLoadStart: (_, __) => setState(() => _isLoading = true),
          onLoadStop: (_, __) => setState(() => _isLoading = false),
          onLoadError: (_, __, ___, ____) {
            setState(() {
              _isLoading = false;
              _hasError = true;
            });
          },
          onProgressChanged: (_, progress) =>
              setState(() => _progress = progress / 100),
          onScrollChanged: (controller, x, y) {
            _scrollPosition = y.toDouble();
          },
        ),
        if (_isLoading)
          LinearProgressIndicator(
            value: _progress,
            backgroundColor: Colors.transparent,
            color: Colors.orangeAccent,
          ),
      ],
    );
  }

  Future<void> _toggleFavorite() async {
    final favoritesBox = await Hive.openBox('favorites');
    if (_isFavorite) {
      await favoritesBox.delete(widget.book.bookId);
    } else {
      await favoritesBox.put(widget.book.bookId, widget.book);
    }
    setState(() => _isFavorite = !_isFavorite);
  }

  Future<void> _saveReadingProgress() async {
    final progressBox = await Hive.openBox('reading_progress');
    await progressBox.put(widget.book.bookId, {
      'position': _scrollPosition,
      'timestamp': DateTime.now().toString(),
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reading progress saved')),
    );
  }

  Future<void> _loadReadingProgress() async {
    final progressBox = await Hive.openBox('reading_progress');
    final progress = progressBox.get(widget.book.bookId);
    if (progress != null && progress['position'] != null) {
      final double position = (progress['position'] as num).toDouble();
      await _webViewController.scrollTo(
        x: 0,
        y: position.toInt(),
      );
    }
  }

  Future<void> _reloadPage() async {
    setState(() {
      _hasError = false;
      _isLoading = true;
    });
    await _webViewController.reload();
  }

  Future<void> _openInExternalBrowser() async {
    final url = widget.book.previewUrl ??
        'https://books.google.com/books?id=${widget.book.bookId}';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open browser')),
      );
    }
  }
}
