import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pet/features/provider/controller/service_controller.dart';
import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../constants/images.dart';
import '../../../constants/sizes.dart';
import '../../personalization/controller/user_controller.dart';

class PetSitting extends StatefulWidget {
  const PetSitting({super.key});

  @override
  State<PetSitting> createState() => _PetSittingState();
}

class _PetSittingState extends State<PetSitting> {
  final controller = UserController.instance;
  final PetSittingServiceController serviceController = Get.put(PetSittingServiceController());
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
        title: const Text('Pet Sitting', style: TextStyle(color: textColor, fontWeight: FontWeight.w500),),
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
                          image: AssetImage(petSitting),
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
          "1. Use a harness instead of a collar for safer outdoor walks.",
          "2. Start with short walks to help your cat get used to being outside.",
          "3. Choose a quiet, safe area for walks, away from loud noises and traffic.",
          "4. Bring treats to reward your cat for good behavior during walks.",
          "5. Keep an eye on your cat for signs of stress, and cut the walk short if needed.",
        ]
            : catClickCount % 3 == 1
            ? [
          "1. Train your cat to walk on a leash indoors before venturing outside.",
          "2. Always supervise your cat while walking to ensure their safety.",
          "3. Avoid letting your cat interact with strange animals during walks.",
          "4. Bring water along on hot days to keep your cat hydrated.",
          "5. Ensure your cat is up to date on vaccinations before taking them outside.",
        ]
            : [
          "1. Use a lightweight leash that won’t weigh your cat down.",
          "2. Look for signs of fatigue and take breaks as needed during walks.",
          "3. Make sure your cat is comfortable with the harness before walking.",
          "4. Avoid busy streets and areas with a lot of foot traffic.",
          "5. Monitor your cat’s paws for signs of irritation or injury after walks.",
        ];
        break;

      case 'dog':
        tips = dogClickCount % 3 == 0
            ? [
          "1. Use a sturdy collar and leash for better control while walking.",
          "2. Take your dog on daily walks to help them stay healthy and happy.",
          "3. Always clean up after your dog to keep public spaces clean.",
          "4. Teach your dog basic commands like 'sit' and 'stay' for better behavior during walks.",
          "5. Bring water and treats along to keep your dog hydrated and motivated.",
        ]
            : dogClickCount % 3 == 1
            ? [
          "1. Choose a suitable walking route that matches your dog’s energy level.",
          "2. Be mindful of the weather; avoid walking on hot pavement during summer.",
          "3. Use reflective gear during evening walks for safety.",
          "4. Avoid distractions like other dogs or wildlife to keep your dog focused.",
          "5. Gradually increase walk length to build your dog’s stamina.",
        ]
            : [
          "1. Incorporate playtime or training exercises during walks for mental stimulation.",
          "2. Use a comfortable harness for large breeds to prevent pulling.",
          "3. Schedule regular vet checkups to ensure your dog is fit for walking.",
          "4. Avoid overly crowded areas where your dog might feel anxious.",
          "5. Encourage good leash manners to prevent pulling and jumping.",
        ];
        break;

      case 'rabbit':
        tips = rabbitClickCount % 3 == 0
            ? [
          "1. Use a secure carrier for transporting your rabbit to a safe walking area.",
          "2. Start with short outdoor sessions to help your rabbit acclimate.",
          "3. Always supervise your rabbit during walks to prevent escape.",
          "4. Look for rabbit-friendly parks or quiet gardens for a safe walking environment.",
          "5. Ensure the ground is soft and safe for your rabbit’s sensitive paws.",
        ]
            : rabbitClickCount % 3 == 1
            ? [
          "1. Avoid walking your rabbit on hot or hard surfaces to protect their paws.",
          "2. Use a harness designed for rabbits to keep them secure during walks.",
          "3. Allow your rabbit to explore at their own pace and avoid forcing them.",
          "4. Keep an eye out for any signs of distress and cut the walk short if necessary.",
          "5. Make sure your rabbit is up to date on vaccinations before taking them outside.",
        ]
            : [
          "1. Create a safe space in your yard where your rabbit can explore freely.",
          "2. Train your rabbit to respond to your commands for better control.",
          "3. Avoid areas with a lot of dogs or other potential stressors for your rabbit.",
          "4. Monitor your rabbit's behavior and comfort level during walks.",
          "5. Provide fresh greens or treats to reward your rabbit after the walk.",
        ];
        break;
    }

    return ListView.builder(
      itemCount: tips.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            tips[index],
            style: body, // Make sure to define the 'body' style in your TextStyle
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