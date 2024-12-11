import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pet/constants/images.dart';
import 'package:pet/features/provider/controller/service_controller.dart';
import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../constants/sizes.dart';
import '../../personalization/controller/user_controller.dart';

class BathingAndBrushing extends StatefulWidget {
  const BathingAndBrushing({super.key});

  @override
  State<BathingAndBrushing> createState() => _BathingAndBrushingState();
}

class _BathingAndBrushingState extends State<BathingAndBrushing> {
  final controller = UserController.instance;
  final BathingServiceController serviceController = Get.put(BathingServiceController());
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
        title: const Text('Bathing & Brushing', style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
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
          "1. Use a gentle cat shampoo specifically designed for cats to avoid skin irritation.",
          "2. Brush your cat before bathing to remove loose fur and prevent matting.",
          "3. Make bath time stress-free by using a non-slip mat in the tub or sink.",
          "4. Ensure the water temperature is lukewarm to keep your cat comfortable.",
          "5. Rinse thoroughly to remove all shampoo, as any residue can irritate the skin.",
        ]
            : catClickCount % 3 == 1
            ? [
          "1. Use a soft brush to avoid scratching your cat's skin during grooming.",
          "2. Introduce your cat to water gradually; some cats may need time to adjust.",
          "3. Dry your cat gently with a towel and avoid using a hairdryer, as it can scare them.",
          "4. Bathe your cat only when necessary, as too much bathing can strip natural oils.",
          "5. Reward your cat with treats or praise after bath time to create a positive experience.",
        ]
            : [
          "1. Focus on brushing areas where mats are likely to form, like behind the ears and under the legs.",
          "2. Use a grooming glove or brush designed for short-haired cats for effective brushing.",
          "3. Keep the bathing area calm and quiet to help your cat feel secure.",
          "4. Use cotton balls in your cat's ears to prevent water from entering during baths.",
          "5. If your cat shows extreme dislike for water, consider using dry shampoo or grooming wipes.",
        ];
        break;

      case 'dog':
        tips = dogClickCount % 3 == 0
            ? [
          "1. Choose a dog shampoo that suits your dog's skin type; consult your vet if unsure.",
          "2. Brush your dog before bathing to remove loose hair and prevent clogs in the drain.",
          "3. Use a handheld showerhead or cup to rinse your dog thoroughly.",
          "4. Always check the water temperature; it should be warm but not hot.",
          "5. Keep bath time short to avoid stressing your dog.",
        ]
            : dogClickCount % 3 == 1
            ? [
          "1. For dogs with long fur, use a detangling spray to ease brushing and remove knots.",
          "2. Brush your dog regularly, especially during shedding seasons, to minimize loose fur.",
          "3. Reward your dog with treats during and after bathing to create a positive association.",
          "4. Dry your dog with a towel and, if they tolerate it, a low-speed hairdryer.",
          "5. Ensure the bathing area is safe; use non-slip mats to prevent slipping.",
        ]
            : [
          "1. Avoid bathing your dog too often; it can dry out their skin. Every 4-6 weeks is usually enough.",
          "2. Brush your dog gently and with the direction of hair growth to avoid discomfort.",
          "3. Make bath time enjoyable by playing with your dog or using their favorite toys.",
          "4. Consider using a pet-specific ear cleaner to keep their ears clean and dry.",
          "5. If your dog is anxious about baths, practice desensitization techniques beforehand.",
        ];
        break;

      case 'rabbit':
        tips = rabbitClickCount % 3 == 0
            ? [
          "1. Rabbits generally don’t need baths; spot clean any dirty areas with a damp cloth.",
          "2. Use a soft brush to remove loose fur and prevent matting.",
          "3. If your rabbit gets wet, dry them thoroughly with a towel and keep them warm.",
          "4. Avoid submerging your rabbit in water, as it can cause stress and health issues.",
          "5. Regular grooming helps maintain a healthy coat and reduces shedding.",
        ]
            : rabbitClickCount % 3 == 1
            ? [
          "1. Use a brush designed for small animals to ensure gentle grooming.",
          "2. Check your rabbit's nails regularly and trim them if necessary to avoid injuries.",
          "3. If your rabbit is dirty, consider using dry shampoo formulated for rabbits.",
          "4. Create a calm environment during grooming to reduce stress.",
          "5. Always supervise your rabbit during bathing or grooming sessions.",
        ]
            : [
          "1. Get your rabbit used to handling by gently petting them before brushing.",
          "2. Never use human shampoo or soap; it can irritate your rabbit's skin.",
          "3. Keep grooming sessions short and positive to build trust.",
          "4. Reward your rabbit with treats after grooming to encourage good behavior.",
          "5. If your rabbit has a serious mess, consult a vet for the best cleaning approach.",
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
            style: body, // Ensure the 'body' style is defined in your TextStyle
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