import 'package:flutter/material.dart';
import 'package:furora/components/image_store.dart';

class ImageViewPage extends StatelessWidget {
  final CapturedImage image;
  final VoidCallback? onDelete;
  const ImageViewPage({
    super.key, 
    required this.image,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: const Color(0xFFF5F5F5),
            ),
          ),
          
          Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height*0.75,
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _buildMemoryCard(context),
                ),
              ),
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemoryCard(BuildContext context) {
    final formattedDate = '${image.date.day.toString().padLeft(2, '0')}/'
        '${image.date.month.toString().padLeft(2, '0')}/'
        '${image.date.year}';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        children: [
          // Date text at top
          Padding(
            padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                Text(
                  formattedDate,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  onPressed: () => _confirmDelete(context),
                  icon: const Icon(Icons.close, color: Colors.black87),
                  style: IconButton.styleFrom(
                    minimumSize: const Size(32,32),
                    padding:EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: ClipRRect(
                child: Image.memory(
                  image.bytes,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),

          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    image.expression,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 6),
                  
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 18,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        image.location,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

void _confirmDelete(BuildContext context){
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Delete photo?'),
      content: const Text('This photo will be permanently deleted.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx), 
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: (){
            Navigator.pop(ctx);
            Navigator.pop(context);
            onDelete?.call();
          },
          style:TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Delete'),
        ),
    ],
  ),
  );
}
}