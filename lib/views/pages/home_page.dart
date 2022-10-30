import 'package:e_commerce_app/controllers/database_controller.dart';
import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/utilites/assets.dart';
import 'package:e_commerce_app/views/widgets/header_of_list.dart';
import 'package:e_commerce_app/views/widgets/list_item_home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final database = Provider.of<Database>(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Image.network(
                AppAssets.topBannerHomePageAsset,
                width: double.infinity,
                height: size.height * .3,
                fit: BoxFit.cover,
              ),
              Opacity(
                opacity: .3,
                child: Container(
                  height: size.height * .3,
                  width: double.infinity,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Text(
                  'Street Clothes',
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const HeaderOfList(
                    title: 'Sale', description: 'Super Summer Sale!'),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 300,
                  child: StreamBuilder<List<Product>>(
                      stream: database.salesProductsStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          final products = snapshot.data;
                          if (products == null || products.isEmpty) {
                            return const Center(
                              child: Text('No Data Available! '),
                            );
                          }
                          return ListView(
                            scrollDirection: Axis.horizontal,
                            children: products
                                .map((e) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListItemHome(
                                          product: e,
                                          isNew: (e.discountValue == 0)
                                              ? true
                                              : false),
                                    ))
                                .toList(),
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
                ),
                const SizedBox(
                  height: 15,
                ),
                const HeaderOfList(
                    title: 'New', description: 'Super New Products!'),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 300,
                  child: StreamBuilder<List<Product>>(
                      stream: database.newProductsStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          final products = snapshot.data;
                          if (products == null || products.isEmpty) {
                            return const Center(
                              child: Text('No Data Available! '),
                            );
                          }
                          return ListView(
                            scrollDirection: Axis.horizontal,
                            children: products
                                .map((e) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListItemHome(
                                        product: e,
                                        isNew: (e.discountValue == 0)
                                            ? true
                                            : false,
                                      ),
                                    ))
                                .toList(),
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
