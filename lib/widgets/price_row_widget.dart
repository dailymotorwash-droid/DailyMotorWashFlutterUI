import 'package:flutter/cupertino.dart';

class PriceRowWidget extends StatefulWidget {

  final String title, value;
  final bool isBold;
  const PriceRowWidget({
    super.key,
    required this.title ,
    required this.value,
    this.isBold = false,
  });

  @override
  State<PriceRowWidget> createState() => _PriceRowWidgetState();
}

class _PriceRowWidgetState extends State<PriceRowWidget> {

  late String title,value;
  late bool isBold;

  @override
  void initState() {
    // TODO: implement initState
    title = widget.title;
    value = widget.value;
    isBold = widget.isBold;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return priceRow();
  }

  Widget priceRow() {

    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}


