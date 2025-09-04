
# Étape 1 : Builder l'application avec Maven
FROM maven:3.9.6-eclipse-temurin-17 AS builder

# Créer le dossier de travail
WORKDIR /app

# Copier le pom.xml et télécharger les dépendances
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copier le code source et builder l'application
COPY src ./src
RUN mvn package -DskipTests

# Étape 2 : Créer l'image exécutable
FROM openjdk:17-jdk-slim

WORKDIR /app

# Copier le JAR depuis l’étape précédente
COPY --from=builder /app/target/*.jar app.jar

# Lancer l'application
ENTRYPOINT ["java", "-jar", "app.jar"]
