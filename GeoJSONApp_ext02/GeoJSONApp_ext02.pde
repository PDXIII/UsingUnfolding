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
List<Marker> airportMarkers;

boolean airportListsBuild = false;
ArrayList<ArrayList> airportLists;



void setup() {
  size(800, 600, GLConstants.GLGRAPHICS);
  smooth();

  map = new UnfoldingMap(this);
  MapUtils.createDefaultEventDispatcher(this, map);

  List<Feature> countries = GeoJSONReader.loadData(this, "countries.geo.json");
  countryMarkers = MapUtils.createSimpleMarkers(countries);

  List<Feature> airports = GeoJSONReader.loadData(this, "WorldAirports.geo.json");
  airportMarkers = MapUtils.createSimpleMarkers(airports);

}

void draw() {
  map.draw();
  if(!airportListsBuild){
    airportLists = makeAirportLists(map, countryMarkers, airportMarkers);
  }
  else{
    for (int i = 0; i < countryMarkers.size(); i++){
      Marker country = countryMarkers.get(i);
      if(country.isInside(map, mouseX, mouseY)){
        country.draw(map);
        HashMap countryProps = country.getProperties();
        String countryName = countryProps.get("name").toString();
        println(countryName);

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
      }
    }
  }
}

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