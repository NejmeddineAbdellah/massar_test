FROM cirrusci/flutter:stable AS build
WORKDIR /app
COPY pubspec.* ./
RUN flutter pub get

COPY . .
RUN flutter build apk --release

FROM nginx:alpine
COPY --from=build /app/build/app/outputs/flutter-apk/app-release.apk /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
