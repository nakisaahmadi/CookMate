import 'package:cookmate/cookbook.dart';
import 'package:cookmate/recipe.dart';
import 'package:cookmate/search.dart';
import 'package:cookmate/util/backendRequest.dart';
import 'package:cookmate/util/cookmateStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cookmate/util/localStorage.dart' as LS;

/*
  File: calendar.dart
  Functionality: This page displays the calendar for the user. It displays 
  a week at a time and a user can select a day and the meals that they have 
  added for that day will load. It allows for the user to remove and add 
  recipes to the calendar.
*/

// ignore: must_be_immutable
class MyCalendar extends StatefulWidget {

  Recipe recipe;
  MyCalendar({Key key, this.recipe}): super(key: key);
  @override
  State<StatefulWidget> createState() {
    return Calendar(recipe);
  }
}
class Calendar extends State<MyCalendar> {
  CalendarController _controller;
  BackendRequest backendRequest;
  Future <List<Meal>> mealFuture;
  List<Meal> ml;
  List<Meal> todayMeals;
  List<Meal> dayML;
  Date st;
  Date en;
  Meal meal;
  Recipe addToCalendar;
  Date selectedDay;
  String selectedDayString;
  String todayString;
  DateTime today;
  DateTime start;
  DateTime end;
  String message = "Select a day";
  Recipe addRecipe;
  bool firstTime;

