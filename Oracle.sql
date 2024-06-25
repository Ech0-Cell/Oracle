

-- Create UserCredentials table with larger sizes
CREATE TABLE UserCredentials (
    user_id NUMBER PRIMARY KEY,
    username VARCHAR2(100) UNIQUE NOT NULL,
    password VARCHAR2(150) NOT NULL,
    email VARCHAR2(150) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    package_id NUMBER,
    tariff_id NUMBER,
    FOREIGN KEY (package_id) REFERENCES CellularPackages(package_id),
    FOREIGN KEY (tariff_id) REFERENCES Tariffs(tariff_id)
);

-- Create CellularPackages table with larger sizes
CREATE TABLE CellularPackages (
    package_id NUMBER PRIMARY KEY,
    package_name VARCHAR2(150) UNIQUE NOT NULL,
    description VARCHAR2(500),
    price NUMBER(10, 2) NOT NULL
);

-- Create Tariffs table with larger sizes
CREATE TABLE Tariffs (
    tariff_id NUMBER PRIMARY KEY,
    tariff_name VARCHAR2(150) UNIQUE NOT NULL,
    description VARCHAR2(500),
    price_per_minute NUMBER(10, 2) NOT NULL
);

-- Explanation of relationships
COMMENT ON TABLE UserCredentials IS 'Stores user credentials and links to CellularPackages and Tariffs tables';
COMMENT ON COLUMN UserCredentials.package_id IS 'Foreign key referencing package_id in CellularPackages';
COMMENT ON COLUMN UserCredentials.tariff_id IS 'Foreign key referencing tariff_id in Tariffs';
