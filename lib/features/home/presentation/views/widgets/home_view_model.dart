import 'package:flutter/material.dart';

class HomeViewModel extends StatelessWidget {
  const HomeViewModel({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(children: [
        const SizedBox(
          height: 40,
        ),
        Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            Text(
              'Bookly',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search, color: Colors.white,size: 30,),),

            const SizedBox(
              width: 20,
            ),
          ],
        )
      ]),
    );
  }
}