  Future<bool>_getUserInfo() async {
    int userID = await LS.LocalStorage.getUserID();
    String token = await LS.LocalStorage.getAuthToken();
    backendRequest= BackendRequest(token, userID);
    if (backendRequest == null) {
      return false;
    }
    else {
      return true;
    }
  }
  Calendar(Recipe recipe) {
    if (recipe != null){
      this.addRecipe = recipe;
    }
    //firstTime = false;
    this.today = new DateTime.now();
    this.start = today.subtract(new Duration(days: 7));
    this.end = today.add(new Duration(days: 14));
    this.st = new Date(start.year, start.month, start.day);
    this.en = new Date(end.year, end.month, end.day);
    this.dayML = [];
    this.ml = [];
    this.todayMeals = [];
  }
  @override
  void initState() {
    super.initState();
    this.firstTime = true;
    selectedDay = new Date(today.year, today.month, today.day);
    selectedDayString = "${today.year}-${today.month}-${today.day}";
    _controller = CalendarController();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: NavBar(title: "Calendar", titleSize: 21, hasReturn: true, isCalendar: true,),
        body: SingleChildScrollView(
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TableCalendar(
                calendarController: _controller,
                initialCalendarFormat: CalendarFormat.twoWeeks,
                initialSelectedDay: today,
                startDay: start,
                endDay: end,
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    fontSize: 15,
                    color: CookmateStyle.textGrey,
                    fontWeight: FontWeight.w300
                  ),
                  weekendStyle: TextStyle(
                    fontSize: 15,
                    color: CookmateStyle.textGrey,
                    fontWeight: FontWeight.w200
                  ),
                ),

                calendarStyle: CalendarStyle(
                  selectedColor: Colors.redAccent,
                  todayColor: Colors.red[100],
                  weekdayStyle: TextStyle(
                    color: CookmateStyle.textGrey
                  ),
                  weekendStyle: TextStyle(
                    color: CookmateStyle.textGrey
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonShowsNext: false,
                  centerHeaderTitle: true,
                  formatButtonVisible: false,
                  leftChevronIcon: Icon(Icons.chevron_left, color: CookmateStyle.iconGrey),
                  rightChevronIcon: Icon(Icons.chevron_right, color: CookmateStyle.iconGrey),
                  headerPadding: EdgeInsets.only(top: 10, bottom: 25),
                  titleTextStyle: TextStyle(
                    fontSize: 22,
                    color: CookmateStyle.textGrey,
                    fontWeight: FontWeight.w300
                  ),
                ),
                onDaySelected: (date, events) {
                  if(mealFuture == null) {
                    setState(() {
                      selectedDay = new Date(date.year, date.month, date.day);
                      if (addRecipe != null){
                        backendRequest.addMealToCalendar(addRecipe, selectedDay);
                        ml.add(new Meal(99, addRecipe, selectedDay));
                        addRecipe = null;
                      }
                      this.firstTime = false;
                      this.selectedDayString =
                      "${date.year}-${date.month}-${date.day}";
                    });
                  }
                },
              ),
              showTotalMeals(),
            ],
          ),
        )
      );
  }

  Widget showTotalMeals() {
    print(selectedDayString);
    if (firstTime) {
      return FutureBuilder(
        future: _getUserInfo(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CookmateStyle.loadingIcon("Checking user ...");
            case ConnectionState.done:
              mealFuture = this.backendRequest.getMeals(
                    startDate: st, endDate: en);
              return FutureBuilder(
                future: mealFuture,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Padding(padding: EdgeInsets.all(40), child: CookmateStyle.loadingIcon("Getting meals ..."));
                    case ConnectionState.done:
                      mealFuture = null;
                      this.ml = snapshot.data;
                      if (ml.isNotEmpty) {
                        print("MEAL LIST SIZE: " + ml.length.toString());
                      }
                      this.todayString =
                      "${today.year}-${today.month}-${today.day}";
                      for (Meal meal in this.ml){
                        if (meal.date.getDate.compareTo(todayString) == 0) {
                          this.todayMeals.add(meal);
                        }
                      }
                      if (this.todayMeals.isNotEmpty) {
                        print("TODAY LIST SIZE: " + todayMeals.length.toString());
                      }
                      return showAll();
                    default:
                      return Text("error");
                  }
                },
              );
            default:
              return Text("error");
          }
        },
      );
    }
    else {
      return showAll();
    }
  }
  
  Widget showAll(){
    dayML.clear();
    for (Meal meal in ml) {
      if (meal.date.getDate.compareTo(selectedDayString) == 0) {
        dayML.add(meal);
      }
    }
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Container(
                height: 30,
                margin: EdgeInsets.all(20),
                child: Row(
                  children: <Widget> [ 
                    Text(
                      "Meals for the Day: ",
                      style: TextStyle(
                        color: CookmateStyle.textGrey,
                        fontSize: 17,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                    Text(
                      dayML.isNotEmpty ? (dayML.length.toString()) : "0",
                      style: TextStyle(
                        color: CookmateStyle.textGrey,
                        fontSize: 17,
                        fontWeight: FontWeight.w300
                      ),
                    ),
                  ]
                ),
              ),
            ),
            Container(
              height: 30,
              margin: EdgeInsets.all(10),
              child: (addRecipe != null) ? Text(
                message, style: TextStyle(fontSize: 14),) : Text(""),
            ),

          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Divider(),
        ),
        Container(
          height: 280,
          color: Colors.white,
          child: dayML.isNotEmpty
              ? ListView.builder(
            itemCount: dayML.length,
            padding: EdgeInsets.all(5),
            itemBuilder: (context, index) {
              return Container(
                width: 240,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: FlatButton(
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4.0,
                              )
                            ],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: dayML[index].recipe.image,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RecipeDisplay("${dayML[index].recipe.apiID}"))
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Text(
                        dayML[index].recipe.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: CookmateStyle.textGrey,
                          fontSize: 16
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.zero,
                      child: FlatButton(
                        child: Text(
                          "Remove",
                          style: TextStyle(
                            fontSize: 14,
                            color: CookmateStyle.standardRed
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            backendRequest.deleteMealFromCalendar(meal: dayML[index]);
                            ml.remove(dayML[index]);
                            dayML.removeAt(index);
                          });
                        },
                      ),
                    )
                  ],
                )
              );
            },
            scrollDirection: Axis.horizontal,
          )
              : Container(
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Text(
            dayML.isNotEmpty && dayML.length > 2 ? "Scroll right for more meals >" : "",
            style: TextStyle(
              fontSize: 14,
              color: CookmateStyle.iconGrey,
              fontWeight: FontWeight.w300
            ),
          ),
        )
      ],
    );
  }
}


