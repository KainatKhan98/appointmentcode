import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pet/features/provider/model/provider_model.dart';
import '../../../common/widgets/loaders/loaders.dart';
import '../../../constants/images.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../authentication/models/user_model.dart';
import '../model/service_model.dart'; // Adjust the import based on your project structure

class ServiceController extends GetxController {
  var services = <ServiceModel>[].obs; // Observable list of services
  var provider = <ServiceProviderModel>[].obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  RxBool isAvailable = true.obs;
  var selectedCategory = ''.obs;
  var selectedSubCategory = ''.obs;
  // Controllers for form fields
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  void initializeWithService(ServiceModel service) {
    nameController.text = service.name;
    descriptionController.text = service.description;
    priceController.text = service.price.toString();
    durationController.text = service.durationInMinutes.toString();
    selectedCategory.value = service.category;
    isAvailable.value = service.isAvailable;
  }

  Map<String, List<String>> categorySubCategories = {
    'Pet Care': ['Vaccination', 'Dental Care', 'Routine Checkup', 'Illness and Injuries', 'Pet Sitting', 'Pet Walking', 'Litter Training'],
    'Pet Grooming': ['Bathing', 'Styling', 'Hair Cutting/Deshedding'],
  };

  @override
  void onInit() {
    super.onInit();
    if (categorySubCategories.isNotEmpty) {
      selectedCategory.value =
          categorySubCategories.keys.first; // Set the first category as default
      selectedSubCategory.value =
          categorySubCategories[selectedCategory.value]?.first ??
              ''; // Set the first subcategory as default
    }

    fetchPetCareServices();
  }

  // Fetch services from Firestore
  Future<void> fetchServices(String providerId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('providers')
          .doc(providerId)
          .collection('Services')
          .get();

      // Map Firestore documents to ServiceModel objects and update the services list
      services.value = snapshot.docs
          .map((doc) =>
          ServiceModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching services: $e');
    }
  }

  // Add a new service to Firestore
  Future<void> addService(BuildContext context, {required providerId, String? certificateUrl,}) async {
    UserModel user = await fetchUser(FirebaseAuth.instance.currentUser!.uid);
    print('Provider ID: ${FirebaseAuth.instance.currentUser?.uid}');
    String serviceId = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString(); // Example of generating a unique ID

    // Create a new ServiceModel based on user input
    ServiceModel newService = ServiceModel(
      serviceId: serviceId,
      name: nameController.text,
      description: descriptionController.text,
      price: double.parse(priceController.text),
      durationInMinutes: int.parse(durationController.text),
      isAvailable: isAvailable.value,
      category: selectedSubCategory.value,
      certificateUrl: certificateUrl,
      user: user,

    );

    try {
      FullScreenLoader.openLoadingDialogue("Adding Service...", loader);
      await FirebaseFirestore.instance
          .collection('providers')
          .doc(providerId)
          .collection('Services')
          .doc(serviceId)
          .set(newService.toJson());

      Loaders.successSnackBar(
          title: "Success!", message: 'Service is added successfully');

      FullScreenLoader.stopLoading();

      clearForm();
      Navigator.of(context).pop();
    } catch (e) {
      Loaders.errorSnackBar(
          title: "Error", message: 'Failed to add service: $e');
      FullScreenLoader.stopLoading();
    }
  }

  void clearForm() {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    durationController.clear();
    selectedCategory.value = '';
    selectedSubCategory.value = '';
    isAvailable.value = true;
  }

  // Toggle service availability
  void toggleServiceAvailability(int index) {
    ServiceModel service = services[index];
    service.isAvailable = !service.isAvailable;

    FirebaseFirestore.instance
        .collection('services')
        .doc(service.serviceId)
        .update({'IsAvailable': service.isAvailable}).then((_) {
      services[index] = service; // Update the observable list
      Get.snackbar("Success", "Service availability updated!");
    }).catchError((error) {
      Get.snackbar("Error", "Failed to update availability: $error");
    });
  }

  // Upload certificate (PDF) to Firebase Storage
  Future<String?> uploadCertificateToFirebase(BuildContext context, String filePath, String serviceId) async {
    try {
      // Reference to Firebase Storage
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('certificates/$serviceId.pdf'); // Store PDF under serviceId.pdf

      // Upload the file
      UploadTask uploadTask = ref.putFile(File(filePath));

      // Wait for the upload to complete
      TaskSnapshot snapshot = await uploadTask;

      // Get the file URL
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl; // Return the URL of the uploaded PDF
    } catch (e) {
      Get.snackbar("Error", "Failed to upload certificate: $e");
      return null;
    }
  }

  Future<void> updateService(String serviceId, {required String providerId, String? certificateUrl}) async {
    UserModel user = await fetchUser(FirebaseAuth.instance.currentUser!.uid);
    final updatedService = ServiceModel(
      serviceId: serviceId,
      name: nameController.text,
      description: descriptionController.text,
      price: double.parse(priceController.text),
      durationInMinutes: int.parse(durationController.text),
      isAvailable: isAvailable.value,
      category: selectedCategory.value, // Using selected category
      user: user,
    );

    try {
      FullScreenLoader.openLoadingDialogue("Updating Service...", loader);

      // Perform the update operation in Firestore
      await FirebaseFirestore.instance
          .collection('providers')
          .doc(providerId)
          .collection('Services')
          .doc(serviceId)
          .update(updatedService.toJson());

      // Update the local services list
      int index = services.indexWhere((service) => service.serviceId == serviceId);
      if (index != -1) {
        services[index] = updatedService; // Update the service in the local list
      }

      clearForm();
      Get.back();

      Loaders.successSnackBar(
          title: "Success!", message: 'Service updated successfully');
      FullScreenLoader.stopLoading();
    } catch (e) {
      Loaders.errorSnackBar(title: "Error", message: 'Failed to update service: $e');
      FullScreenLoader.stopLoading();
    }
  }


