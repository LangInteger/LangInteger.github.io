---
title: Tuning Development Process with Flyway
date: 2020-11-18 14:33:09
tags: [Spring Boot,Flyway]
---

There are embarassing situations when developing a mono project with multiple environments.

![process](http://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.githubusercontent.com/LangInteger/learning/master/draw/plantuml/20201117-flyway-why.puml)

Like git for code repository, flyway aims to take version control to database. This article introduces how to use flyway in a spring boot project environment with existing dataset.

<!--more-->

## 1 Concepts

Flyway offers it's functionalities in two ways:

- Flyway Command-line Tool
  - Using commands like `flyway migrate`
- API
  - Initialize `Flyway` object in java, using code like `flyway.migrate()`

All functionalities flyway offers are related to concepts introduced below.

### 1.1 Migrate

> Migrates the schema to the latest version. Flyway will create the schema history table automatically if it doesn’t exist.
Executing migrate is idempotent and can be done safely regardless of the current version of the schema.

![process](http://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.githubusercontent.com/LangInteger/learning/master/draw/plantuml/20201117-flyway-migrate.puml)

#### Example 1

- We have migrations available up to version 9, and the database is at version 5.
- Migrate will apply the migrations 6, 7, 8 and 9 in order.

#### Example 2

- We have migrations available up to version 9, and the database is at version 9.
- Migrate does nothing.

### 1.2 Clean

> Drops all data in the configured schema.

![process](http://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.githubusercontent.com/LangInteger/learning/master/draw/plantuml/20201117-flyway-clean.puml)

### 1.3 Validate

> Validates the applied migrations against the available ones.

![process](http://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.githubusercontent.com/LangInteger/learning/master/draw/plantuml/20201117-flyway-validate.puml)

### 1.4 Baseline

> Baselines an existing database, excluding all migrations up to and including baselineVersion.

![process](http://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.githubusercontent.com/LangInteger/learning/master/draw/plantuml/20201117-flyway-baseline.puml)

## 2 Integrate With Spring Boot

Spring Boot works perfectly well with flyway. It will automatically execute sql files as configured using `migrate()` and `baseline()` api.

### 2.1 Import Dependency

In gradle build file, declaring as follows:

- compile "org.flywaydb:flyway-core"

version is not needed, since `spring.dependency-management` has already be used in our project.

### 2.2 Spring Configuration

```yml
spring:
  flyway:
    enabled: true # Whether to enable flyway
    cleanDisabled: true # Whether to disable cleaning of the database
    locations: "cl`asspath:db/migration" # Locations of migrations scripts
    baseline-on-migrate: true # Whether to automatically call baseline when migrating a non-empty schema
    baseline-version: 1 # Version to tag an existing schema with when executing baseline
    validate-on-migrate: true # Whether to automatically call validate when performing a migration
    clean-on-validation-error: false # Whether to automatically call clean when a validation error occurs
```

The `enabled`, `cleanDisabled`, `location`, `baseline-version` attributs are declared with default value. `baseline-on-migrate` is set true to make baseline executed when migrating a non-empty schema, which matches our situation. If you are working with a shinny-new schema, you are not required to do that.

### 2.3 SQL File Regulation

All migration files are required to be placed at where `spring.flyway.locations` defines, and they shoud be named with following conventions:

- V2.1.1__Your_Description.sql
  - Prefix: V
  - Version: 2.1.1
  - Separator: __ (two underscores)
  - Description: Underscores to seperate the words
  - Suffix: .sql

## 3 Trouble Shooting

### 3.1 Tuning JPA and Flyway in IntegrationTest

If you are using multiple database initialization utilities, you may want to make them orderd.

In our case, we are using both JPA and Flyway in integration test. JPA is used to create tables for in-memory database, flyway is used to get some data published. We need to make them work in a pre-defiend order.

```java
@Configuration
public class MigrationConfiguration {
  
  /**
   * Override default flyway initializer to do nothing
   */
  @Bean
  FlywayMigrationInitializer flywayInitializer(Flyway flyway) {
    return new FlywayMigrationInitializer(flyway, (f) -> {
    });
  }
  
  /**
   * Create a second flyway initializer to run after jpa has created the schema
   */
  @Bean
  @DependsOn("entityManagerFactory")
  FlywayMigrationInitializer delayedFlywayInitializer(Flyway flyway) {
    return new FlywayMigrationInitializer(flyway, null);
  }
}
```

## Reference

- [Flyway - Why Database Imigrations](https://flywaydb.org/documentation/getstarted/why)
- [Flyway - Community Plugins and Integrations: Spring Boot](https://flywaydb.org/documentation/usage/plugins/springboot)
- [Spring Boot Docs - Database Initialization](https://docs.spring.io/spring-boot/docs/2.1.1.RELEASE/reference/html/howto-database-initialization.html)
