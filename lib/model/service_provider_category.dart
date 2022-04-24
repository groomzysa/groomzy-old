import 'package:groomzy/model/category.dart';
import 'package:groomzy/model/provider.dart';
import 'package:groomzy/model/service.dart';

class ServiceProviderCategory {
  final Service? service;
  final Provider? provider;
  final Category? category;

  ServiceProviderCategory({
    this.provider,
    this.category,
    this.service,
  });
}
