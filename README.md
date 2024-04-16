# pixaby_tw

A new Flutter project.

# Deployment Guide

- Commit on `main`
- git checkout `gh-pages`
- Sync `gh-pages` with `main`
- `flutter build web --release`
- Commit on `gh-pages`
- `git subtree push --prefix build/web origin gh-pages`

GitHub Action takes over and deploys on GitHub pages

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
