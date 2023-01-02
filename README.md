# Rep Buddy
Rep Buddy is a workout app for iOS and watchOS built with SwiftUI, Core Data, and CloudKit that allows the user to track their progress with user defined exercises and workouts.

<p align="center">
    <img src="https://github.com/julianworden/RepBuddy/blob/main/READMEImages/iOS/ExerciseDetailsView.png" width=30% height=30%> <img src="https://github.com/julianworden/RepBuddy/blob/main/READMEImages/iOS/WorkoutDetailsView.png" width=30% height=30%>
</p>

<p align="center">
    <img src="https://github.com/julianworden/RepBuddy/blob/main/READMEImages/watchOS/ExerciseDetailsView.png" width=25% height=25%> <img src="https://github.com/julianworden/RepBuddy/blob/main/READMEImages/watchOS/WorkoutDetailsView.png" width=25% height=25%>
</p>

## On The Surface
Here's how Rep Buddy works: To start, the user creates an exercise, gives it a name, and assigns a goal weight for it. Then, the user creates a workout to which they can add any exercises they've created, and sets with weight and rep count properties can be added to the exercises within the user's workouts. Once a user has added sets to an exercise, they can view those sets in a couple different places to track their progress in relation to their goals:

- WorkoutDetailsView, which shows all the sets for each Exercise within a workout by using a simple line graph. Tapping the line graph will present a subsequent view that shows a list of all the sets in words instead of in a chart.
- ExerciseDetailsView, which shows all the sets for a given Exercise across every workout to which the Exercise has been added by using a simple line graph. Tapping the line graph will present a subsequent view that shows a list of all the sets assigned to that exercise in words instead of in a chart. All sets are grouped by the workout to which they were added.

## Under the Hood
Rep Buddy was built with:

- Swift and SwiftUI
- MVVM architecture
- Core Data
- A Core Data NSPersistentCloudKitContainer implementation that allows for realtime updates between the iOS and watchOS apps
- The brand new Swift Charts API for all line graphs
- Thorough UI Tests and Unit Tests for both the watchOS and iOS apps (I haven't found any other thorough examples of Unit Testing and UI Testing for watchOS), see Notes.rtf file in the watchOS app for notes on known bugs I've found with watchOS testing)
- A custom SheetNavigator that makes it possible to have multiple sheets in one view without distributing different .sheet views throughout the view hierarchy
- Custom error types that make it easy to make your own tests that implement the .localizedDescription property
- View state management via a ViewState enum for all views
- Helper properties for NSManagedObjects that make it easier to create and interact with Core Data entities

## Notes
- This app is designed to be an extension of the stock Health and Fitness apps included with iOS and watchOS, so it's only meant for logging exercise reps and does not include functionality for tracking any timed workouts or cardio workouts.
- Rep Buddy will not be released on the App Store because I created this app so that I could have an easy way to experiment with the latest Swift and SwiftUI features as they're released.
- Feel free to report any bugs you find! Known bugs will be documented in each app's Notes.rtf file.
- I chose not to use NavigationStack quite yet because it appears to be quite buggy. For example, when moving from a view that has a .navigationTitle(.inline) modifier to a view that has a .navigationTitle(.large) modifier, the view with the large navigation title will do one of 2 things, both of which I've filed as bugs with Apple:
    - Start out with a navigation title that is inline, and then scrolling will allow it to become large as intended
    - Start out with a navigation title that is inline, and then snap to a large style with no animation in a way that doesn't look very good
