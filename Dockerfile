# Base image for running the app
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

# SDK image for building the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["LoanClaimsManagement.csproj", "./"]
RUN dotnet restore "./LoanClaimsManagement.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "LoanClaimsManagement.csproj" -c Release -o /app/build

# Publish image
FROM build AS publish
RUN dotnet publish "LoanClaimsManagement.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Final image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "LoanClaimsManagement.dll"]
