#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

#FROM mcr.microsoft.com/dotnet/sdk:5.0-alpine AS base
#RUN apk add --no-cache git
#WORKDIR /app
#
#RUN dotnet --version
#WORKDIR /src
#COPY ["Fuel-Georgia-Parser.csproj", "."]
#RUN dotnet restore "./Fuel-Georgia-Parser.csproj"
#COPY . .
#WORKDIR "/src/."
#RUN dotnet build "Fuel-Georgia-Parser.csproj" -c Release -o /app/build
#
#FROM base AS publish
#RUN dotnet publish "Fuel-Georgia-Parser.csproj" -c Release -o /app/publish
#
#FROM base AS final
#WORKDIR /app
#COPY --from=publish /app/publish .
#ENTRYPOINT ["dotnet", "Fuel-Georgia-Parser.dll"]

FROM mcr.microsoft.com/dotnet/sdk:5.0-alpine AS publish
WORKDIR /src
#COPY ["Fuel-Georgia-Parser.csproj", "./"]

COPY . .
RUN dotnet publish "Fuel-Georgia-Parser.csproj" -c Release --runtime alpine-x64 -o /app/publish --self-contained true -p:PublishSingleFile=true

FROM mcr.microsoft.com/dotnet/runtime-deps:5.0-alpine AS final
RUN apk add --no-cache git

WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["/app/Fuel-Georgia-Parser"]