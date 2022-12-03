// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_with_todolist/models/cat_fact_model.dart';

final httpClientProvider = Provider<Dio>(
  (ref) {
    return Dio(BaseOptions(baseUrl: 'https://catfact.ninja/'));
  },
);

final catFactsProvider = FutureProvider.autoDispose.family<List<CatFactModel>, Map<String, dynamic>>(
  (ref, parameterMap) async {
    ref.keepAlive();
    final _dio = ref.watch(httpClientProvider);
    final result = await _dio.get('/facts', queryParameters: parameterMap);
    List<Map<String, dynamic>> _mapData = List.from(result.data['data']);
    List<CatFactModel> _catfactList = _mapData.map((catFact) => CatFactModel.fromMap(catFact)).toList();
    return _catfactList;
  },
);

class FutureProviderExample extends ConsumerWidget {
  const FutureProviderExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var catList = ref.watch(catFactsProvider(const {'limit': '10', 'max_length': '50'}));
    return Scaffold(
      body: SafeArea(
          child: catList.when(
        data: (list) {
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(list[index].fact),
              );
            },
          );
        },
        error: (error, stackTrace) => Center(child: Text('Hata çıktı $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      )),
    );
  }
}
