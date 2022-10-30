import 'package:flutter/material.dart';
import 'package:e_commerce_app/controllers/database_controller.dart';
import 'package:e_commerce_app/models/delivery_method.dart';
import 'package:e_commerce_app/views/widgets/main_button.dart';
import 'package:provider/provider.dart';

import 'checkout_order_details.dart';
import 'delivery_method_item.dart';
import 'payment_component.dart';
import 'shipping_address_component.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final database = Provider.of<Database>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Shipping address',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 8.0),
              ShippingAddressComponent(),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Payment',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Text(
                      'Change',
                      style: Theme.of(context).textTheme.button!.copyWith(
                            color: Colors.redAccent,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              PaymentComponent(),
              const SizedBox(height: 24.0),
              Text(
                'Delivery method',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 8.0),
              StreamBuilder<List<DeliveryMethod>>(
                  stream: database.deliveryMethodsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      final deliveryMethods = snapshot.data;
                      if (deliveryMethods == null || deliveryMethods.isEmpty) {
                        return const Center(
                          child: Text('No delivery methods available!'),
                        );
                      }
                      return SizedBox(
                        height: size.height * 0.13,
                        child: ListView.builder(
                          itemCount: deliveryMethods.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (_, i) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DeliveryMethodItem(
                                deliveryMethod: deliveryMethods[i]),
                          ),
                        ),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }),
              const SizedBox(height: 32.0),
              CheckoutOrderDetails(),
              const SizedBox(height: 64.0),
              MainButton(
                text: 'Submit Order',
                onTap: () {},
                hasCircularBorder: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}