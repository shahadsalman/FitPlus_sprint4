import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OfferDialog extends StatefulWidget {
  final TextEditingController? nameController;
  final TextEditingController? priceController;
  final VoidCallback? onTap;
  final int? selectedPlan;
  final List<Widget>? children;
  final bool isUpdate;

  const OfferDialog({super.key, this.nameController, this.priceController, this.onTap, this.children, this.isUpdate = false, this.selectedPlan});

  @override
  State<OfferDialog> createState() => _OfferDialogState();
}

class _OfferDialogState extends State<OfferDialog> {
  final _formKey = GlobalKey<FormState>();
  bool isButtonTapped = false;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Text(
                widget.isUpdate ? "Update offer" : "Add offer",
                style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 15),
              // Row(
              //   children: List.generate(
              //     AppController.to.loginMap['price'].length,
              //     (index) => Text(AppController.to.loginMap['price'].name),
              //   ),
              // ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                spacing: 8.0,
                // runSpacing: .0,
                children: widget.children!,
              ),
              if (isButtonTapped && widget.selectedPlan == null)
                const Row(
                  children: [
                    SizedBox(width: 20),
                    Text(
                      "Please select the month",
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter offer title';
                    }
                    return null;
                  },
                  controller: widget.nameController,
                  style: const TextStyle(color: Colors.black, fontSize: 17),
                  decoration: InputDecoration(
                      // fillColor: Color.fromARGB(255, 210, 202, 221),
                      isDense: true,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 123, 108, 108),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      hintText: "Offer",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter offer price';
                    } else if (int.parse(value) < 1) {
                      return "Subscription Price should be more than 0";
                    }
                    return null;
                  },
                  controller: widget.priceController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [LengthLimitingTextInputFormatter(4), FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(color: Colors.black, fontSize: 17),
                  decoration: InputDecoration(
                      // fillColor: Color.fromARGB(255, 210, 202, 221),
                      isDense: true,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 123, 108, 108),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      hintText: "Price",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(right: 10.0, bottom: 10),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      isButtonTapped = true;
                      setState(() {});
                      if (_formKey.currentState!.validate() && widget.selectedPlan != null) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                        widget.onTap!();
                      }
                    },
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all<double>(10),
                        backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 210, 202, 221)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(widget.isUpdate ? "Update" : "Add"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Please select the month
//Please enter offer title
//Please enter offers’ price
