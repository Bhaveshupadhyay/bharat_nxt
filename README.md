## App screenshots and Screen recording

https://drive.google.com/drive/folders/1GWU58h54k5AfJZE0zN_WPPHmHraCdogM?usp=share_link
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
git clone https://github.com/Bhaveshupadhyay/bharat_nxt.git
cd flutter bharat_nxt

3. Install dependencies:
flutter pub get

5. Run the app:
flutter run

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

## Extra

 I used Aspect Ratio and Card ID, which were defined in the API but not initially part of the app's predefined schema

- I used Aspect Ratio value to ensure that images were displayed correctly across different screen sizes, preserving their proportions and fitting perfectly within their containers
- The Card ID, also defined in the API, allowed me to uniquely identify each card and store its specific data locally using SharedPreferences
