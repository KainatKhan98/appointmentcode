
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet/constants/images.dart';
import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../constants/sizes.dart';
import '../../personalization/controller/user_controller.dart';
import '../../provider/controller/service_controller.dart';
import '../appointment/descriptionscreen.dart';


class DentalCare extends StatefulWidget {
  const DentalCare({super.key});

  @override
  State<DentalCare> createState() => _DentalCareState();
}

class _DentalCareState extends State<DentalCare> {
  final controller = UserController.instance;
  final DentalCareServiceController serviceController = Get.put(DentalCareServiceController());
  // final DentalCareServiceController providerserviceController = Get.put(DentalCareServiceController());
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
        title: const Text('Dental care', style: TextStyle(color: textColor, fontWeight: FontWeight.w500),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor:Colors.white,
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
                          image: AssetImage(dental),
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
                      Obx(() {

                        // if (serviceController.isLoading) {
                        //   return Center(child: CircularProgressIndicator());
                        // }
                        if (serviceController.services.isEmpty) {
                          return Center(child: Text("No services available"));
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: serviceController.services.length,
                          itemBuilder: (context, index) {
                            final service = serviceController.services[index];

                            return GestureDetector(
                              // Fetching provider details
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookingScreen(
                                      name: service.name, // No changes for other fields
                                      description: service.description,
                                      price: service.price,
                                      duration: service.durationInMinutes,
                                      userName: service.user.fullName,
                                      userEmail: service.user.email,
                                      profileImageUrl: service.user.profilePicture ?? "",
                                       // Default to an empty string if null
                                    ),
                                  ),
                                );
                              },



                              child: Card(
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
          "1. Brush your cat's teeth regularly to prevent plaque buildup.",
          "2. Use cat-friendly toothpaste, never human toothpaste.",
          "3. Offer dental treats to help maintain your cat’s oral hygiene.",
          "4. Schedule regular dental checkups with your vet.",
          "5. Provide toys that help clean your cat's teeth as they chew.",
        ]
            : catClickCount % 3 == 1
            ? [
          "1. Start dental care at an early age to get your cat used to it.",
          "2. Check your cat's gums for any signs of redness or swelling.",
          "3. Use a soft-bristled toothbrush designed for cats.",
          "4. Bad breath can be a sign of dental issues, so keep an eye on it.",
          "5. Add dental health supplements to your cat's diet if recommended by your vet.",
        ]
            : [
          "1. Regular brushing reduces the risk of gum disease in cats.",
          "2. Look for cat-specific dental chews to help clean teeth.",
          "3. Avoid giving your cat hard objects that could damage their teeth.",
          "4. Check for signs of tartar buildup on your cat's teeth regularly.",
          "5. If your cat resists tooth brushing, consult your vet for alternatives.",
        ];
        break;

      case 'dog':
        tips = dogClickCount % 3 == 0
            ? [
          "1. Brush your dog's teeth daily with dog-safe toothpaste.",
          "2. Provide chew toys that promote dental health.",
          "3. Schedule annual dental checkups for your dog.",
          "4. Watch for signs of dental problems like bad breath or difficulty chewing.",
          "5. Use dental rinses or water additives recommended by your vet.",
        ]
            : dogClickCount % 3 == 1
            ? [
          "1. Start dental care early to prevent gum disease in dogs.",
          "2. Look for dental treats that help reduce plaque and tartar buildup.",
          "3. Regular brushing is the best way to maintain your dog's oral health.",
          "4. Avoid giving your dog bones or hard chews that could crack their teeth.",
          "5. Check your dog’s mouth regularly for any signs of pain or infection.",
        ]
            : [
          "1. Keep your dog's teeth clean with regular brushing and dental chews.",
          "2. Dental diseases can affect your dog's overall health, so take it seriously.",
          "3. Use finger toothbrushes if your dog resists regular brushes.",
          "4. Keep an eye on your dog's breath; bad breath could signal dental issues.",
          "5. Make dental care part of your dog's routine for long-term health.",
        ];
        break;

      case 'rabbit':
        tips = rabbitClickCount % 3 == 0
            ? [
          "1. Provide plenty of hay, which helps naturally wear down rabbit teeth.",
          "2. Check your rabbit's teeth regularly for signs of overgrowth.",
          "3. Give chew toys to help keep your rabbit's teeth healthy.",
          "4. Monitor your rabbit’s eating habits; dental issues can cause a loss of appetite.",
          "5. Schedule regular vet checkups to monitor your rabbit's dental health.",
        ]
            : rabbitClickCount % 3 == 1
            ? [
          "1. Avoid sugary treats, which can contribute to dental problems in rabbits.",
          "2. Ensure your rabbit is chewing properly to keep their teeth in check.",
          "3. Dental issues in rabbits can lead to serious health problems, so consult your vet regularly.",
          "4. If you notice drooling, it could be a sign of dental issues.",
          "5. Make sure your rabbit's diet includes a variety of fibrous foods to help wear down their teeth.",
        ]
            : [
          "1. Long teeth can cause pain and eating problems in rabbits, so monitor regularly.",
          "2. Provide wooden chew toys or natural branches to keep your rabbit's teeth trimmed.",
          "3. Overgrown teeth can cause injuries to your rabbit's mouth and jaw.",
          "4. Look for signs like weight loss, which could indicate dental issues.",
          "5. Regular vet visits are essential for preventing dental diseases in rabbits.",
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

