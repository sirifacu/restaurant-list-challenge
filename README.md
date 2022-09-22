
# The Fork - Restaurants App


## How to build this project?
    1. Clone or download the project.
    2. Open a terminal in project's root and run:
        pod install
    3. Open RestaurantsApp.xcworkspace and run the app.

    At this point, you can also compile and run the tests.

## Technical Choices

I decided to use MVVM as architectural pattern, mostly because I feel confident working with it
and besides I was told in the interview that the app is been migrated into this pattern.

I divided the project into one module called Commons, where I placed those elements that could be
used by severals modules in the app; and another module called RestaurantList, that has its own
model, view and view model, and has the functionalities to show the list of restaurants.

In order to persist favorite restaurants data in the app, I used Realm instead of Core Data, as I
find Realm quite easier to implement.

Finally, I used Quick and Nimble for testing because I think that those libraries make the test 
descriptions far more readable.

## Potential difficulties

There are some things that could be improved in this project. For instance, there are some classes 
that have no tests yet. Besides, it could be a good idea to use Alamofire to make requests instead
of having a custom WebService. I could also use a library such as AlamofireImage or Kingfisher to
load and cache images instead of having a custom ImageLoader.
