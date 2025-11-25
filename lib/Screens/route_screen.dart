import 'package:campus_ride/Screens/home_screen_pages/home_screen.dart';
import 'package:flutter/material.dart';

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class Route_Screen extends StatefulWidget {
  const Route_Screen({super.key});

  @override
  State<Route_Screen> createState() => _Route_ScreenState();
}

class _Route_ScreenState extends State<Route_Screen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(top: screenHeight *.03, left: screenWidth *.15,child: SizedBox (height: screenHeight *.25, width: screenWidth * .7,child: Image.asset("assets/images/logo(2).png",fit: BoxFit.fill,),),),
          Positioned(top: screenHeight *.25, left: screenWidth *.25,child: const Text("Select Your Route",style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),),),
          Positioned(top: screenHeight *.305, left: screenWidth *.12,child: const Text("By selecting your route, every day you will",style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),),),
          Positioned(top: screenHeight *.325, left: screenWidth *.13,child: const Text("get update of bus location on your route.",style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),),),
          Positioned(top: screenHeight *.4, left: screenWidth *.37,child: Container(height: screenHeight *.1, width: screenWidth *.23, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.red),child: const Icon(Icons.directions_bus,size: 60, color: Colors.white,))),
          Positioned(top: screenHeight *.55, left: screenWidth *.10,child: const dropDownMenu(),),
          Positioned(
            top: screenHeight *.75,
            left: screenWidth *.03,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: screenHeight *.08,
                width: screenWidth *.9,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Home_Screen()));
                  },
                  child: Container(
                    height: 200,
                    width: 395,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.red,
                    ),
                    child: const Center(
                      child: Text(
                        "Continue",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class dropDownMenu  extends StatefulWidget{
  const dropDownMenu({super.key});

  @override
  State<dropDownMenu> createState() => _dropDownMenuState();
}
class _dropDownMenuState extends State<dropDownMenu>{
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context){
    return const DropdownMenu(
      width: 325,
      hintText: "Select Your Route",
      helperText: "Select Your Bus-Stop",
      enableFilter: true,
      enableSearch: true,
      dropdownMenuEntries: <DropdownMenuEntry<String>>[
      DropdownMenuEntry(value: 'Gajera Circle', label: 'Gajera Circle'),
      DropdownMenuEntry(value: 'Amroli', label: 'Amroli'),
      DropdownMenuEntry(value: 'Jahangirpura', label: 'Jahangirpura'),
      DropdownMenuEntry(value: 'Tadwadi', label: 'Tadwadi'),
      DropdownMenuEntry(value: 'Simada', label: 'Simada'),

    ]);
  }
}

