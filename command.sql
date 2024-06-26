
/************************************************
*                                               *
*         CREATING USER AND GRANTING IT         *
*                                               *
************************************************/
CREATE USER celly IDENTIFIED BY 010823;
GRANT RESOURCE, CONNECT, UNLIMITED TABLESPACE TO celly;

/************************************************
*                                               *
*          CREATING NECESSARY TABLES            *
*                                               *
************************************************/
-- Create UserCredentials table
CREATE TABLE UserCredentials (
    user_id NUMBER PRIMARY KEY,
    username VARCHAR2(50) UNIQUE NOT NULL,
    password VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    package_id NUMBER,
    tariff_id NUMBER,
    FOREIGN KEY (package_id) REFERENCES CellularPackages(package_id),
    FOREIGN KEY (tariff_id) REFERENCES Tariffs(tariff_id)
);

-- Create CellularPackages table
CREATE TABLE CellularPackages (
    package_id NUMBER PRIMARY KEY,
    package_name VARCHAR2(100) UNIQUE NOT NULL,
    description VARCHAR2(255),
    price NUMBER(10, 2) NOT NULL
);

-- Create Tariffs table
CREATE TABLE Tariffs (
    tariff_id NUMBER PRIMARY KEY,
    tariff_name VARCHAR2(100) UNIQUE NOT NULL,
    description VARCHAR2(255),
    price_per_minute NUMBER(10, 2) NOT NULL
);

/************************************************
*                                               *
*         ADDING DATA TO EXISTING TABLES        *
*                                               *
************************************************/
-- Inserting data into CellularPackages table
INSERT INTO CellularPackages (package_id, package_name, description, price)
VALUES (1, 'Basic Package', 'Basic cellular package with limited features', 10.00);

INSERT INTO CellularPackages (package_id, package_name, description, price)
VALUES (2, 'Premium Package', 'Premium cellular package with additional features', 25.00);

-- Inserting data into Tariffs table
INSERT INTO Tariffs (tariff_id, tariff_name, description, price_per_minute)
VALUES (1, 'Standard Tariff', 'Standard tariff with regular rates', 0.05);

INSERT INTO Tariffs (tariff_id, tariff_name, description, price_per_minute)
VALUES (2, 'Discount Tariff', 'Discount tariff with lower rates', 0.03);

-- Inserting data into UserCredentials table
INSERT INTO UserCredentials (user_id, username, password, email, package_id, tariff_id)
VALUES (1, 'john_doe', 'password123', 'john@example.com', 1, 1);

INSERT INTO UserCredentials (user_id, username, password, email, package_id, tariff_id)
VALUES (2, 'jane_doe', 'password456', 'jane@example.com', 2, 2);

/************************************************
*                                               *
*   CREATING PACKAGE FOR CUSTOMER PROCEDURES    *
*                                               *
************************************************/
CREATE OR REPLACE PACKAGE package_customer IS
    FUNCTION login (U_USERNAME IN UserCredentials.username%TYPE, U_PASSWORD IN UserCredentials.password%TYPE) RETURN NUMBER;
    FUNCTION get_user_package (p_username UserCredentials.username%TYPE) RETURN CellularPackages.package_name%TYPE;
    FUNCTION get_user_tariff (p_username UserCredentials.username%TYPE) RETURN Tariffs.tariff_name%TYPE;
    PROCEDURE create_user(S_USER_ID IN UserCredentials.user_id%TYPE, S_USERNAME IN UserCredentials.username%TYPE, S_PASSWORD IN UserCredentials.password%TYPE,
                          S_EMAIL IN UserCredentials.email%TYPE, P_PACKAGE_ID IN UserCredentials.package_id%TYPE, P_TARIFF_ID IN UserCredentials.tariff_id%TYPE);
END package_customer;

CREATE OR REPLACE PACKAGE BODY package_customer IS
    FUNCTION login (U_USERNAME IN UserCredentials.username%TYPE, U_PASSWORD IN UserCredentials.password%TYPE) RETURN NUMBER AS
        match_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO match_count FROM UserCredentials WHERE username = U_USERNAME AND password = U_PASSWORD; 
        COMMIT;
        IF match_count = 0 THEN
            RETURN 0;
        ELSIF match_count >= 1 THEN
            RETURN 1;
        END IF;
    EXCEPTION
        WHEN CASE_NOT_FOUND THEN
            RETURN 0;
    END;

    FUNCTION get_user_package(p_username UserCredentials.username%TYPE) RETURN CellularPackages.package_name%TYPE AS
        v_package_name CellularPackages.package_name%TYPE;
    BEGIN
        SELECT CellularPackages.package_name INTO v_package_name 
        FROM UserCredentials 
        INNER JOIN CellularPackages ON UserCredentials.package_id = CellularPackages.package_id 
        WHERE UserCredentials.username = p_username;
        COMMIT;
        RETURN v_package_name;
    END;

    FUNCTION get_user_tariff(p_username UserCredentials.username%TYPE) RETURN Tariffs.tariff_name%TYPE AS
        v_tariff_name Tariffs.tariff_name%TYPE;
    BEGIN
        SELECT Tariffs.tariff_name INTO v_tariff_name 
        FROM UserCredentials 
        INNER JOIN Tariffs ON UserCredentials.tariff_id = Tariffs.tariff_id 
        WHERE UserCredentials.username = p_username;
        COMMIT;
        RETURN v_tariff_name;
    END;

    PROCEDURE create_user(S_USER_ID IN UserCredentials.user_id%TYPE, S_USERNAME IN UserCredentials.username%TYPE, S_PASSWORD IN UserCredentials.password%TYPE,
                          S_EMAIL IN UserCredentials.email%TYPE, P_PACKAGE_ID IN UserCredentials.package_id%TYPE, P_TARIFF_ID IN UserCredentials.tariff_id%TYPE) IS
    BEGIN
        INSERT INTO UserCredentials (user_id, username, password, email, package_id, tariff_id)
        VALUES (S_USER_ID, S_USERNAME, S_PASSWORD, S_EMAIL, P_PACKAGE_ID, P_TARIFF_ID);
        COMMIT;
    END create_user;

END package_customer;

/************************************************
*                                               *
*        TESTING PROCEDURES IN THE PACKAGE      *
*                                               *
************************************************/
DECLARE
    login_result NUMBER;
BEGIN
    login_result := package_customer.login('john_doe', 'password123');
    DBMS_OUTPUT.PUT_LINE('Login Result: ' || login_result);
END;
/
