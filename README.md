# Filip Konštiak — CV Web App

Interactive personal CV built with Flutter Web. Features a modern dark UI, Slovak/English language toggle, smooth animations, and a PDF export that generates a clean 2-page document.

## Features

✦ Dark mode UI with accent colors and animated transitions
✦ Slovak / English language switching
✦ Scroll progress bar and typing effect in the header
✦ PDF export — 2-page layout generated entirely in the browser
✦ Sections: Experience, Education, Projects, Tech Stack, Languages, Soft Skills, Social Networks, Volunteering, Certificates, References

## Tech Stack

Flutter · Dart · pdf · printing · google_fonts · animate_do

## Run Locally

```bash
flutter pub get
flutter run -d chrome
```

## Build for Web

```bash
flutter build web
```

## Project Structure

```
lib/
  main.dart          — app entry point
  cv_page.dart       — full CV layout and all UI sections
  cv_data.dart       — data models and CV content (SK + EN)
  pdf_generator.dart — PDF export logic
web/
  index.html         — print media CSS and Flutter bootstrap
```
