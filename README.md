## App screenshots and Screen recording

https://drive.google.com/drive/folders/13Wo7ahZ12iaA0dbgmPi78sOZgRjowcCO?usp=share_link

![bharatnxt](https://github.com/user-attachments/assets/47128bb1-53f5-4532-91cf-ac94c034f77c)

## Bharat NXT - Flutter Article App
A Flutter app that fetches and displays a list of articles from a public API.

## Features

- List of articles  
- Search functionality  
- Article detail view  
- Add or remove articles from favourites  
- Pull to refresh for latest data  
- Responsive UI for all screen sizes  

 ## Setup Instructions  
 1. Clone the repo:
```bash 
git clone https://github.com/Bhaveshupadhyay/bharat_nxt.git
cd flutter bharat_nxt
```
2. Install dependencies:
```bash 
flutter pub get
```
3. Run the app:
```bash 
flutter run
```
## Tech Stack
- Flutter SDK:  3.27.3
- State Management: Bloc
- HTTP Client: dio
- Persistence: shared_preferences

## State Management Explanation
- Used flutter_bloc (Cubit) for state management, providing a clear separation between business logic and UI. ArticleCubit handles loading articles from API and FavouriteCubit is used to add/remove articles from favourites.

## Known Issues / Limitations
- Current search filtering is happening offline, which may impact app performance. Since the entire list is traversed every time the search text changes, the time complexity is O(N) and not optimized.
- Offline handling is incomplete: if the user is offline, a connection error is shown, but when back online, articles do not reload automatically.
- Favourite articles are stored locally but not synced with a remote backend, so they may be lost if the app is uninstalled.
- Used setState in Home to hide/unhide the search bar based on scroll behavior, but this may impact performance because setState rebuilds the entire UI from scratch.

## Libraries Used

- Flutter Bloc
- dio
- fpdart
- Shared Prefrences
- Screen utils

## Flutter Bloc

used Cubit to manage the state of the app, ensuring that the UI reacts to changes in data and state without tightly coupling the logic with the UI

## dio

used dio in my project for its advanced features, including response interceptors for logging and error handling

## fpdart

used fpdart's Either to handle API success and failure in a clean and predictable way

## Shared Prefrences

Used SharedPreferences to save favourite articles on the device. Stored them as key-value pairs, with the article ID as the key.

## Screen utils

used to make the app responsive on all devices. It adjusts the layout to fit different screen sizes and resolutions, ensuring a consistent user experience across smartphones, tablets, and other devices