  Future<void> deleteService(BuildContext context, String serviceId, String providerId) async {
    try {
      // Open loading dialog
      FullScreenLoader.openLoadingDialogue("Deleting Service...", loader);

      // Delete the service document from Firestore
      await FirebaseFirestore.instance
          .collection('providers')
          .doc(providerId)
          .collection('Services')
          .doc(serviceId)
          .delete();


      services.removeWhere((service) => service.serviceId == serviceId);
      // Show success message

      Loaders.successSnackBar(title: "Success!", message: 'Service is deleted successfully');
      FullScreenLoader.stopLoading();
      Navigator.of(context).pop();

    } catch (e) {
      // Show error message
      Loaders.errorSnackBar(title: "Error", message: 'Failed to delete service: $e');

      // Stop loading dialog
      FullScreenLoader.stopLoading();
    }
  }

  Future<UserModel> fetchUser(String userId) async {
    try {
      final userSnapshot = await FirebaseFirestore.instance.collection('Users').doc(userId).get();

      if (userSnapshot.exists) {
        print('User data fetched: ${userSnapshot.data()}');
        return UserModel.fromSnapshot(userSnapshot);  // Assuming UserModel.fromSnapshot handles the conversion correctly
      } else {
        print('User document does not exist in Firestore for ID: $userId');
        throw Exception('User not found');
      }
    } catch (e) {
      print('Error fetching user: $e');
      rethrow;  // Rethrow the error to handle it at the calling point
    }
  }

  Future<void> fetchPetCareServices() async {
    try {
      // Fetch all provider IDs from Firestore
      QuerySnapshot providerSnapshot = await FirebaseFirestore.instance
          .collection('providers')
          .get();

      List<ServiceModel> petCareServices = [];

      // Loop through each provider and fetch their services
      for (var providerDoc in providerSnapshot.docs) {
        // Fetch services for each provider
        QuerySnapshot serviceSnapshot = await FirebaseFirestore.instance
            .collection('providers')
            .doc(providerDoc.id)
            .collection('Services')
            .where('Category', isEqualTo: 'Vaccination') // Filter by 'Pet Care'
            .get();

        // Add the services to the petCareServices list
        for (var serviceDoc in serviceSnapshot.docs) {
          ServiceModel service = ServiceModel.fromJson(serviceDoc.data() as Map<String, dynamic>);
          petCareServices.add(service);
        }
      }
      // Update the services list in the controller
      services.value = petCareServices;
    } catch (e) {
      print('Error fetching pet care services: $e');
    }
  }
}






class RoutineCheckupServiceController extends GetxController {
  var services = <ServiceModel>[].obs; // Observable list of services
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  RxBool isAvailable = true.obs;
  var selectedCategory = ''.obs;
  var selectedSubCategory = ''.obs;
  // Controllers for form fields
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  void initializeWithService(ServiceModel service) {
    nameController.text = service.name;
    descriptionController.text = service.description;
    priceController.text = service.price.toString();
    durationController.text = service.durationInMinutes.toString();
    selectedCategory.value = service.category;
    isAvailable.value = service.isAvailable;
  }

  Map<String, List<String>> categorySubCategories = {
    'Pet Care': ['Vaccination', 'Dental Care', 'Routine Checkup', 'Illness and Injuries', 'Pet Sitting', 'Pet Walking', 'Litter Training'],
    'Pet Grooming': ['Bathing', 'Styling', 'Hair Cutting/Deshedding'],
  };

  @override
  void onInit() {
    super.onInit();
    if (categorySubCategories.isNotEmpty) {
      selectedCategory.value =
          categorySubCategories.keys.first; // Set the first category as default
      selectedSubCategory.value =
          categorySubCategories[selectedCategory.value]?.first ?? ''; // Set the first subcategory as default
    }

    fetchRoutineCheckupServices();
  }

  // Fetch services from Firestore
  Future<void> fetchServices(String providerId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('providers')
          .doc(providerId)
          .collection('Services')
          .get();

      // Map Firestore documents to ServiceModel objects and update the services list
      services.value = snapshot.docs
          .map((doc) => ServiceModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching services: $e');
    }
  }

  void clearForm() {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    durationController.clear();
    selectedCategory.value = '';
    selectedSubCategory.value = '';
    isAvailable.value = true;
  }

  // Toggle service availability
  void toggleServiceAvailability(int index) {
    ServiceModel service = services[index];
    service.isAvailable = !service.isAvailable;

    FirebaseFirestore.instance
        .collection('services')
        .doc(service.serviceId)
        .update({'IsAvailable': service.isAvailable}).then((_) {
      services[index] = service; // Update the observable list
      Get.snackbar("Success", "Service availability updated!");
    }).catchError((error) {
      Get.snackbar("Error", "Failed to update availability: $error");
    });
  }

  Future<UserModel> fetchUser(String userId) async {
    try {
      final userSnapshot = await FirebaseFirestore.instance.collection('Users').doc(userId).get();

      if (userSnapshot.exists) {
        print('User data fetched: ${userSnapshot.data()}');
        return UserModel.fromSnapshot(userSnapshot);  // Assuming UserModel.fromSnapshot handles the conversion correctly
      } else {
        print('User document does not exist in Firestore for ID: $userId');
        throw Exception('User not found');
      }
    } catch (e) {
      print('Error fetching user: $e');
      rethrow;  // Rethrow the error to handle it at the calling point
    }
  }

