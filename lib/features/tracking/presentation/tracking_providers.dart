import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/tracking_repository.dart';

final trackingRepositoryProvider = Provider<TrackingRepository>((_) => TrackingRepository());

// Today's water in ml
final todayWaterProvider = FutureProvider<int>((ref) async {
  return ref.read(trackingRepositoryProvider).getTodayWaterMl();
});

// Today's protein in g
final todayProteinProvider = FutureProvider<double>((ref) async {
  return ref.read(trackingRepositoryProvider).getTodayProteinG();
});

// Latest weight
final latestWeightProvider = FutureProvider<double?>((ref) async {
  return ref.read(trackingRepositoryProvider).getLatestWeight();
});
