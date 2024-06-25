# Oracle

# Project Name

This project includes SQL scripts to create database tables for managing user credentials, cellular packages, and tariffs.

## Table of Contents

- [Introduction](#introduction)
- [SQL Scripts](#sql-scripts)
  - [UserCredentials Table](#usercredentials-table)
  - [CellularPackages Table](#cellularpackages-table)
  - [Tariffs Table](#tariffs-table)
- [Relationships](#relationships)
- [Usage](#usage)
  - [Setting Up the Database](#setting-up-the-database)
  - [Using the Tables](#using-the-tables)
- [Contributing](#contributing)

## Introduction

This project contains SQL scripts to create and manage database tables for a system that handles user credentials, cellular packages, and tariffs. The tables are designed to store information about users, their associated packages, and pricing details for different tariffs.

## SQL Scripts

### UserCredentials Table

The `UserCredentials` table stores user authentication information.

- `user_id`: Primary key for identifying users.
- `username`: Unique username for login.
- `password`: Password for user authentication.
- `email`: Unique email address for user contact.
- `created_at`: Timestamp for user registration.
- `package_id`: Foreign key referencing the package chosen by the user.
- `tariff_id`: Foreign key referencing the tariff selected by the user.

### CellularPackages Table

The `CellularPackages` table stores information about available cellular packages.

- `package_id`: Primary key for identifying packages.
- `package_name`: Unique name of the cellular package.
- `description`: Description of the package details.
- `price`: Price of the package per unit.

### Tariffs Table

The `Tariffs` table stores information about tariffs for cellular usage.

- `tariff_id`: Primary key for identifying tariffs.
- `tariff_name`: Unique name of the tariff.
- `description`: Description of the tariff details.
- `price_per_minute`: Price per minute for tariff usage.

## Relationships

- The `UserCredentials` table has relationships (`package_id` and `tariff_id`) with the `CellularPackages` and `Tariffs` tables respectively, allowing users to be associated with their chosen package and tariff details.

## Usage

### Setting Up the Database

1. **Database Configuration**:
   - Ensure Oracle Database is installed and running.
   - Connect to Oracle using SQL*Plus, SQL Developer, or another client.

2. **Running SQL Scripts**:
   - Execute the provided SQL scripts (`create_tables.sql`) to create the necessary tables.

### Using the Tables

- **Inserting Data**:
  - Use SQL `INSERT` statements to populate tables with initial data.
  
- **Querying Data**:
  - Write SQL `SELECT` queries to retrieve information from the tables.

## Contributing

Contributions are welcome. For major changes, please open an issue first to discuss what you would like to change.
