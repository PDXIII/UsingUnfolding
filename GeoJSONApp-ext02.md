---
layout: default
title: GeoJSONApp-ext02
category: GeoJSONApp
teaser: BlaBla
---

Now let's lay hand on the airports. To get an easy entry please insert thes lines at the end of your `setup()` function:

    List<Feature> airports = GeoJSONReader.loadData(this, "WorldAirports.geo.json");
    List<Marker> airportMarkers = MapUtils.createSimpleMarkers(airports);
    map.addMarkers(airportMarkers);

**And run!**

There are quite a lot of airports to display and it seems to me like a little loss of performance. And remember that we just want to see the airports of the country we are hovering. First of all we have to make the same changes on the airports stuff, that we made on the countries stuff: make the `Markers` global and don't add them to the `map`.

If you are done, let's think about, how we should handle the airports. My suggestion is to sort them into `ArrayLists` for each country one. Then we only have to call for that ArrayList and tell each airport inside to draw itself. Would be nice if this sorting could be done in advance, but the *WorldAirports.geo.json* lacks of meta information (properites), and the [Unfolding library][Unfolding library] needs to draw a map to compare the locations of two features. Therefore we must do the sorting one time during runtime. Please, make a global boolean an set it on false:

    boolean airportListsBuild = false;

Then go into your `draw()` function and make an `if-else` statement under the `map.draw()` that executes when the boolean is false.

    if(!airportListsBuild){

    }
    else{

    }

And put all code below this statement between the else brackets.

**Run!**

You should neither have an error nor any hover effect or output. Because all this will only work when `airportsListsBuild` is true. Meanwhile we'll do the sorting and we are going to to this with an own function.

So please insert a global `ArrayList<ArrayList> airportLists`, then edit your if-statement like this:

    if(!airportListsBuild){
      airportLists = makeAirportLists(map, countryMarkers, airportMarkers);
    }

this calls the function with the necessary parameters. Then make this new function under your draw() function:

    ArrayList <ArrayList> makeAirportLists(
        UnfoldingMap map, 
        List<Marker> countryMarkers, 
        List<Marker> airportMarkers){
          ArrayList <ArrayList> lists = new ArrayList();
          airportListsBuild = true;
          return lists;
    }

This function receives the parameters, makes a `new ArrayList`, sets our `boolean` to `true` and returns the `ArrayList`.

**Run!**

As you can see, our known interactions are back again, because when the function is called our `boolean` is set to `true` and the `else` part of our `if`-statement is executed. 

Now let's start sorting. For every country we want to check if there are any airports and put them into a list for each country.

Let's see:

    ArrayList <ArrayList> makeAirportLists(
        UnfoldingMap map, 
        List<Marker> countryMarkers, 
        List<Marker> airportMarkers){

      ArrayList <ArrayList> lists = new ArrayList();

      // iterating through the countryMarkers
      for (Marker country : countryMarkers){

        // a new ArrayList for each country
        ArrayList currentMarkerList = new ArrayList();

        // iterating through the airportMarkers
        for (Marker airport : airportMarkers){

          // we need to get the Loction of the airport
          Location airportLocation = airport.getLocation();

          // we need do convert it into a ScreenPosition
          ScreenPosition airportScreenPos = map.getScreenPosition(airportLocation);

          // and if this ScreenPosition is inside the country
          if(country.isInside(map, airportScreenPos.x, airportScreenPos.y)){

            // we add the Marker to this ArrayList
            currentMarkerList.add(airport);
          }
        }
        // we add this ArrayList of Markers to our ArrayList of ArrayLists
        lists.add(currentMarkerList);

        // to see if the program is running we generate some output
        println(lists.size());
      }
      airportListsBuild = true;
      return lists;
    }

Now we have a good structure, so let's play with it. We need to edit the `else` section in our `draw()` function after the `println(countryName)`:

    // we need to get right the airport list for the current country
    // because airportLists is sorted after the coutries i calls the right one
    ArrayList<Marker> currentAirportList = airportLists.get(i);

    // iterating through this airport list
    for (Marker currentAirport : currentAirportList ){

      // tell airport to draw itself
      currentAirport.draw(map);

      // check for mouse hover
      if (currentAirport.isInside(map, mouseX, mouseY)){

        // you should know this from the countries part
        HashMap currentAirportProps = currentAirport.getProperties();

        // Note: in this case "NAME" is written in uppercase,
        // this depends on the given geo.json file
        // it's better to know your data
        String currentAirportName = currentAirportProps.get("NAME").toString();

        // string output into the console
        println(currentAirportName);
      }
    }

##Style
Now it's time to get rid of the gray and add a little style, but you should do this on your own. For more tutorials concerning this and other topics, please visit [Unfolding tutorials][Unfolding tutorials].


{% include linklist.md %}