  // Change method name and category filter to Routine Checkup
  Future<void> fetchRoutineCheckupServices() async {
    try {
      // Fetch all provider IDs from Firestore
      QuerySnapshot providerSnapshot = await FirebaseFirestore.instance
          .collection('providers')
          .get();

      List<ServiceModel> routineCheckupServices = [];

      // Loop through each provider and fetch their services
      for (var providerDoc in providerSnapshot.docs) {
        // Fetch services for each provider
        QuerySnapshot serviceSnapshot = await FirebaseFirestore.instance
            .collection('providers')
            .doc(providerDoc.id)
            .collection('Services')
            .where('Category', isEqualTo: 'Routine Checkup') // Filter by 'Routine Checkup'
            .get();

        // Add the services to the routineCheckupServices list
        for (var serviceDoc in serviceSnapshot.docs) {
          ServiceModel service = ServiceModel.fromJson(serviceDoc.data() as Map<String, dynamic>);
          routineCheckupServices.add(service);
        }
      }
      // Update the services list in the controller
      services.value = routineCheckupServices;
    } catch (e) {
      print('Error fetching routine checkup services: $e');
    }
  }
}

class IllnessAndInjuriesServiceController extends GetxController {
  var services = <ServiceModel>[].obs; // Observable list of services
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  RxBool isAvailable = true.obs;
  var selectedCategory = ''.obs;
  var selectedSubCategory = ''.obs;
  // Controllers for form fields
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  void initializeWithService(ServiceModel service) {
    nameController.text = service.name;
    descriptionController.text = service.description;
    priceController.text = service.price.toString();
    durationController.text = service.durationInMinutes.toString();
    selectedCategory.value = service.category;
    isAvailable.value = service.isAvailable;
  }

  Map<String, List<String>> categorySubCategories = {
    'Pet Care': ['Vaccination', 'Dental Care', 'Routine Checkup', 'Illness and Injuries', 'Pet Sitting', 'Pet Walking', 'Litter Training'],
    'Pet Grooming': ['Bathing', 'Styling', 'Hair Cutting/Deshedding'],
  };

  @override
  void onInit() {
    super.onInit();
    if (categorySubCategories.isNotEmpty) {
      selectedCategory.value =
          categorySubCategories.keys.first; // Set the first category as default
      selectedSubCategory.value =
          categorySubCategories[selectedCategory.value]?.first ?? ''; // Set the first subcategory as default
    }

    fetchIllnessAndInjuriesServices();
  }

  // Fetch services from Firestore
  Future<void> fetchServices(String providerId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('providers')
          .doc(providerId)
          .collection('Services')
          .get();

      // Map Firestore documents to ServiceModel objects and update the services list
      services.value = snapshot.docs
          .map((doc) => ServiceModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching services: $e');
    }
  }

  void clearForm() {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    durationController.clear();
    selectedCategory.value = '';
    selectedSubCategory.value = '';
    isAvailable.value = true;
  }

  // Toggle service availability
  void toggleServiceAvailability(int index) {
    ServiceModel service = services[index];
    service.isAvailable = !service.isAvailable;

    FirebaseFirestore.instance
        .collection('services')
        .doc(service.serviceId)
        .update({'IsAvailable': service.isAvailable}).then((_) {
      services[index] = service; // Update the observable list
      Get.snackbar("Success", "Service availability updated!");
    }).catchError((error) {
      Get.snackbar("Error", "Failed to update availability: $error");
    });
  }

  Future<UserModel> fetchUser(String userId) async {
    try {
      final userSnapshot = await FirebaseFirestore.instance.collection('Users').doc(userId).get();

      if (userSnapshot.exists) {
        print('User data fetched: ${userSnapshot.data()}');
        return UserModel.fromSnapshot(userSnapshot);  // Assuming UserModel.fromSnapshot handles the conversion correctly
      } else {
        print('User document does not exist in Firestore for ID: $userId');
        throw Exception('User not found');
      }
    } catch (e) {
      print('Error fetching user: $e');
      rethrow;  // Rethrow the error to handle it at the calling point
    }
  }

  // Change method name and category filter to Illness and Injuries
  Future<void> fetchIllnessAndInjuriesServices() async {
    try {
      // Fetch all provider IDs from Firestore
      QuerySnapshot providerSnapshot = await FirebaseFirestore.instance
          .collection('providers')
          .get();

      List<ServiceModel> illnessAndInjuriesServices = [];

      // Loop through each provider and fetch their services
      for (var providerDoc in providerSnapshot.docs) {
        // Fetch services for each provider
        QuerySnapshot serviceSnapshot = await FirebaseFirestore.instance
            .collection('providers')
            .doc(providerDoc.id)
            .collection('Services')
            .where('Category', isEqualTo: 'Illness and Injuries') // Filter by 'Illness and Injuries'
            .get();

        // Add the services to the illnessAndInjuriesServices list
        for (var serviceDoc in serviceSnapshot.docs) {
          ServiceModel service = ServiceModel.fromJson(serviceDoc.data() as Map<String, dynamic>);
          illnessAndInjuriesServices.add(service);
        }
      }
      // Update the services list in the controller
      services.value = illnessAndInjuriesServices;
    } catch (e) {
      print('Error fetching illness and injuries services: $e');
    }
  }
}
class LitterTrainingServiceController extends GetxController {
  var services = <ServiceModel>[].obs; // Observable list of services
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  RxBool isAvailable = true.obs;
  var selectedCategory = ''.obs;
  var selectedSubCategory = ''.obs;
  // Controllers for form fields
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  void initializeWithService(ServiceModel service) {
    nameController.text = service.name;
    descriptionController.text = service.description;
    priceController.text = service.price.toString();
    durationController.text = service.durationInMinutes.toString();
    selectedCategory.value = service.category;
    isAvailable.value = service.isAvailable;
  }

