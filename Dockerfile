# Use uma imagem Maven com JDK 17 para a fase de build
FROM maven:3.8.5-openjdk-17 AS build

# Defina o diretório de trabalho
WORKDIR /app

# Copie o pom.xml primeiro para aproveitar o cache de dependências do Docker
COPY pom.xml .

# Baixe as dependências (sem rodar testes ou compilar ainda)
RUN mvn dependency:go-offline -B

# Copie o restante do código da aplicação
COPY src ./src

# Construa a aplicação, gerando o .jar
# O -DskipTests é opcional, mas acelera o build em pipelines de CI/CD
RUN mvn package -DskipTests

# Use uma imagem base leve com OpenJDK 17 JRE para a fase de execução
FROM openjdk:17-jre-slim

# Defina o diretório de trabalho
WORKDIR /app

# Copie o .jar da fase de build para a fase de execução
# O nome do JAR pode variar dependendo do artifactId e version no pom.xml
# Assumindo que o artifactId é 'hello-world-app' e a versão é '0.0.1-SNAPSHOT' (padrão do Spring Initializr)
COPY --from=build /app/target/hello-world-app-0.0.1-SNAPSHOT.jar app.jar

# Exponha a porta que a aplicação Spring Boot usa (padrão 8080)
EXPOSE 8080

# Comando para executar a aplicação quando o container iniciar
ENTRYPOINT ["java", "-jar", "app.jar"]

