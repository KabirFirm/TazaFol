import 'package:flutter/material.dart';
import 'package:tazafol/components/color.dart';
import 'package:tazafol/components/url.dart';
import 'package:tazafol/models/dataModel.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HorizontalList extends StatefulWidget {
  final List<Category> categories;
  final ValueChanged<int> selectedCategoryChange;
  

  HorizontalList({Key key, this.categories, this.selectedCategoryChange}) : super(key:key);
  @override
  _HorizontalListState createState() => _HorizontalListState();
}

class _HorizontalListState extends State<HorizontalList> {

    onItemSelected(int categoryId){
    widget.selectedCategoryChange(categoryId);
    _saveCategoryId(categoryId);
    setState(() {
    });
  }

  void _saveCategoryId(int categoryId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('categoryId', categoryId);    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.red,
      height: 63.0,
      child: Scrollbar(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.categories.length,
                itemBuilder: (BuildContext context, int index){
                  return MyCategory(
                    categoryId: widget.categories[index].id,
                    categoryName: widget.categories[index].nameBn,
                    categoryImage: widget.categories[index].appImage,
                    isSelected: widget.categories[index].isSelected,
                    index: index,
                    callback: (){
                      //debugPrint('new index is = $index');
                      for(int i = 0; i< widget.categories.length; i++){
                        if(i == index){
                          widget.categories[i].isSelected = true;
                        }else{
                          widget.categories[i].isSelected = false;
                        }
                      }
                      onItemSelected(widget.categories[index].id);
                    },
                  );
                },
              ),
      ),
    );
  }
}

class MyCategory extends StatefulWidget {
  final String categoryImage;
  final String categoryName;
  final int categoryId;
  final bool isSelected;
  final int index;
  final VoidCallback callback;

  MyCategory({Key key, this.categoryId,this.categoryImage, this.categoryName, this.isSelected, this.index, this.callback}): super(key:key);

  _MyCategoryState createState() => _MyCategoryState();

}

class _MyCategoryState extends State<MyCategory> {


  Color _defaultColor = Colors.black45;
   //var baseUrl = "http://tazafol.com/app-api/";
   
  @override
  Widget build(BuildContext context) {
   
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: InkWell(
        onTap: () {
          widget.callback();
        },
        child: Container(
          decoration: widget.isSelected ? BoxDecoration(
                color: Colors.lightGreen[100],
                border: Border.all(color: appThemeColor),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ): BoxDecoration(),
          width: 50.0,
          child: ListTile(
            contentPadding: EdgeInsets.only(left: 2.0, right: 2.0),
            title: Image.network(baseUrl+widget.categoryImage, height: 35.0),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: Text(
                widget.categoryName, 
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: widget.isSelected ? appThemeColor: _defaultColor),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void arrangeProducts(int categoryId){
    debugPrint('Selected category is =${widget.categoryId}');
  }
}