  Map<String, List<String>> categorySubCategories = {
    'Pet Care': ['Vaccination', 'Dental Care', 'Routine Checkup', 'Illness and Injuries', 'Pet Sitting', 'Pet Walking', 'Litter Training'],
    'Pet Grooming': ['Bathing', 'Styling', 'Hair Cutting/Deshedding'],
  };

  @override
  void onInit() {
    super.onInit();
    if (categorySubCategories.isNotEmpty) {
      selectedCategory.value =
          categorySubCategories.keys.first; // Set the first category as default
      selectedSubCategory.value =
          categorySubCategories[selectedCategory.value]?.first ?? ''; // Set the first subcategory as default
    }

    fetchLitterTrainingServices();
  }

  // Fetch services from Firestore
  Future<void> fetchServices(String providerId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('providers')
          .doc(providerId)
          .collection('Services')
          .get();

      // Map Firestore documents to ServiceModel objects and update the services list
      services.value = snapshot.docs
          .map((doc) => ServiceModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching services: $e');
    }
  }

  void clearForm() {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    durationController.clear();
    selectedCategory.value = '';
    selectedSubCategory.value = '';
    isAvailable.value = true;
  }

  // Toggle service availability
  void toggleServiceAvailability(int index) {
    ServiceModel service = services[index];
    service.isAvailable = !service.isAvailable;

    FirebaseFirestore.instance
        .collection('services')
        .doc(service.serviceId)
        .update({'IsAvailable': service.isAvailable}).then((_) {
      services[index] = service; // Update the observable list
      Get.snackbar("Success", "Service availability updated!");
    }).catchError((error) {
      Get.snackbar("Error", "Failed to update availability: $error");
    });
  }

  Future<UserModel> fetchUser(String userId) async {
    try {
      final userSnapshot = await FirebaseFirestore.instance.collection('Users').doc(userId).get();

      if (userSnapshot.exists) {
        print('User data fetched: ${userSnapshot.data()}');
        return UserModel.fromSnapshot(userSnapshot);  // Assuming UserModel.fromSnapshot handles the conversion correctly
      } else {
        print('User document does not exist in Firestore for ID: $userId');
        throw Exception('User not found');
      }
    } catch (e) {
      print('Error fetching user: $e');
      rethrow;  // Rethrow the error to handle it at the calling point
    }
  }

  // Change method name and category filter to Litter Training
  Future<void> fetchLitterTrainingServices() async {
    try {
      // Fetch all provider IDs from Firestore
      QuerySnapshot providerSnapshot = await FirebaseFirestore.instance
          .collection('providers')
          .get();

      List<ServiceModel> litterTrainingServices = [];

      // Loop through each provider and fetch their services
      for (var providerDoc in providerSnapshot.docs) {
        // Fetch services for each provider
        QuerySnapshot serviceSnapshot = await FirebaseFirestore.instance
            .collection('providers')
            .doc(providerDoc.id)
            .collection('Services')
            // .where('Category', isEqualTo: 'Pet Care') // Assuming the 'Pet Care' category is being used
            .where('Category', isEqualTo: 'Litter Training') // Filter by 'Litter Training' subcategory
            .get();

        // Add the services to the litterTrainingServices list
        for (var serviceDoc in serviceSnapshot.docs) {
          ServiceModel service = ServiceModel.fromJson(serviceDoc.data() as Map<String, dynamic>);
          litterTrainingServices.add(service);
        }
      }
      // Update the services list in the controller
      services.value = litterTrainingServices;
    } catch (e) {
      print('Error fetching litter training services: $e');
    }
  }
}
class PetSittingServiceController extends GetxController {
  var services = <ServiceModel>[].obs; // Observable list of services
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  RxBool isAvailable = true.obs;
  var selectedCategory = ''.obs;
  var selectedSubCategory = ''.obs;
  // Controllers for form fields
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  void initializeWithService(ServiceModel service) {
    nameController.text = service.name;
    descriptionController.text = service.description;
    priceController.text = service.price.toString();
    durationController.text = service.durationInMinutes.toString();
    selectedCategory.value = service.category;
    isAvailable.value = service.isAvailable;
  }

  Map<String, List<String>> categorySubCategories = {
    'Pet Care': ['Vaccination', 'Dental Care', 'Routine Checkup', 'Illness and Injuries', 'Pet Sitting', 'Pet Walking', 'Litter Training'],
    'Pet Grooming': ['Bathing', 'Styling', 'Hair Cutting/Deshedding'],
  };

  @override
  void onInit() {
    super.onInit();
    if (categorySubCategories.isNotEmpty) {
      selectedCategory.value =
          categorySubCategories.keys.first; // Set the first category as default
      selectedSubCategory.value =
          categorySubCategories[selectedCategory.value]?.first ?? ''; // Set the first subcategory as default
    }

    fetchPetSittingServices();
  }

  // Fetch services from Firestore
  Future<void> fetchServices(String providerId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('providers')
          .doc(providerId)
          .collection('Services')
          .get();

      // Map Firestore documents to ServiceModel objects and update the services list
      services.value = snapshot.docs
          .map((doc) => ServiceModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching services: $e');
    }
  }

  void clearForm() {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    durationController.clear();
    selectedCategory.value = '';
    selectedSubCategory.value = '';
    isAvailable.value = true;
  }

