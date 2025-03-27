// // import 'package:flutter/material.dart';
// // import 'package:url_launcher/url_launcher.dart';

// // class AgriStoreScreen extends StatelessWidget {
// //   const AgriStoreScreen({Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('AgriStore'),
// //         backgroundColor: Colors.green.shade700,
// //       ),
// //       body: ListView(
// //         padding: const EdgeInsets.all(16.0),
// //         children: const [
// //           ProductCard(
// //             name: "NPK Fertilizer (10-26-26)",
// //             description: "Balanced NPK fertilizer for all crops, promotes healthy growth and higher yields.",
// //             imageUrl: "assets/npk.jpg",
// //             price: "₹650 per 50kg bag",
// //             amazonUrl: "https://www.amazon.in/s?k=NPK+Fertilizer+10-26-26",
// //             flipkartUrl: "https://www.flipkart.com/search?q=NPK+Fertilizer+10-26-26",
// //           ),
// //           ProductCard(
// //             name: "Neem Oil Pesticide",
// //             description: "100% pure neem oil for organic pest control, safe for plants and environment.",
// //             imageUrl: "https://m.media-amazon.com/images/I/71vUZxYhRIL._SL1500_.jpg",
// //             price: "₹299 for 1 liter",
// //             amazonUrl: "https://www.amazon.in/s?k=Neem+Oil+Pesticide",
// //             flipkartUrl: "https://www.flipkart.com/search?q=Neem+Oil+Pesticide",
// //           ),
// //           ProductCard(
// //             name: "Drip Irrigation Kit",
// //             description: "Complete drip irrigation system for 50 plants, saves water and improves yield.",
// //             imageUrl: "https://m.media-amazon.com/images/I/71h1wIMnYBL._SL1500_.jpg",
// //             price: "₹2,499",
// //             amazonUrl: "https://www.amazon.in/s?k=Drip+Irrigation+Kit",
// //             flipkartUrl: "https://www.flipkart.com/search?q=Drip+Irrigation+Kit",
// //           ),
// //           ProductCard(
// //             name: "Organic Vermicompost",
// //             description: "High-quality organic compost made from earthworms, improves soil fertility.",
// //             imageUrl: "https://5.imimg.com/data5/ANDROID/Default/2021/3/OV/IM/YS/3033603/img-20210310-114503-500x500.jpg",
// //             price: "₹350 per 20kg bag",
// //             amazonUrl: "https://www.amazon.in/s?k=Organic+Vermicompost",
// //             flipkartUrl: "https://www.flipkart.com/search?q=Organic+Vermicompost",
// //           ),
// //           ProductCard(
// //             name: "Tractor Sprayer Pump",
// //             description: "16-liter backpack sprayer for pesticides and fertilizers, adjustable nozzle.",
// //             imageUrl: "https://m.media-amazon.com/images/I/61JQd5Y3rVL._SL1500_.jpg",
// //             price: "₹1,850",
// //             amazonUrl: "https://www.amazon.in/s?k=Tractor+Sprayer+Pump",
// //             flipkartUrl: "https://www.flipkart.com/search?q=Tractor+Sprayer+Pump",
// //           ),
// //           ProductCard(
// //             name: "Seeds - Hybrid Tomato",
// //             description: "High-yield hybrid tomato seeds, disease resistant, 95% germination rate.",
// //             imageUrl: "https://m.media-amazon.com/images/I/71K9JZ1X1VL._SL1500_.jpg",
// //             price: "₹150 per 100 seeds",
// //             amazonUrl: "https://www.amazon.in/s?k=Hybrid+Tomato+Seeds",
// //             flipkartUrl: "https://www.flipkart.com/search?q=Hybrid+Tomato+Seeds",
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class ProductCard extends StatelessWidget {
// //   final String name;
// //   final String description;
// //   final String imageUrl;
// //   final String price;
// //   final String amazonUrl;
// //   final String flipkartUrl;

// //   const ProductCard({
// //     Key? key,
// //     required this.name,
// //     required this.description,
// //     required this.imageUrl,
// //     required this.price,
// //     required this.amazonUrl,
// //     required this.flipkartUrl,
// //   }) : super(key: key);

// //   Future<void> _launchUrl(String url) async {
// //     if (await canLaunch(url)) {
// //       await launch(url);
// //     } else {
// //       throw 'Could not launch $url';
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Card(
// //       elevation: 4,
// //       margin: const EdgeInsets.only(bottom: 16),
// //       shape: RoundedRectangleBorder(
// //         borderRadius: BorderRadius.circular(12),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.stretch,
// //         children: [
// //           ClipRRect(
// //             borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
// //             child: Image.network(
// //               imageUrl,
// //               height: 180,
// //               fit: BoxFit.cover,
// //               loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
// //                 if (loadingProgress == null) return child;
// //                 return SizedBox(
// //                   height: 180,
// //                   child: Center(
// //                     child: CircularProgressIndicator(
// //                       value: loadingProgress.expectedTotalBytes != null
// //                           ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
// //                           : null,
// //                     ),
// //                   ),
// //                 );
// //               },
// //               errorBuilder: (context, error, stackTrace) => Container(
// //                 height: 180,
// //                 color: Colors.grey[200],
// //                 child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
// //               ),
// //             ),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.all(12.0),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   name,
// //                   style: const TextStyle(
// //                     fontSize: 18,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 8),
// //                 Text(
// //                   description,
// //                   style: TextStyle(
// //                     fontSize: 14,
// //                     color: Colors.grey[700],
// //                   ),
// //                 ),
// //                 const SizedBox(height: 8),
// //                 Text(
// //                   price,
// //                   style: const TextStyle(
// //                     fontSize: 16,
// //                     fontWeight: FontWeight.bold,
// //                     color: Colors.green,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 12),
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: OutlinedButton.icon(
// //                         icon: const Icon(Icons.shopping_bag, size: 18),
// //                         label: const Text('Amazon'),
// //                         style: OutlinedButton.styleFrom(
// //                           foregroundColor: Colors.orange,
// //                           side: const BorderSide(color: Colors.orange),
// //                         ),
// //                         onPressed: () => _launchUrl(amazonUrl),
// //                       ),
// //                     ),
// //                     const SizedBox(width: 8),
// //                     Expanded(
// //                       child: OutlinedButton.icon(
// //                         icon: const Icon(Icons.shopping_cart, size: 18),
// //                         label: const Text('Flipkart'),
// //                         style: OutlinedButton.styleFrom(
// //                           foregroundColor: Colors.blue,
// //                           side: const BorderSide(color: Colors.blue),
// //                         ),
// //                         onPressed: () => _launchUrl(flipkartUrl),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class AgriStoreScreen extends StatelessWidget {
//   const AgriStoreScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('AgriStore'),
//         backgroundColor: Colors.green.shade700,
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16.0),
//         children: const [
//           ProductCard(
//             name: "NPK Fertilizer (10-26-26)",
//             description: "Balanced NPK fertilizer for all crops, promotes healthy growth and higher yields.",
//             imageAsset: "assets/npk.jpg",
//             price: "₹650 per 50kg bag",
//             amazonUrl: "https://www.amazon.in/s?k=NPK+Fertilizer+10-26-26",
//             flipkartUrl: "https://www.flipkart.com/search?q=NPK+Fertilizer+10-26-26",
//           ),
//           ProductCard(
//             name: "Neem Oil Pesticide",
//             description: "100% pure neem oil for organic pest control, safe for plants and environment.",
//             imageAsset: "assets/neem_oil.jpg",
//             price: "₹299 for 1 liter",
//             amazonUrl: "https://www.amazon.in/s?k=Neem+Oil+Pesticide",
//             flipkartUrl: "https://www.flipkart.com/search?q=Neem+Oil+Pesticide",
//           ),
//           ProductCard(
//             name: "Drip Irrigation Kit",
//             description: "Complete drip irrigation system for 50 plants, saves water and improves yield.",
//             imageAsset: "assets/drip_irrigation.jpg",
//             price: "₹2,499",
//             amazonUrl: "https://www.amazon.in/s?k=Drip+Irrigation+Kit",
//             flipkartUrl: "https://www.flipkart.com/search?q=Drip+Irrigation+Kit",
//           ),
//           ProductCard(
//             name: "Organic Vermicompost",
//             description: "High-quality organic compost made from earthworms, improves soil fertility.",
//             imageAsset: "assets/vermicompost.jpg",
//             price: "₹350 per 20kg bag",
//             amazonUrl: "https://www.amazon.in/s?k=Organic+Vermicompost",
//             flipkartUrl: "https://www.flipkart.com/search?q=Organic+Vermicompost",
//           ),
//           ProductCard(
//             name: "Tractor Sprayer Pump",
//             description: "16-liter backpack sprayer for pesticides and fertilizers, adjustable nozzle.",
//             imageAsset: "assets/sprayer_pump.jpg",
//             price: "₹1,850",
//             amazonUrl: "https://www.amazon.in/s?k=Tractor+Sprayer+Pump",
//             flipkartUrl: "https://www.flipkart.com/search?q=Tractor+Sprayer+Pump",
//           ),
//           ProductCard(
//             name: "Hybrid Tomato Seeds",
//             description: "High-yield hybrid tomato seeds, disease resistant, 95% germination rate.",
//             imageAsset: "assets/tomato_seeds.jpg",
//             price: "₹150 per 100 seeds",
//             amazonUrl: "https://www.amazon.in/s?k=Hybrid+Tomato+Seeds",
//             flipkartUrl: "https://www.flipkart.com/search?q=Hybrid+Tomato+Seeds",
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ProductCard extends StatelessWidget {
//   final String name;
//   final String description;
//   final String imageAsset;
//   final String price;
//   final String amazonUrl;
//   final String flipkartUrl;

//   const ProductCard({
//     Key? key,
//     required this.name,
//     required this.description,
//     required this.imageAsset,
//     required this.price,
//     required this.amazonUrl,
//     required this.flipkartUrl,
//   }) : super(key: key);

//   Future<void> _launchUrl(String url) async {
//     if (await canLaunchUrl(Uri.parse(url))) {
//       await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       margin: const EdgeInsets.only(bottom: 16),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//             child: Image.asset(
//               imageAsset,
//               height: 180,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) => Container(
//                 height: 180,
//                 color: Colors.grey[200],
//                 child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   name,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   description,
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[700],
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   price,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.green,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: OutlinedButton.icon(
//                         icon: const Icon(Icons.shopping_bag, size: 18),
//                         label: const Text('Amazon'),
//                         style: OutlinedButton.styleFrom(
//                           foregroundColor: Colors.orange,
//                           side: const BorderSide(color: Colors.orange),
//                         ),
//                         onPressed: () => _launchUrl(amazonUrl),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: OutlinedButton.icon(
//                         icon: const Icon(Icons.shopping_cart, size: 18),
//                         label: const Text('Flipkart'),
//                         style: OutlinedButton.styleFrom(
//                           foregroundColor: Colors.blue,
//                           side: const BorderSide(color: Colors.blue),
//                         ),
//                         onPressed: () => _launchUrl(flipkartUrl),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AgriStoreScreen extends StatelessWidget {
  const AgriStoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AgriStore'),
        backgroundColor: Colors.green.shade700,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ProductCard(
            name: "NPK Fertilizer (10-26-26)",
            description: "Balanced NPK fertilizer for all crops, promotes healthy growth and higher yields.",
            imageAsset: "assets/fertilizer.jpg", // Make sure to add this image in your assets
            price: "₹650 per 50kg bag",
            amazonUrl: "https://www.amazon.in/s?k=NPK+Fertilizer+10-26-26",
            flipkartUrl: "https://www.flipkart.com/search?q=NPK+Fertilizer+10-26-26",
          ),
          ProductCard(
            name: "Neem Oil Pesticide",
            description: "100% pure neem oil for organic pest control, safe for plants and environment.",
            imageAsset: "assets/neem_oil.jpg", // Make sure to add this image in your assets
            price: "₹299 for 1 liter",
            amazonUrl: "https://www.amazon.in/s?k=Neem+Oil+Pesticide",
            flipkartUrl: "https://www.flipkart.com/search?q=Neem+Oil+Pesticide",
          ),
          ProductCard(
            name: "Drip Irrigation Kit",
            description: "Complete drip irrigation system for 50 plants, saves water and improves yield.",
            imageAsset: "assets/drip_irrigation.jpg", // Make sure to add this image in your assets
            price: "₹2,499",
            amazonUrl: "https://www.amazon.in/s?k=Drip+Irrigation+Kit",
            flipkartUrl: "https://www.flipkart.com/search?q=Drip+Irrigation+Kit",
          ),
          ProductCard(
            name: "Organic Vermicompost",
            description: "High-quality organic compost made from earthworms, improves soil fertility.",
            imageAsset: "assets/vermicompost.jpg", // Make sure to add this image in your assets
            price: "₹350 per 20kg bag",
            amazonUrl: "https://www.amazon.in/s?k=Organic+Vermicompost",
            flipkartUrl: "https://www.flipkart.com/search?q=Organic+Vermicompost",
          ),
          ProductCard(
            name: "Tractor Sprayer Pump",
            description: "16-liter backpack sprayer for pesticides and fertilizers, adjustable nozzle.",
            imageAsset: "assets/sprayer_pump.jpg", // Make sure to add this image in your assets
            price: "₹1,850",
            amazonUrl: "https://www.amazon.in/s?k=Tractor+Sprayer+Pump",
            flipkartUrl: "https://www.flipkart.com/search?q=Tractor+Sprayer+Pump",
          ),
          ProductCard(
            name: "Hybrid Tomato Seeds",
            description: "High-yield hybrid tomato seeds, disease resistant, 95% germination rate.",
            imageAsset: "assets/tomato_seeds.jpg", // Make sure to add this image in your assets
            price: "₹150 per 100 seeds",
            amazonUrl: "https://www.amazon.in/s?k=Hybrid+Tomato+Seeds",
            flipkartUrl: "https://www.flipkart.com/search?q=Hybrid+Tomato+Seeds",
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final String description;
  final String imageAsset;
  final String price;
  final String amazonUrl;
  final String flipkartUrl;

  const ProductCard({
    Key? key,
    required this.name,
    required this.description,
    required this.imageAsset,
    required this.price,
    required this.amazonUrl,
    required this.flipkartUrl,
  }) : super(key: key);

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // This is where the product image is displayed
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              imageAsset,
              height: 180,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 180,
                color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.shopping_bag, size: 18),
                        label: const Text('Amazon'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.orange,
                          side: const BorderSide(color: Colors.orange),
                        ),
                        onPressed: () => _launchUrl(amazonUrl),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.shopping_cart, size: 18),
                        label: const Text('Flipkart'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          side: const BorderSide(color: Colors.blue),
                        ),
                        onPressed: () => _launchUrl(flipkartUrl),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}