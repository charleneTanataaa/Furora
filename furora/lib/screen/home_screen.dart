import 'package:flutter/material.dart';
import 'package:furora/components/image_store.dart';
import 'package:furora/screen/image_view_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  @override
  Widget build(BuildContext context) {
    final images = ImageStore.images;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Gallery',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
         Expanded(
            child: ImageStore.images.isEmpty
              ? const Center(child: Text("No photos yet"))
            : Padding(
              padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: ImageStore.images.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemBuilder: (context, index) {
            final item = images[index];
      
            return GestureDetector(
              onTap: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (_) => ImageViewPage(
                      image: item,
                      onDelete:(){
                        setState((){
                          images.remove(item);
                        });
                      },
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.memory(
                        item.bytes,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                )
              ),
            );
          },
        ),
      )
      ),
      ],
      ),
    );
  }
}