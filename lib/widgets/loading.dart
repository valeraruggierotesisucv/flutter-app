import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
                      height: MediaQuery.of(context).size.height - 200, // Adjust this value as needed
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
  }
}