  // Toggle service availability
  void toggleServiceAvailability(int index) {
    ServiceModel service = services[index];
    service.isAvailable = !service.isAvailable;

    FirebaseFirestore.instance
        .collection('services')
        .doc(service.serviceId)
        .update({'IsAvailable': service.isAvailable}).then((_) {
      services[index] = service; // Update the observable list
      Get.snackbar("Success", "Service availability updated!");
    }).catchError((error) {
      Get.snackbar("Error", "Failed to update availability: $error");
    });
  }

  Future<UserModel> fetchUser(String userId) async {
    try {
      final userSnapshot = await FirebaseFirestore.instance.collection('Users').doc(userId).get();

      if (userSnapshot.exists) {
        print('User data fetched: ${userSnapshot.data()}');
        return UserModel.fromSnapshot(userSnapshot);  // Assuming UserModel.fromSnapshot handles the conversion correctly
      } else {
        print('User document does not exist in Firestore for ID: $userId');
        throw Exception('User not found');
      }
    } catch (e) {
      print('Error fetching user: $e');
      rethrow;  // Rethrow the error to handle it at the calling point
    }
  }

  // Fetch services specifically for Pet Sitting
  Future<void> fetchPetSittingServices() async {
    try {
      // Fetch all provider IDs from Firestore
      QuerySnapshot providerSnapshot = await FirebaseFirestore.instance
          .collection('providers')
          .get();

      List<ServiceModel> petSittingServices = [];

      // Loop through each provider and fetch their services
      for (var providerDoc in providerSnapshot.docs) {
        // Fetch services for each provider
        QuerySnapshot serviceSnapshot = await FirebaseFirestore.instance
            .collection('providers')
            .doc(providerDoc.id)
            .collection('Services')
            // .where('Category', isEqualTo: 'Pet Care') // Assuming the 'Pet Care' category is being used
            .where('Category', isEqualTo: 'Pet Sitting') // Filter by 'Pet Sitting'
            .get();

        // Add the services to the petSittingServices list
        for (var serviceDoc in serviceSnapshot.docs) {
          ServiceModel service = ServiceModel.fromJson(serviceDoc.data() as Map<String, dynamic>);
          petSittingServices.add(service);
        }
      }
      // Update the services list in the controller
      services.value = petSittingServices;
    } catch (e) {
      print('Error fetching pet sitting services: $e');
    }
  }
}
class PetWalkingServiceController extends GetxController {
  var services = <ServiceModel>[].obs; // Observable list of services
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  RxBool isAvailable = true.obs;
  var selectedCategory = ''.obs;
  var selectedSubCategory = ''.obs;
  // Controllers for form fields
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  void initializeWithService(ServiceModel service) {
    nameController.text = service.name;
    descriptionController.text = service.description;
    priceController.text = service.price.toString();
    durationController.text = service.durationInMinutes.toString();
    selectedCategory.value = service.category;
    isAvailable.value = service.isAvailable;
  }

  Map<String, List<String>> categorySubCategories = {
    'Pet Care': ['Vaccination', 'Dental Care', 'Routine Checkup', 'Illness and Injuries', 'Pet Sitting', 'Pet Walking', 'Litter Training'],
    'Pet Grooming': ['Bathing', 'Styling', 'Hair Cutting/Deshedding'],
  };

  @override
  void onInit() {
    super.onInit();
    if (categorySubCategories.isNotEmpty) {
      selectedCategory.value =
          categorySubCategories.keys.first; // Set the first category as default
      selectedSubCategory.value =
          categorySubCategories[selectedCategory.value]?.first ?? ''; // Set the first subcategory as default
    }

    fetchPetWalkingServices();
  }

  // Fetch services from Firestore
  Future<void> fetchServices(String providerId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('providers')
          .doc(providerId)
          .collection('Services')
          .get();

      // Map Firestore documents to ServiceModel objects and update the services list
      services.value = snapshot.docs
          .map((doc) => ServiceModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching services: $e');
    }
  }

  void clearForm() {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    durationController.clear();
    selectedCategory.value = '';
    selectedSubCategory.value = '';
    isAvailable.value = true;
  }

  // Toggle service availability
  void toggleServiceAvailability(int index) {
    ServiceModel service = services[index];
    service.isAvailable = !service.isAvailable;

    FirebaseFirestore.instance
        .collection('services')
        .doc(service.serviceId)
        .update({'IsAvailable': service.isAvailable}).then((_) {
      services[index] = service; // Update the observable list
      Get.snackbar("Success", "Service availability updated!");
    }).catchError((error) {
      Get.snackbar("Error", "Failed to update availability: $error");
    });
  }

  Future<UserModel> fetchUser(String userId) async {
    try {
      final userSnapshot = await FirebaseFirestore.instance.collection('Users').doc(userId).get();

      if (userSnapshot.exists) {
        print('User data fetched: ${userSnapshot.data()}');
        return UserModel.fromSnapshot(userSnapshot);  // Assuming UserModel.fromSnapshot handles the conversion correctly
      } else {
        print('User document does not exist in Firestore for ID: $userId');
        throw Exception('User not found');
      }
    } catch (e) {
      print('Error fetching user: $e');
      rethrow;  // Rethrow the error to handle it at the calling point
    }
  }

  // Fetch services specifically for Pet Walking
  Future<void> fetchPetWalkingServices() async {
    try {
      // Fetch all provider IDs from Firestore
      QuerySnapshot providerSnapshot = await FirebaseFirestore.instance
          .collection('providers')
          .get();

      List<ServiceModel> petWalkingServices = [];

      // Loop through each provider and fetch their services
      for (var providerDoc in providerSnapshot.docs) {
        // Fetch services for each provider
        QuerySnapshot serviceSnapshot = await FirebaseFirestore.instance
            .collection('providers')
            .doc(providerDoc.id)
            .collection('Services')
            // .where('Category', isEqualTo: 'Pet Care') // Assuming the 'Pet Care' category is being used
            .where('Category', isEqualTo: 'Pet Walking') // Filter by 'Pet Walking'
            .get();

        // Add the services to the petWalkingServices list
        for (var serviceDoc in serviceSnapshot.docs) {
          ServiceModel service = ServiceModel.fromJson(serviceDoc.data() as Map<String, dynamic>);
          petWalkingServices.add(service);
        }
      }
      // Update the services list in the controller
      services.value = petWalkingServices;
    } catch (e) {
      print('Error fetching pet walking services: $e');
    }
  }
}


