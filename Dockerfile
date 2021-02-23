FROM mcr.microsoft.com/dotnet/framework/sdk:4.8 AS build
WORKDIR /app
#changes

# copy csproj and restore as distinct layers
COPY *.sln .
COPY SampleWebApplicationDocker/*.csproj ./SampleWebApplicationDocker/
COPY SampleWebApplicationDocker/*.config ./SampleWebApplicationDocker/
RUN nuget restore

# copy everything else and build app
COPY SampleWebApplicationDocker/. ./SampleWebApplicationDocker/
WORKDIR /app/SampleWebApplicationDocker
RUN msbuild /p:Configuration=Release


FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8 AS runtime
WORKDIR /inetpub/wwwroot
COPY --from=build /app/SampleWebApplicationDocker/. ./