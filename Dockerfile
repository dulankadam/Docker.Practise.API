#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.


FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

#Build Stage
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["Docker.Practise.API.csproj", "."]
RUN dotnet restore "./Docker.Practise.API.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "Docker.Practise.API.csproj" -c Release -o /app/build

#Serve Stage
FROM build AS publish
RUN dotnet publish "Docker.Practise.API.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Docker.Practise.API.dll"]
