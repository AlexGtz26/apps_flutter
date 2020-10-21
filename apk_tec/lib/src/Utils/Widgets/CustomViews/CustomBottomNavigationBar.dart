import "package:flutter/material.dart";
class CustomBottomNavBar extends StatefulWidget  {

  final int currentIndex;
  final Function onTap;
  final List<BottomNavigationBarItem> items;
  final showSelectedLabels;
  final bool showUnselectedLabels;
  final Color backgroundColor;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final double iconSize;

  static const List<BottomNavigationBarItem> listitems=[];

  CustomBottomNavBar({this.currentIndex=0, this.onTap=null,this.items=listitems, this.showSelectedLabels=true,this.showUnselectedLabels=true,this.backgroundColor=Colors.white, this.selectedItemColor=Colors.black, this.iconSize=20, this.unselectedItemColor=Colors.blue});

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();

}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      //clipper:bottomNavBarFigure(),
      clipBehavior: Clip.antiAlias,
      child: BottomNavigationBar(
        onTap: widget.onTap,
        currentIndex:widget.currentIndex,
        items: widget.items,
        showSelectedLabels: widget.showSelectedLabels,
        showUnselectedLabels: widget.showSelectedLabels,
        backgroundColor: widget.backgroundColor,
        selectedItemColor: widget.selectedItemColor,
        unselectedItemColor: widget.unselectedItemColor,
        iconSize: widget.iconSize,
      ),
    );
  }
}

class bottomNavBarFigure extends CustomClipper<Path> {


  var radius=10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(18, 0);
    path.lineTo(0, 18);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 18);
    path.lineTo(size.width-18, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}