class DentalCareServiceController extends GetxController {
  var services = <ServiceModel>[].obs; // Observable list of services
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  RxBool isAvailable = true.obs;
  var selectedCategory = ''.obs;
  var selectedSubCategory = ''.obs;
  // Controllers for form fields
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  void initializeWithService(ServiceModel service) {
    nameController.text = service.name;
    descriptionController.text = service.description;
    priceController.text = service.price.toString();
    durationController.text = service.durationInMinutes.toString();
    selectedCategory.value = service.category;
    isAvailable.value = service.isAvailable;
  }

  Map<String, List<String>> categorySubCategories = {
    'Pet Care': ['Vaccination', 'Dental Care', 'Routine Checkup', 'Illness and Injuries', 'Pet Sitting', 'Pet Walking', 'Litter Training'],
    'Pet Grooming': ['Bathing', 'Styling', 'Hair Cutting/Deshedding'],
  };

  @override
  void onInit() {
    super.onInit();
    if (categorySubCategories.isNotEmpty) {
      selectedCategory.value =
          categorySubCategories.keys.first; // Set the first category as default
      selectedSubCategory.value =
          categorySubCategories[selectedCategory.value]?.first ?? ''; // Set the first subcategory as default
    }

    fetchDentalCareServices();
  }

  // Fetch services from Firestore
  Future<void> fetchServices(String providerId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('providers')
          .doc(providerId)
          .collection('Services')
          .get();

      // Map Firestore documents to ServiceModel objects and update the services list
      services.value = snapshot.docs
          .map((doc) => ServiceModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching services: $e');
    }
  }

  void clearForm() {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    durationController.clear();
    selectedCategory.value = '';
    selectedSubCategory.value = '';
    isAvailable.value = true;
  }

  // Toggle service availability
  void toggleServiceAvailability(int index) {
    ServiceModel service = services[index];
    service.isAvailable = !service.isAvailable;

    FirebaseFirestore.instance
        .collection('services')
        .doc(service.serviceId)
        .update({'IsAvailable': service.isAvailable}).then((_) {
      services[index] = service; // Update the observable list
      Get.snackbar("Success", "Service availability updated!");
    }).catchError((error) {
      Get.snackbar("Error", "Failed to update availability: $error");
    });
  }

  Future<UserModel> fetchUser(String userId) async {
    try {
      final userSnapshot = await FirebaseFirestore.instance.collection('Users').doc(userId).get();

      if (userSnapshot.exists) {
        print('User data fetched: ${userSnapshot.data()}');
        return UserModel.fromSnapshot(userSnapshot);  // Assuming UserModel.fromSnapshot handles the conversion correctly
      } else {
        print('User document does not exist in Firestore for ID: $userId');
        throw Exception('User not found');
      }
    } catch (e) {
      print('Error fetching user: $e');
      rethrow;  // Rethrow the error to handle it at the calling point
    }
  }

  // Fetch services specifically for Dental Care
  Future<void> fetchDentalCareServices() async {
    try {
      // Fetch all provider IDs from Firestore
      QuerySnapshot providerSnapshot = await FirebaseFirestore.instance
          .collection('providers')
          .get();

      List<ServiceModel> dentalCareServices = [];

      // Loop through each provider and fetch their services
      for (var providerDoc in providerSnapshot.docs) {
        // Fetch services for each provider
        QuerySnapshot serviceSnapshot = await FirebaseFirestore.instance
            .collection('providers')
            .doc(providerDoc.id)
            .collection('Services')
            // .where('Category', isEqualTo: 'Pet Care') // Assuming the 'Pet Care' category is being used
            .where('Category', isEqualTo: 'Dental Care') // Filter by 'Dental Care'
            .get();

        // Add the services to the dentalCareServices list
        for (var serviceDoc in serviceSnapshot.docs) {
          ServiceModel service = ServiceModel.fromJson(serviceDoc.data() as Map<String, dynamic>);
          dentalCareServices.add(service);
        }
      }
      // Update the services list in the controller
      services.value = dentalCareServices;
    } catch (e) {
      print('Error fetching dental care services: $e');
    }
  }
}




class BathingServiceController extends GetxController {
  var services = <ServiceModel>[].obs; // Observable list of services
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  RxBool isAvailable = true.obs;
  var selectedCategory = ''.obs;
  var selectedSubCategory = ''.obs;
  // Controllers for form fields
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  void initializeWithService(ServiceModel service) {
    nameController.text = service.name;
    descriptionController.text = service.description;
    priceController.text = service.price.toString();
    durationController.text = service.durationInMinutes.toString();
    selectedCategory.value = service.category;
    isAvailable.value = service.isAvailable;
  }

  Map<String, List<String>> categorySubCategories = {
    'Pet Care': ['Vaccination', 'Dental Care', 'Routine Checkup', 'Illness and Injuries', 'Pet Sitting', 'Pet Walking', 'Litter Training'],
    'Pet Grooming': ['Bathing', 'Styling', 'Hair Cutting/Deshedding'],
  };

