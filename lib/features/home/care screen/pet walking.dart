import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pet/features/provider/controller/service_controller.dart';
import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../constants/images.dart';
import '../../../constants/sizes.dart';
import '../../personalization/controller/user_controller.dart';

class PetWalking extends StatefulWidget {
  const PetWalking({super.key});

  @override
  State<PetWalking> createState() => _PetWalkingState();
}

class _PetWalkingState extends State<PetWalking> {
  final controller = UserController.instance;
  final PetWalkingServiceController serviceController = Get.put(PetWalkingServiceController());
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
        title: const Text('Pet Walking',style: TextStyle(color: textColor, fontWeight: FontWeight.w500),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white
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
                          image: AssetImage(petWalking),
                          fit: BoxFit.contain, // Ensure the image fits the container
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
        tips = [
          "1. Use a harness instead of a collar for safer outdoor walks.",
          "2. Start with short walks to help your cat get accustomed to being outside.",
          "3. Choose a quiet, safe area for walks, away from loud noises and traffic.",
          "4. Bring treats to reward your cat for good behavior during walks.",
          "5. Keep an eye on your cat for signs of stress and cut the walk short if needed.",
          "6. Train your cat to walk on a leash indoors before going outside.",
          "7. Always supervise your cat while walking to ensure their safety.",
          "8. Avoid letting your cat interact with strange animals during walks.",
          "9. Bring water along on hot days to keep your cat hydrated.",
          "10. Make sure your cat is up to date on vaccinations before taking them outside.",
        ];
        break;

      case 'dog':
        tips = [
          "1. Use a sturdy collar and leash for better control while walking.",
          "2. Take your dog on daily walks to help them stay healthy and happy.",
          "3. Always clean up after your dog to keep public spaces clean.",
          "4. Teach your dog basic commands like 'sit' and 'stay' for better behavior during walks.",
          "5. Bring water and treats along to keep your dog hydrated and motivated.",
          "6. Choose a suitable walking route that matches your dog’s energy level.",
          "7. Be mindful of the weather; avoid walking on hot pavement during summer.",
          "8. Use reflective gear during evening walks for safety.",
          "9. Avoid distractions like other dogs or wildlife to keep your dog focused.",
          "10. Gradually increase walk length to build your dog’s stamina.",
        ];
        break;

      case 'rabbit':
        tips = [
          "1. Use a secure carrier for transporting your rabbit to a safe walking area.",
          "2. Start with short outdoor sessions to help your rabbit acclimate.",
          "3. Always supervise your rabbit during walks to prevent escape.",
          "4. Look for rabbit-friendly parks or quiet gardens for a safe walking environment.",
          "5. Ensure the ground is soft and safe for your rabbit’s sensitive paws.",
          "6. Avoid walking your rabbit on hot or hard surfaces to protect their paws.",
          "7. Use a harness designed for rabbits to keep them secure during walks.",
          "8. Allow your rabbit to explore at their own pace and avoid forcing them.",
          "9. Keep an eye out for any signs of distress and cut the walk short if necessary.",
          "10. Provide fresh greens or treats to reward your rabbit after the walk.",
        ];
        break;

      default:
        tips = ["Please select a valid pet type: cat, dog, or rabbit."];
        break;
    }

    return ListView.builder(
      itemCount: tips.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            tips[index],
            style: const TextStyle(fontSize: 16), // Customize your text style as needed
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