#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

#Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
#For more information, please see https://aka.ms/containercompat

FROM mcr.microsoft.com/dotnet/aspnet:8.0-nanoserver-1809 AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

FROM mcr.microsoft.com/dotnet/sdk:8.0-nanoserver-1809 AS build
WORKDIR /src
COPY ["1 - Application/CarReservation.Application/CarReservation.Application.csproj", "1 - Application/CarReservation.Application/"]
COPY ["2 - Domain/CarReservation.Domain/CarReservation.Domain.csproj", "2 - Domain/CarReservation.Domain/"]
COPY ["4 - Infrastructure/CarReservation.Infrastructure/CarReservation.Infrastructure.csproj", "4 - Infrastructure/CarReservation.Infrastructure/"]
COPY ["3 - Service/CarReservation.Service/CarReservation.Service.csproj", "3 - Service/CarReservation.Service/"]
RUN dotnet restore "1 - Application/CarReservation.Application/CarReservation.Application.csproj"
COPY . .
WORKDIR "/src/1 - Application/CarReservation.Application"
RUN dotnet build "CarReservation.Application.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "CarReservation.Application.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CarReservation.Application.dll"]