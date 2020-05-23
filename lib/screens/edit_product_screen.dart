import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/product_provider.dart';
import 'package:shopapp/providers/products_providers.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _product = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
    isFavorite: false,
  );
  var _isInit = false;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      final String productId = ModalRoute.of(context).settings.arguments;
      if (productId != null) {
        _product = Provider.of<Products>(context).findById(productId);
        _imageUrlController.text = _product.imageUrl;
      }
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) return;
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    final products = Provider.of<Products>(context, listen: false);
    var productFunction = _product.id == null
        ? products.addProduct(_product)
        : products.updateProduct(_product.id, _product);
    try {
      await productFunction;
      Navigator.of(context).pop();
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('An error occurred!'),
          content: Text('Something went wrong!'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      initialValue: _product.title,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _product = Product(
                          title: value,
                          id: _product.id,
                          description: _product.description,
                          imageUrl: _product.imageUrl,
                          price: _product.price,
                          isFavorite: _product.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      initialValue: _product.price.toString(),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _product = Product(
                          title: _product.title,
                          id: _product.id,
                          description: _product.description,
                          imageUrl: _product.imageUrl,
                          price: double.parse(value),
                          isFavorite: _product.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater then zero';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      initialValue: _product.description,
                      onSaved: (value) {
                        _product = Product(
                          title: _product.title,
                          id: _product.id,
                          description: value,
                          imageUrl: _product.imageUrl,
                          price: _product.price,
                          isFavorite: _product.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? const Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Image URL',
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) => _saveForm(),
                            onSaved: (value) {
                              _product = Product(
                                title: _product.title,
                                id: _product.id,
                                description: _product.description,
                                imageUrl: value,
                                price: _product.price,
                                isFavorite: _product.isFavorite,
                              );
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter an image URL';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: _saveForm,
                          child: const Text('Save'),
                          color: Theme.of(context).primaryColor,
                          textColor: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              .color,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
