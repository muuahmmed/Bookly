import 'package:flutter/material.dart';
import 'package:bookly/core/utils/assets.dart';

class BookDetailsViewBody extends StatelessWidget {
  const BookDetailsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomBookImage(),
          const SizedBox(height: 5),
          CustomBookDetails(),
          const SizedBox(height: 10),
          const CustomBoxAction(),
          const SizedBox(height: 15),
          buildText(),
          // FeatureListViewItem(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'You may also like',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class CustomBookImage extends StatelessWidget {
  const CustomBookImage({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 200,
          height: 220,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AssetsData.logo),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomBookDetails extends StatelessWidget {
  const CustomBookDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Book Title',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Author Name',
          style: TextStyle(fontSize: 18, color: Colors.white70),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, color: Colors.yellow[800], size: 30),
            const SizedBox(width: 6),
            const Text(
              '4.5',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(width: 10),
            const Text(
              '(123 Reviews)',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}

class CustomBoxAction extends StatelessWidget {
  const CustomBoxAction({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Price Section
            GestureDetector(
              onTap: () {
                // Handle price tap
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                  ),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '19.99€',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            // Preview Section
            GestureDetector(
              onTap: () {
                // Handle preview tap
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.deepOrangeAccent,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Free preview',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomListBooksItem extends StatelessWidget {
  const CustomListBooksItem({super.key});
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.7 / 4,
      child: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage(AssetsData.logo),
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
