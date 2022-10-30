import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../../controllers/database_controller.dart';
import '../../models/product.dart';
import '../../utilites/routes.dart';

class ListItemHome extends StatefulWidget {
  final Product product;
  final bool isNew;
  final VoidCallback? addToFavorites;
  bool isFavorite;

  ListItemHome({
    Key? key,
    required this.product,
    required this.isNew,
    this.addToFavorites,
    this.isFavorite = false,
  }) : super(key: key);

  @override
  State<ListItemHome> createState() => _ListItemHomeState();
}

class _ListItemHomeState extends State<ListItemHome> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final database = Provider.of<Database>(context);
    return Stack(
      children: [
        InkWell(
          onTap: () => Navigator.of(context, rootNavigator: true).pushNamed(
            AppRoutes.productDetailsPageRoute,
            arguments: {
              'product': widget.product,
              'database': database,
            },
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  widget.product.imgUrl,
                  width: 190,
                  height: 190,
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 50,
                  height: 25,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: widget.isNew ? Colors.black : Colors.red,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Center(
                        child: Text(
                          widget.isNew
                              ? 'NEW'
                              : '-${widget.product.discountValue}%',
                          style: Theme.of(context).textTheme.caption!.copyWith(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: size.width * 0.36,
          bottom: size.height * 0.12,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  color: Colors.grey,
                  spreadRadius: 2,
                )
              ],
            ),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20.0,
              child: InkWell(
                onTap: () {
                  setState(() {
                    widget.isFavorite = !widget.isFavorite;
                  });
                },
                child: Icon(
                  widget.isFavorite ? Icons.favorite : Icons.favorite_outline,
                  size: 20.0,
                  color: widget.isFavorite ? Colors.red : Colors.grey,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  RatingBarIndicator(
                    itemSize: 25.0,
                    rating: widget.product.rate?.toDouble() ?? 4.0,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    direction: Axis.horizontal,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    '(100)',
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                widget.product.category,
                style: Theme.of(context).textTheme.caption!.copyWith(
                      color: Colors.grey,
                    ),
              ),
              const SizedBox(height: 6.0),
              Text(
                widget.product.title,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 6.0),
              widget.isNew
                  ? Text(
                      '${widget.product.price}\$',
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: Colors.grey,
                          ),
                    )
                  : Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${widget.product.price}\$  ',
                            style:
                                Theme.of(context).textTheme.subtitle2!.copyWith(
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                          ),
                          TextSpan(
                            text:
                                '  ${widget.product.price * (widget.product.discountValue) / 100}\$',
                            style:
                                Theme.of(context).textTheme.subtitle2!.copyWith(
                                      color: Colors.red,
                                    ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        )
      ],
    );
  }
}
