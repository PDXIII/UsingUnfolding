UsingUnfolding
==============

This is a tutorial about using the [Unfolding library][Unfolding library] for [Processing][Processing] by [Till Nagel][Till Nagel].

#ExtendedGeoJSONApp.pde
In this tutorial we will build a map showing us the airport of the country we point with the mouse at. Therefore we are going to use two files of the type *geo.json*.

##Data
We need to give our program the chance to know, if the mouse is inside a country or not. So, we need the shapes of the countries. A nice file wich serves the purpose could be found here: [contries.geo.json][contries.geo.json].
The shapes in this file are a little rough, but this provides better performance for our app. Then we need the locations of all airports. Let's take a look at [GeoCommons][GeoCommons]. Type into the search field "world airports" and hit the first result. As you can see, there is no option for downloading a valid *geo.json* version of this data set, but I have a gift for you: [GeoCommonsGEOJSON][GeoCommonsGEOJSON]. This link provides a javascript code, you can use as an bookmarklet in your browser. Now when you are back on the data-set at *GeoCommons* you only need to hit this bookmarklet and you will be led to a valid version of this data-set. Save it as *WorldAirports.geo.json*

Now, we have two files: *countries.geo.json* and *WorldAirports.json*. So, let's write some code.

**Note: While writing this tutorial, the world airports data-set disappeared on GeoCommons. But there is a version in the download files.**

##Code
Let's start with opening the *GeoJsonApp.pde* from the examples folder of the Unfolding library, save it as *ExtendedGeoJSONApp.pde* and add the files to your project.

###Countries & Interaction
Now, let's see how the countries will be displayed by changing the following

      List<Feature> countries = GeoJSONReader.loadData(this, "countries-simple.geo.json");

into

      List<Feature> countries = GeoJSONReader.loadData(this, "countries.geo.json");

Yes, I told you the shapes are rough, but the performance is quite good. Please don't mind the gray, you can take care about that later. The bigger problem for now is: we don't want the countries to be displayed permanently. Just when the mouse hovers it, we want to see the shape.

That means we don't want the `countryMarkers` to be added to the `map` and for further use we need those `Markers` globaly. So please make following changes:

Delete:

      map.addMarkers(countryMarkers);

Insert (at top):

    List<Marker> countryMarkers;

Change:
      List<Marker> countryMarkers = MapUtils.createSimpleMarkers(countries);

into:
      countryMarkers = MapUtils.createSimpleMarkers(countries);

*Run the program!*

If you get no error and you see no shape – everthing is fine!

Remember, that we only want to see the country's shape when we hover it. Therefore we need to ask every country, if the mouse is inside its borders and then tell the country to draw itself. Please move to your `draw()` function and edit it like this:

    void draw() {
      map.draw();
      for (int i = 0; i < countryMarkers.size(); i++){
        Marker country = countryMarkers.get(i);
        if(country.isInside(map, mouseX, mouseY)){
          country.draw(map);
        }
      }
    }

*Run!*

Ah! Nice! We have a hover effect. At this point I'd like to talk a little bit about the use of the properties of a geo.json feature. Often you will find really useful content inside it. For example every feature (country) of our *countries.geo.json* contains the full name of its country. You can use this to eventually display it. 

The properties are stored in a `HashMap`, though you can get a value by looking for the wanted key, in this case `"name"`.

Please edit your if-statement like this:

      if(country.isInside(map, mouseX, mouseY)){
        country.draw(map);
        HashMap countryProps = country.getProperties();
        String countryName = countryProps.get("name").toString();
        println(countryName);
      }

*Run!*

Now you should have the hover effect and a string output in your console. Good Job! If you should have contrary to expectations any trouble, then you can now compare your code:

    import de.fhpotsdam.unfolding.mapdisplay.*;
    import de.fhpotsdam.unfolding.utils.*;
    import de.fhpotsdam.unfolding.marker.*;
    import de.fhpotsdam.unfolding.tiles.*;
    import de.fhpotsdam.unfolding.interactions.*;
    import de.fhpotsdam.unfolding.ui.*;
    import de.fhpotsdam.unfolding.*;
    import de.fhpotsdam.unfolding.core.*;
    import de.fhpotsdam.unfolding.data.*;
    import de.fhpotsdam.unfolding.geo.*;
    import de.fhpotsdam.unfolding.texture.*;
    import de.fhpotsdam.unfolding.events.*;
    import de.fhpotsdam.utils.*;
    import de.fhpotsdam.unfolding.providers.*;
    import processing.opengl.*;
    import codeanticode.glgraphics.*;
    
    UnfoldingMap map;
    List<Marker> countryMarkers;
    
    void setup() {
      size(800, 600, GLConstants.GLGRAPHICS);
      smooth();
    
      map = new UnfoldingMap(this);
      MapUtils.createDefaultEventDispatcher(this, map);
    
      List<Feature> countries = GeoJSONReader.loadData(this, "countries.geo.json");
      countryMarkers = MapUtils.createSimpleMarkers(countries);
    }
    
    void draw() {
      map.draw();
      for (int i = 0; i < countryMarkers.size(); i++){
        Marker country = countryMarkers.get(i);
        if(country.isInside(map, mouseX, mouseY)){
          country.draw(map);
          HashMap countryProps = country.getProperties();
          String countryName = countryProps.get("name").toString();
          println(countryName);
        }
      }
    }

###Airports & Performance

Now let's get hands on the airports. To get an easy entry please insert thes lines at the end of your `setup()` function:

      List<Feature> airports = GeoJSONReader.loadData(this, "WorldAirports.geo.json");
      List<Marker> airportMarkers = MapUtils.createSimpleMarkers(airports);
      map.addMarkers(airportMarkers);

*And run!*

There are quite a lot of airports to display and it seems to me like a little loss of performance. And remember that we just want to see the airports of the country we are hovering. First of all we have to make the same changes on the airports stuff, that we made on the countries stuff: make the `Markers` global and don't add them to the `map`.

If you are done, let's think about, how we should handle the airports! My suggestion is to sort them into `ArrayLists` for each country one. Then we only have to call for that ArrayList and tell each airport inside to draw itself. Would be nice if this sorting could be done in advance, but the *WorldAirports.geo.json* lacks of meta information (properites), and the [Unfolding library][Unfolding library] needs to draw a map to compare the locations of two features. Therefore we must do the sorting one time during runtime. Please, make a global boolean an set it on false:

    boolean airportListsBuild = false;

Then go into your `draw()` function and make an `if-else` statement under the `map.draw()` that executes when the boolean is false.

    if(!airportListsBuild){

    }
    else{

    }

And put all code below this statement between the else brackets.

*Run!*

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

*Run! *

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
Now it's time to get rid of the gray and add a little style, but you should do this own your own. For more tutorials concerning this and other topics, please visit [Unfolding tutorials][Unfolding tutorials].



[Unfolding library]: http://http://unfoldingmaps.org/
[Processing]: http://processing.org/
[Till Nagel]: http://http://tillnagel.com/
[contries.geo.json]: http://https://github.com/johan/world.geo.json/blob/master/countries.geo.json
[GeoCommons]: http://geocommons.com/
[GeoCommonsGEOJSON]: https://gist.github.com/4030898
[Unfolding tutorials]: http://unfoldingmaps.org/tutorials/index.html