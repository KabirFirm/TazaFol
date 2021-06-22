import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildCategoryIcon(Icons.ac_unit, 'মোরগ'),
            _buildCategoryIcon(Icons.ac_unit, 'মোরগ'),
            _buildCategoryIcon(Icons.ac_unit, 'মোরগ'),
            _buildCategoryIcon(Icons.ac_unit, 'মোরগ'),
            _buildCategoryIcon(Icons.ac_unit, 'মোরগ'),
            _buildCategoryIcon(Icons.ac_unit, 'মোরগ'),
            _buildCategoryIcon(Icons.ac_unit, 'মোরগ'),
            _buildCategoryIcon(Icons.ac_unit, 'মোরগ'),
          ],
        ),
        Container(
          height: 10.0,
          color: Colors.indigo,
        ),
        Expanded(
          child: SizedBox(
            height: 200.0,
            child: Scrollbar(
              child: ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  Card(
                    elevation: 2.0,
                    color: Colors.indigo[50],
                    child: ListTile(
                      leading: CircleAvatar(),
                    title: Text('পাহাড়ি মোরগ - ৫০০ টাকা/কেজি'),
                    subtitle: Text('খাগড়াছড়ী থেকে আনা হয়েছে'),
                    trailing: Icon(Icons.add_shopping_cart),
                    ),
                  ),
                  Card(
                    elevation: 2.0,
                    color: Colors.indigo[50],
                    child: ListTile(
                      leading: CircleAvatar(),
                    title: Text('Hello Title'),
                    subtitle: Text('subtitle'),
                    trailing: Icon(Icons.add_shopping_cart),
                    ),
                  ),
                  Card(
                    elevation: 2.0,
                    color: Colors.indigo[50],
                    child: ListTile(
                      leading: CircleAvatar(),
                    title: Text('Hello Title'),
                    subtitle: Text('subtitle'),
                    trailing: Icon(Icons.add_shopping_cart),
                    ),
                  ),
                  Card(
                    elevation: 2.0,
                    color: Colors.indigo[50],
                    child: ListTile(
                      leading: CircleAvatar(),
                    title: Text('Hello Title'),
                    subtitle: Text('subtitle'),
                    trailing: Icon(Icons.add_shopping_cart),
                    ),
                  ),
                  Card(
                    elevation: 2.0,
                    color: Colors.indigo[50],
                    child: ListTile(
                      leading: CircleAvatar(),
                    title: Text('Hello Title'),
                    subtitle: Text('subtitle'),
                    trailing: Icon(Icons.add_shopping_cart),
                    ),
                  ),
                  Card(
                    elevation: 2.0,
                    color: Colors.indigo[50],
                    child: ListTile(
                      leading: CircleAvatar(),
                    title: Text('Hello Title'),
                    subtitle: Text('subtitle'),
                    trailing: Icon(Icons.add_shopping_cart),
                    ),
                  ),
                  Card(
                    elevation: 2.0,
                    color: Colors.indigo[50],
                    child: ListTile(
                      leading: CircleAvatar(),
                    title: Text('Hello Title'),
                    subtitle: Text('subtitle'),
                    trailing: Icon(Icons.add_shopping_cart),
                    ),
                  ),
                  Card(
                    elevation: 2.0,
                    color: Colors.indigo[50],
                    child: ListTile(
                      leading: CircleAvatar(),
                    title: Text('Hello Title'),
                    subtitle: Text('subtitle'),
                    trailing: Icon(Icons.add_shopping_cart),
                    ),
                  ),
                  Card(
                    elevation: 2.0,
                    color: Colors.indigo[50],
                    child: ListTile(
                      leading: CircleAvatar(),
                    title: Text('Hello Title'),
                    subtitle: Text('subtitle'),
                    trailing: Icon(Icons.add_shopping_cart),
                    ),
                  ),
                  Card(
                    elevation: 2.0,
                    color: Colors.indigo[50],
                    child: ListTile(
                      leading: CircleAvatar(),
                    title: Text('Hello Title'),
                    subtitle: Text('subtitle'),
                    trailing: Icon(Icons.add_shopping_cart),
                    ),
                  ),
                  Card(
                    elevation: 2.0,
                    color: Colors.indigo[50],
                    child: ListTile(
                      leading: CircleAvatar(),
                    title: Text('Hello Title'),
                    subtitle: Text('subtitle'),
                    trailing: Icon(Icons.add_shopping_cart),
                    ),
                  ),
                  
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column _buildCategoryIcon(IconData icon, String title) {
    return Column(
      children: <Widget>[
        IconButton(
          icon: Icon(
            icon,
            color: Colors.grey,
          ),
          onPressed: () {
            debugPrint('tapped');
          },
        ),
        Container(
          padding: const EdgeInsets.only(top: 0.0),
          child: Text(
            title,
            style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