  @override
  void onInit() {
    super.onInit();
    if (categorySubCategories.isNotEmpty) {
      selectedCategory.value =
          categorySubCategories.keys.first; // Set the first category as default
      selectedSubCategory.value =
          categorySubCategories[selectedCategory.value]?.first ?? ''; // Set the first subcategory as default
    }

    fetchBathingServices();
  }

  // Fetch services from Firestore
  Future<void> fetchServices(String providerId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('providers')
          .doc(providerId)
          .collection('Services')
          .get();

      // Map Firestore documents to ServiceModel objects and update the services list
      services.value = snapshot.docs
          .map((doc) => ServiceModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching services: $e');
    }
  }

  void clearForm() {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    durationController.clear();
    selectedCategory.value = '';
    selectedSubCategory.value = '';
    isAvailable.value = true;
  }

  // Toggle service availability
  void toggleServiceAvailability(int index) {
    ServiceModel service = services[index];
    service.isAvailable = !service.isAvailable;

    FirebaseFirestore.instance
        .collection('services')
        .doc(service.serviceId)
        .update({'IsAvailable': service.isAvailable}).then((_) {
      services[index] = service; // Update the observable list
      Get.snackbar("Success", "Service availability updated!");
    }).catchError((error) {
      Get.snackbar("Error", "Failed to update availability: $error");
    });
  }

  Future<UserModel> fetchUser(String userId) async {
    try {
      final userSnapshot = await FirebaseFirestore.instance.collection('Users').doc(userId).get();

      if (userSnapshot.exists) {
        print('User data fetched: ${userSnapshot.data()}');
        return UserModel.fromSnapshot(userSnapshot);  // Assuming UserModel.fromSnapshot handles the conversion correctly
      } else {
        print('User document does not exist in Firestore for ID: $userId');
        throw Exception('User not found');
      }
    } catch (e) {
      print('Error fetching user: $e');
      rethrow;  // Rethrow the error to handle it at the calling point
    }
  }

  // Fetch services specifically for Bathing
  Future<void> fetchBathingServices() async {
    try {
      // Fetch all provider IDs from Firestore
      QuerySnapshot providerSnapshot = await FirebaseFirestore.instance
          .collection('providers')
          .get();

      List<ServiceModel> bathingServices = [];

      // Loop through each provider and fetch their services
      for (var providerDoc in providerSnapshot.docs) {
        // Fetch services for each provider
        QuerySnapshot serviceSnapshot = await FirebaseFirestore.instance
            .collection('providers')
            .doc(providerDoc.id)
            .collection('Services')
            // .where('Category', isEqualTo: 'Pet Grooming') // Assuming the 'Pet Grooming' category is being used
            .where('Category', isEqualTo: 'Bathing') // Filter by 'Bathing'
            .get();

        // Add the services to the bathingServices list
        for (var serviceDoc in serviceSnapshot.docs) {
          ServiceModel service = ServiceModel.fromJson(serviceDoc.data() as Map<String, dynamic>);
          bathingServices.add(service);
        }
      }
      // Update the services list in the controller
      services.value = bathingServices;
    } catch (e) {
      print('Error fetching bathing services: $e');
    }
  }
}
class HairCuttingDesheddingServiceController extends GetxController {
  var services = <ServiceModel>[].obs; // Observable list of services
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  RxBool isAvailable = true.obs;
  var selectedCategory = ''.obs;
  var selectedSubCategory = ''.obs;
  // Controllers for form fields
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  void initializeWithService(ServiceModel service) {
    nameController.text = service.name;
    descriptionController.text = service.description;
    priceController.text = service.price.toString();
    durationController.text = service.durationInMinutes.toString();
    selectedCategory.value = service.category;
    isAvailable.value = service.isAvailable;
  }

  Map<String, List<String>> categorySubCategories = {
    'Pet Care': ['Vaccination', 'Routine Checkup', 'Illness and Injuries', 'Pet Sitting', 'Pet Walking', 'Litter Training'],
    'Pet Grooming': ['Bathing', 'Styling', 'Hair Cutting/Deshedding'],
  };

  @override
  void onInit() {
    super.onInit();
    if (categorySubCategories.isNotEmpty) {
      selectedCategory.value =
          categorySubCategories.keys.first; // Set the first category as default
      selectedSubCategory.value =
          categorySubCategories[selectedCategory.value]?.first ?? ''; // Set the first subcategory as default
    }

    fetchHairCuttingDesheddingServices();
  }

  // Fetch services from Firestore
  Future<void> fetchServices(String providerId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('providers')
          .doc(providerId)
          .collection('Services')
          .get();

      // Map Firestore documents to ServiceModel objects and update the services list
      services.value = snapshot.docs
          .map((doc) => ServiceModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching services: $e');
    }
  }

  void clearForm() {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    durationController.clear();
    selectedCategory.value = '';
    selectedSubCategory.value = '';
    isAvailable.value = true;
  }

  // Toggle service availability
  void toggleServiceAvailability(int index) {
    ServiceModel service = services[index];
    service.isAvailable = !service.isAvailable;

    FirebaseFirestore.instance
        .collection('services')
        .doc(service.serviceId)
        .update({'IsAvailable': service.isAvailable}).then((_) {
      services[index] = service; // Update the observable list
      Get.snackbar("Success", "Service availability updated!");
    }).catchError((error) {
      Get.snackbar("Error", "Failed to update availability: $error");
    });
  }

  Future<UserModel> fetchUser(String userId) async {
    try {
      final userSnapshot = await FirebaseFirestore.instance.collection('Users').doc(userId).get();

      if (userSnapshot.exists) {
        print('User data fetched: ${userSnapshot.data()}');
        return UserModel.fromSnapshot(userSnapshot);  // Assuming UserModel.fromSnapshot handles the conversion correctly
      } else {
        print('User document does not exist in Firestore for ID: $userId');
        throw Exception('User not found');
      }
    } catch (e) {
      print('Error fetching user: $e');
      rethrow;  // Rethrow the error to handle it at the calling point
    }
  }

