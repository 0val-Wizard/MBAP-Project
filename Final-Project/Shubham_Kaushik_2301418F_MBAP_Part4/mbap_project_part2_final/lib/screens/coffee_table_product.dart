// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mbap_project_part2/widgets/search_feature.dart';

class CoffeeTableProduct extends StatelessWidget {
  static String routeName = '/coffee-table';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            expandedHeight: 300.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Coffee Table'),
              background: Image.asset(
                'images/Coffee_Table.png', // this is the path to our image file
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Coffee Table',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$35',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Ancquinn',
                        style: TextStyle(fontSize: 16),
                      ),
                      Spacer(),
                      Icon(Icons.chat_bubble_outline),
                      SizedBox(width: 4),
                      Text('5'),
                      SizedBox(width: 4),
                      Icon(Icons.favorite_border),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Row was created for both the listing of the product details and Bidding Price feature, side-by-side
                  //Used SizedBox(), for good spacing 
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      // Listing the product details
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Details',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Conditions:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18, 
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Brand New',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Brand:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18, 
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'IKEA',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Listed:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18, 
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '2 Days ago by Ancquinn',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Deal Method:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18, 
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(FontAwesomeIcons.vanShuttle),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  'Delivery',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(FontAwesomeIcons.person),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  'Self Pick-up',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Bidding Price feature
                      Column(
                        children: [
                          Container(
                            width: 180,
                            height: 150,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 2),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // onPressed --> something will happen
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 83, 250, 231),),
                                  ), 
                                  child: Text(
                                    'Bid Price',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color.fromARGB(255, 125, 125, 125)),
                                    ),                                     
                                ),
                                SizedBox(height: 10),
                                SearchFeature(
                                  width: 150, 
                                  height: 40, 
                                  backgroundColor: Colors.white, 
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                ],
              ),
            ),
          ),
        ],
      ),

      // This bottomNavigationBar is different it for the purposes of liking the product, adding the product to cart and directing purchasing it with the "Buy" button
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 208, 208, 208).withOpacity(0.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(Icons.favorite_border),
            ElevatedButton(
              onPressed: () {
                // onPressed --> something will happen 
              },
              child: Text(
                'Added to Cart',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // OnPressed --> something will happen
              },
              child: Text(
                'Buy',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
