FROM mcr.microsoft.com/dotnet/core/sdk:2.2-alpine AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY aspcorewebapp/*.csproj ./aspcorewebapp/
RUN dotnet restore

# copy everything else and build app
COPY aspcorewebapp/. ./aspcorewebapp/
WORKDIR /app/aspcorewebapp
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-alpine AS runtime
WORKDIR /app
COPY --from=build /app/aspcorewebapp/out ./
ENTRYPOINT ["dotnet", "aspcorewebapp.dll"]