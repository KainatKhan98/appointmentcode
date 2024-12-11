import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pet/features/provider/controller/service_controller.dart';
import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../constants/images.dart';
import '../../../constants/sizes.dart';
import '../../personalization/controller/user_controller.dart';


class RoutineCheckup extends StatefulWidget {
  const RoutineCheckup({super.key});

  @override
  State<RoutineCheckup> createState() => _RoutineCheckupState();
}

class _RoutineCheckupState extends State<RoutineCheckup> {
  final controller = UserController.instance;
  final RoutineCheckupServiceController routineserviceController = Get.put(RoutineCheckupServiceController());
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
        title: const Text('Routine Checkup', style: TextStyle(color: textColor, fontWeight: FontWeight.w500),),
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
                          image: AssetImage(routineCheckup),
                          fit: BoxFit.fill, // Ensure the image fits the container
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

                        if (routineserviceController.isLoading) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (routineserviceController.services.isEmpty) {
                          return Center(child: Text("No services available"));
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: routineserviceController.services.length,
                          itemBuilder: (context, index) {
                            final service = routineserviceController.services[index];
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
          "1. Schedule regular checkups with your vet to monitor your cat's overall health.",
          "2. Keep track of your cat's weight and eating habits during checkups.",
          "3. Regular dental cleanings are important to prevent dental issues.",
          "4. Ensure your cat is up to date with flea and worm treatments.",
          "5. Discuss your cat's diet with your vet for optimal nutrition.",
        ]
            : catClickCount % 3 == 1
            ? [
          "1. During checkups, ask your vet about any vaccinations your cat may need.",
          "2. Check your cat's ears regularly for signs of infection or mites.",
          "3. Routine blood tests can help detect underlying health issues early.",
          "4. Discuss behavioral changes with your vet, as they could indicate health issues.",
          "5. Keep a record of your cat's health history to discuss during checkups.",
        ]
            : [
          "1. Ensure your cat's litter box habits are normal, as changes may signal health problems.",
          "2. Keep your cat's claws trimmed to avoid overgrowth or injury.",
          "3. Regularly check your cat's coat for signs of fleas or skin issues.",
          "4. Discuss any unusual behaviors, such as excessive grooming, with your vet.",
          "5. Keep an eye on your cat's hydration levels, especially in hot weather.",
        ];
        break;

      case 'dog':
        tips = dogClickCount % 3 == 0
            ? [
          "1. Schedule routine checkups to monitor your dog's health and wellbeing.",
          "2. Check your dog's teeth regularly and ensure proper dental hygiene.",
          "3. Keep your dog's vaccinations up to date during checkups.",
          "4. Monitor your dog's weight and adjust their diet as necessary.",
          "5. Make sure your dog receives regular heartworm and flea prevention treatments.",
        ]
            : dogClickCount % 3 == 1
            ? [
          "1. Ask your vet about joint health, especially in older dogs.",
          "2. Keep track of any behavioral changes and report them during checkups.",
          "3. Routine bloodwork can help catch health issues early.",
          "4. Make sure your dog’s coat is clean and free of fleas or ticks.",
          "5. Discuss your dog’s exercise routine with your vet for optimal health.",
        ]
            : [
          "1. Keep your dog's nails trimmed to avoid discomfort or injury.",
          "2. Regular ear checks can prevent infections in dogs, especially those with floppy ears.",
          "3. Ensure your dog's diet is balanced and provides all necessary nutrients.",
          "4. Watch for any signs of discomfort or stiffness in your dog's movement.",
          "5. Keep your dog’s medical records up to date for future checkups.",
        ];
        break;

      case 'rabbit':
        tips = rabbitClickCount % 3 == 0
            ? [
          "1. Schedule regular checkups to ensure your rabbit is healthy.",
          "2. Check your rabbit’s teeth regularly, as overgrown teeth can cause health problems.",
          "3. Ensure your rabbit's diet includes plenty of hay to maintain good digestive health.",
          "4. Monitor your rabbit's weight during routine checkups.",
          "5. Discuss any behavioral changes or unusual symptoms with your vet.",
        ]
            : rabbitClickCount % 3 == 1
            ? [
          "1. Regularly check your rabbit’s fur for signs of parasites.",
          "2. Ask your vet about nail trimming during routine checkups.",
          "3. Keep your rabbit’s cage clean and sanitized to prevent infections.",
          "4. Discuss your rabbit's diet and any changes in appetite with your vet.",
          "5. Ensure your rabbit is receiving proper vaccinations if necessary.",
        ]
            : [
          "1. Monitor your rabbit’s digestive health and consult your vet if there are changes.",
          "2. Keep your rabbit’s living area free of hazards to prevent injury.",
          "3. Regularly check your rabbit's ears for signs of infection.",
          "4. Discuss dental care options for your rabbit during checkups.",
          "5. Make sure your rabbit gets enough exercise to stay healthy.",
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
            style: body,
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