  // Fetch services specifically for Hair Cutting/Deshedding
  Future<void> fetchHairCuttingDesheddingServices() async {
    try {
      // Fetch all provider IDs from Firestore
      QuerySnapshot providerSnapshot = await FirebaseFirestore.instance
          .collection('providers')
          .get();

      List<ServiceModel> hairCuttingDesheddingServices = [];

      // Loop through each provider and fetch their services
      for (var providerDoc in providerSnapshot.docs) {
        // Fetch services for each provider
        QuerySnapshot serviceSnapshot = await FirebaseFirestore.instance
            .collection('providers')
            .doc(providerDoc.id)
            .collection('Services')
            // .where('Category', isEqualTo: 'Pet Grooming') // Filter by 'Pet Grooming'
            .where('Category', isEqualTo: 'Hair Cutting/Deshedding') // Filter by 'Hair Cutting/Deshedding'
            .get();

        // Add the services to the hairCuttingDesheddingServices list
        for (var serviceDoc in serviceSnapshot.docs) {
          ServiceModel service = ServiceModel.fromJson(serviceDoc.data() as Map<String, dynamic>);
          hairCuttingDesheddingServices.add(service);
        }
      }
      // Update the services list in the controller
      services.value = hairCuttingDesheddingServices;
    } catch (e) {
      print('Error fetching hair cutting/deshedding services: $e');
    }
  }
}
class StylingServiceController extends GetxController {
  var services = <ServiceModel>[].obs; // Observable list of services
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  RxBool isAvailable = true.obs;
  var selectedCategory = ''.obs;
  var selectedSubCategory = ''.obs;
  // Controllers for form fields
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  void initializeWithService(ServiceModel service) {
    nameController.text = service.name;
    descriptionController.text = service.description;
    priceController.text = service.price.toString();
    durationController.text = service.durationInMinutes.toString();
    selectedCategory.value = service.category;
    isAvailable.value = service.isAvailable;
  }

  Map<String, List<String>> categorySubCategories = {
    'Pet Care': ['Vaccination', 'Routine Checkup', 'Illness and Injuries', 'Pet Sitting', 'Pet Walking', 'Litter Training'],
    'Pet Grooming': ['Bathing', 'Styling', 'Hair Cutting/Deshedding'],
  };

  @override
  void onInit() {
    super.onInit();
    if (categorySubCategories.isNotEmpty) {
      selectedCategory.value =
          categorySubCategories.keys.first; // Set the first category as default
      selectedSubCategory.value =
          categorySubCategories[selectedCategory.value]?.first ?? ''; // Set the first subcategory as default
    }

    fetchStylingServices();
  }

  // Fetch services from Firestore
  Future<void> fetchServices(String providerId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('providers')
          .doc(providerId)
          .collection('Services')
          .get();

      // Map Firestore documents to ServiceModel objects and update the services list
      services.value = snapshot.docs
          .map((doc) => ServiceModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching services: $e');
    }
  }

  void clearForm() {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    durationController.clear();
    selectedCategory.value = '';
    selectedSubCategory.value = '';
    isAvailable.value = true;
  }

  // Toggle service availability
  void toggleServiceAvailability(int index) {
    ServiceModel service = services[index];
    service.isAvailable = !service.isAvailable;

    FirebaseFirestore.instance
        .collection('services')
        .doc(service.serviceId)
        .update({'IsAvailable': service.isAvailable}).then((_) {
      services[index] = service; // Update the observable list
      Get.snackbar("Success", "Service availability updated!");
    }).catchError((error) {
      Get.snackbar("Error", "Failed to update availability: $error");
    });
  }

  Future<UserModel> fetchUser(String userId) async {
    try {
      final userSnapshot = await FirebaseFirestore.instance.collection('Users').doc(userId).get();

      if (userSnapshot.exists) {
        print('User data fetched: ${userSnapshot.data()}');
        return UserModel.fromSnapshot(userSnapshot);  // Assuming UserModel.fromSnapshot handles the conversion correctly
      } else {
        print('User document does not exist in Firestore for ID: $userId');
        throw Exception('User not found');
      }
    } catch (e) {
      print('Error fetching user: $e');
      rethrow;  // Rethrow the error to handle it at the calling point
    }
  }

  // Fetch services specifically for Styling
  Future<void> fetchStylingServices() async {
    try {
      // Fetch all provider IDs from Firestore
      QuerySnapshot providerSnapshot = await FirebaseFirestore.instance
          .collection('providers')
          .get();

      List<ServiceModel> stylingServices = [];

      // Loop through each provider and fetch their services
      for (var providerDoc in providerSnapshot.docs) {
        // Fetch services for each provider
        QuerySnapshot serviceSnapshot = await FirebaseFirestore.instance
            .collection('providers')
            .doc(providerDoc.id)
            .collection('Services')
            // .where('Category', isEqualTo: 'Pet Grooming') /// Filter by 'Pet Grooming'
            .where('Category', isEqualTo: 'Styling') // Filter by 'Styling'
            .get();

        // Add the services to the stylingServices list
        for (var serviceDoc in serviceSnapshot.docs) {
          ServiceModel service = ServiceModel.fromJson(serviceDoc.data() as Map<String, dynamic>);
          stylingServices.add(service);
        }
      }
      // Update the services list in the controller
      services.value = stylingServices;
    } catch (e) {
      print('Error fetching styling services: $e');
    }
  }
}
