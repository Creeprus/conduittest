FROM dart:2.18.6-sdk

# Resolve app dependencies.
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

# Copy app source code and AOT compile it.
COPY . .
# Ensure packages are still up-to-date if anything has changed
RUN dart pub get

#RUN dart compile exe bin/conduittest.dart -o bin/conduittest
RUN dart pub global activate conduit 4.1.6

# Build minimal serving image from AOT-compiled `/server` and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
#FROM scratch
#COPY --from=build /runtime/ /
#COPY --from=build /app/bin/conduittest.dart /app/bin/

# Start server.
EXPOSE 8888
#CMD ["/app/bin/conduittest","dart"]
#RUN dart run conduit db upgrade

ENTRYPOINT  ["dart","run","/app/bin/conduittest.dart","conduit:conduit"]