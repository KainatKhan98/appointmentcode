import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pet/constants/images.dart';
import 'package:pet/features/provider/controller/service_controller.dart';
import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../constants/sizes.dart';
import '../../personalization/controller/user_controller.dart';

class StylingAndTouches extends StatefulWidget {
  const StylingAndTouches({super.key});

  @override
  State<StylingAndTouches> createState() => _StylingAndTouchesState();
}

class _StylingAndTouchesState extends State<StylingAndTouches> {
  final controller = UserController.instance;
  final StylingServiceController serviceController = Get.put(StylingServiceController());
  String? selectedPet;
  int currentPageIndex = 0;
  int catClickCount = 0; // Counter for Cat clicks
  int dogClickCount = 0; // Counter for Dog clicks
  int rabbitClickCount = 0;
  bool isCatLoading = false;  // Track loading state for Cat
  bool isDogLoading = false;  // Track loading state for Dog
  bool isRabbitLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Styling & touches',style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 200,
                        width: double.infinity, // Use double.infinity to fit the container width
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 4,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          color: backgrndclrpurple,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Image(
                          image: AssetImage(litterTraining),
                          fit: BoxFit.cover, // Ensure the image fits the container
                        ),
                      ),
                      SizedBox(height: Sizes.m),
                      Text('Select Pet Type', style: Theme.of(context).textTheme.headlineSmall),
                      SizedBox(height: Sizes.s),
                      RichText(
                        text: const TextSpan(
                          text: 'Note: ', style: TextStyle(color: Colors.red,fontSize: 18),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Selecting a pet type helps us provide the most relevant vaccination tips for your pet.',style: body
                            ),
                          ],
                        ),
                      ),


                      SizedBox(height: Sizes.m),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isCatLoading = true; // Show loading indicator
                              });

                              Future.delayed(const Duration(seconds: 2), () {
                                setState(() {
                                  selectedPet = 'cat';
                                  catClickCount++;
                                  isCatLoading = false; // Hide loading indicator
                                });
                              });
                            }, // End of onTap (Cat)
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    spreadRadius: 4,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ), // End of BoxDecoration (Cat)
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  const CircleAvatar(
                                    maxRadius: 45.0,
                                    backgroundImage: AssetImage(cat),
                                  ), // End of CircleAvatar (Cat)
                                  if (isCatLoading)
                                    const CircularProgressIndicator(
                                      color: Colors.purple,
                                    ), // End of CircularProgressIndicator (Cat)
                                ], // End of children in Stack (Cat)
                              ), // End of Stack (Cat)
                            ), // End of Container (Cat)
                          ), // End of GestureDetector (Cat)
                          const SizedBox(width: 15), // Add spacing between pet icons
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isDogLoading = true; // Show loading indicator
                              });

                              Future.delayed(const Duration(seconds: 2), () {
                                setState(() {
                                  selectedPet = 'dog';
                                  dogClickCount++;
                                  isDogLoading = false; // Hide loading indicator
                                });
                              });
                            }, // End of onTap (Dog)
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    spreadRadius: 4,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  const CircleAvatar(
                                    maxRadius: 45.0,
                                    backgroundImage: AssetImage(dog),
                                  ), // End of CircleAvatar (Dog)
                                  if (isDogLoading)
                                    const CircularProgressIndicator(
                                      color: Colors.purple,
                                    ),
                                ], // End of children in Stack (Dog)
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isRabbitLoading = true; // Show loading indicator
                              });

                              Future.delayed(const Duration(seconds: 2), () {
                                setState(() {
                                  selectedPet = 'rabbit';
                                  rabbitClickCount++;
                                  isRabbitLoading = false; // Hide loading indicator
                                });
                              });
                            }, // End of onTap (Rabbit)
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    spreadRadius: 4,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ), // End of BoxDecoration (Rabbit)
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  const CircleAvatar(
                                    maxRadius: 45.0,
                                    backgroundImage: AssetImage(rabbit),
                                  ), // End of CircleAvatar (Rabbit)
                                  if (isRabbitLoading)
                                    const CircularProgressIndicator(
                                      color: Colors.purple,
                                    ), // End of CircularProgressIndicator (Rabbit)
                                ], // End of children in Stack (Rabbit)
                              ), // End of Stack (Rabbit)
                            ), // End of Container (Rabbit)
                          ), // End of GestureDetector (Rabbit)
                        ], // End of children in Row
                      ),
                      const SizedBox(height: 20),
                      if (selectedPet != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 150, // Fixed height for ListView
                              child: buildPetTips(selectedPet!),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      SizedBox(height: Sizes.defaultPadding),
                      Text('Nearby Service Providers', style: Theme.of(context).textTheme.headlineMedium),
                      SizedBox(height: Sizes.defaultPadding),
                      Obx(() {

                        if (serviceController.isLoading) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (serviceController.services.isEmpty) {
                          return Center(child: Text("No services available"));
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: serviceController.services.length,
                          itemBuilder: (context, index) {
                            final service = serviceController.services[index];
                            return Card(
                              margin: EdgeInsets.all(8),
                              elevation: 5,  // Adds shadow to the card for a more elevated look
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),  // Rounded corners for the card
                              ),
                              color: backgrndclrpurple,  // Background color of the card
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),  // Padding inside the ListTile
                                title: Text(
                                  service.name,
                                  style: TextStyle(
                                    fontSize: 20,  // Larger font for the service name
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,  // Dark text color for better readability
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8),  // Padding to separate subtitle text from title
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'User: ${service.user.fullName}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,  // Lighter text color for the user's name
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Price: ',  // This will be in black
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black,  // Black color for "Price"
                                              ),
                                            ),
                                            TextSpan(
                                              text: '\$${service.price.toString()}',  // This will be in green
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green,  // Green color for the actual price
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Text(
                                        'Duration: ${service.durationInMinutes} mins',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,  // Slightly lighter text for duration
                                        ),
                                      ),


                                    ],

                                  ),
                                ),
                                trailing: Icon(
                                  service.isAvailable ? Icons.check_circle : Icons.cancel,
                                  color: service.isAvailable ? Colors.green : Colors.red,  // Green for available, red for unavailable
                                  size: 28,  // Icon size
                                ),
                              ),
                            );

                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
  Widget buildPetTips(String petType) {
    List<String> tips = [];

    switch (petType) {
      case 'cat':
        tips = catClickCount % 3 == 0
            ? [
          "Use a de-shedding tool designed specifically for cats to reduce loose hair.",
          "Regular brushing helps prevent matting and keeps your cat's coat smooth.",
          "If your cat's hair is prone to matting, consider a professional trim to avoid discomfort.",
          "During shedding season, increase the frequency of brushing to manage loose fur.",
          "Avoid cutting your cat's hair at home unless you're experienced; consult a groomer for trims.",
        ]
            : catClickCount % 3 == 1
            ? [
          "For long-haired cats, focus on de-shedding tools that reach undercoats without damaging top fur.",
          "Give your cat a haircut if their fur becomes too long or tangled, but seek professional grooming advice first.",
          "If you notice excessive shedding, consult your vet to rule out any health issues.",
          "Use grooming gloves to gently remove loose fur during de-shedding.",
          "Regular trims can help prevent fur from becoming unmanageable, especially in hot weather.",
        ]
            : [
          "When de-shedding, focus on areas like the belly and behind the ears, where fur tends to mat easily.",
          "Use a thinning shear to remove excess hair without causing discomfort during grooming.",
          "For cats that dislike grooming, break the session into smaller intervals.",
          "Ensure that your grooming tools are appropriate for your cat's fur length and texture.",
          "For heavily matted fur, professional grooming might be necessary to avoid hurting your cat.",
        ];
        break;

      case 'dog':
        tips = dogClickCount % 3 == 0
            ? [
          "De-shedding tools with fine bristles help remove your dog's loose undercoat without irritation.",
          "Regular haircuts for long-haired dogs help maintain their coats and reduce shedding.",
          "Focus on areas where your dog tends to shed the most, like their back and sides.",
          "Keep your dog comfortable during haircuts by using clippers with adjustable blade lengths.",
          "Consider professional grooming for complex haircuts or large dogs to ensure safety and quality.",
        ]
            : dogClickCount % 3 == 1
            ? [
          "During shedding season, brush your dog daily to manage loose hair and avoid mats.",
          "Professional haircuts can help keep your dog cool in warm weather and reduce shedding.",
          "Use de-shedding shampoos or treatments to minimize loose fur during baths.",
          "Haircuts should always match the breed’s coat type; ask your groomer for advice if unsure.",
          "For dogs with heavy shedding, a professional de-shedding treatment might be the best option.",
        ]
            : [
          "Regular haircuts help maintain coat health and reduce shedding in dogs with thick or long fur.",
          "Always use scissors and clippers designed for dog grooming to avoid accidental cuts.",
          "To manage shedding, consider using a high-velocity dryer after baths to remove loose fur.",
          "Focus on high-shed areas like the neck, chest, and tail when using de-shedding tools.",
          "If your dog is shedding excessively, consult a vet to check for underlying health conditions.",
        ];
        break;

      case 'rabbit':
        tips = rabbitClickCount % 3 == 0
            ? [
          "Use a soft de-shedding tool to remove loose fur from your rabbit’s coat.",
          "Trim any overgrown fur, especially in long-haired rabbits, to avoid tangling and matting.",
          "During shedding season, brush your rabbit more frequently to manage loose hair.",
          "Keep the grooming process gentle to prevent stress; rabbits can be sensitive during de-shedding.",
          "For excessive fur growth, a light trim may be necessary, but always consult a vet or groomer before cutting.",
        ]
            : rabbitClickCount % 3 == 1
            ? [
          "Use a soft brush to gently de-shed your rabbit without pulling on their delicate skin.",
          "Trimming excess fur around the rear and belly can help with hygiene and prevent matting.",
          "During heavy shedding periods, daily brushing is recommended to avoid fur buildup.",
          "If your rabbit's fur is long, consider professional grooming to prevent tangles.",
          "Make sure your rabbit feels safe during grooming to avoid stress; calm environments work best.",
        ]
            : [
          "For rabbits with long fur, use blunt-nose scissors to carefully trim areas prone to matting.",
          "A regular de-shedding routine helps maintain your rabbit’s fur health and reduces loose fur.",
          "Trimming fur around sensitive areas, like the rear, can help keep your rabbit clean and comfortable.",
          "If your rabbit is shedding excessively, check their diet or environment for stressors.",
          "Always avoid over-grooming, which can cause skin irritation and stress in rabbits.",
        ];
        break;
    }

    return ListView.builder(
      itemCount: tips.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.pets,
                color: Colors.teal,
                size: 30,
              ),
              title: Text(
                tips[index],
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}
class PetClinicCard extends StatelessWidget {
  final String clinicName;
  final String location;
  final String imagePath;
  final Widget targetScreen;

  const PetClinicCard({super.key, 
    required this.clinicName,
    required this.location,
    required this.imagePath,
    required this.targetScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 4,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.purple),
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(imagePath),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clinicName,
                    style:heading2,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(5, (index) {
                      return const Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 16.0,
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      text: 'Location: ',
                      style: bodybold,
                      children: <TextSpan>[
                        TextSpan(
                          text: location,
                          style:body,
                        ),
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  CustomElevatedButton(
                    title: 'Book Now',
                    targetScreen: targetScreen,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}