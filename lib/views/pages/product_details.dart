import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/views/widgets/drop_down_menu.dart';
import 'package:e_commerce_app/views/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/database_controller.dart';
import '../../models/add_to_cart_model.dart';
import '../../utilites/constants.dart';
import '../widgets/main_dialog.dart';

class ProductDetails extends StatefulWidget {
  final Product product;

  const ProductDetails({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool isFavorite = false;

  late String dropdownValue;

  Future<void> _addToCart(Database database) async {
    try {
      final addToCartProduct = AddToCartModel(
        id: documentIdFromLocalData(),
        title: widget.product.title,
        price: widget.product.price,
        productId: widget.product.id,
        imgUrl: widget.product.imgUrl,
        size: dropdownValue,
      );
      await database.addToCart(addToCartProduct);
    } catch (e) {
      return MainDialog(
        context: context,
        title: 'Error',
        content: 'Couldn\'t adding to the cart, please try again!',
      ).showAlertDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
     final database = Provider.of<Database>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.product.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.share))],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Image.network(widget.product.imgUrl,
              width: size.width,
              height: size.height * .55,
              alignment: Alignment.center,
              fit: BoxFit.cover),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: SizedBox(
                            height: 60,
                            child: DropDownMenuComponent(
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
                                  });
                                },
                                items: const ['S', 'M', 'L', 'XL', 'XXL'],
                                hint: 'size'))),
                    const Spacer(),
                    InkWell(
                      borderRadius: BorderRadius.circular(360),
                      onTap: () {
                        setState(() {
                          isFavorite = !isFavorite;
                        });
                      },
                      child: SizedBox(
                        height: 55,
                        width: 55,
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border_outlined,
                              color: isFavorite ? Colors.red : Colors.black45,
                              size: 27,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.product.title,
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "\$${widget.product.price}",
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ]),
                const SizedBox(
                  height: 8,
                ),
                Text(widget.product.category,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(color: Colors.grey)),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'this is dummy screpchions we will add it later, i just add this to be more than 1 line do you compare with me or not, i will add more to this mother fucker  ',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(
                  height: 24,
                ),
                MainButton(
                  text: 'Add to cart',
                  onTap: () => _addToCart(database),
                  hasCircularBorder: true,
                ),
                const SizedBox(
                  height: 32,
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}
