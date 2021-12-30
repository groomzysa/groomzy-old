import 'package:groomzy/model/service_provider_category.dart';

class Category {
  final int id;
  final String category;
  final List<ServiceProviderCategory?>? serviceProviderCategory;

  Category({
    required this.id,
    required this.category,
    this.serviceProviderCategory
  });
}
