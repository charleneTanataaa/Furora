import 'package:flutter/material.dart';
import 'package:furora/components/image_store.dart';
import 'package:furora/screen/image_view_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final images = ImageStore.images;

    if (ImageStore.images.isEmpty) {
      return const Center(
        child: Text("No photos yet"),
      );
    }

    return Padding(
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
                  builder: (_) => ImageViewPage(image: item)
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
            
                  Positioned(
                    bottom: 1,
                    right: 5,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        item.expression,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              )
            ),
          );
        },
      ),
    );
  }
}