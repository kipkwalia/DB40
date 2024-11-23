-- Database: housing_management_system
CREATE DATABASE Housing;
USE Housing;

-- 1. Users table (for both applicants and staff)
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('applicant', 'staff') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Applicants table
CREATE TABLE Applicants (
    applicant_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    income DECIMAL(10, 2),
    family_size INT,
    employment_status VARCHAR(50),
    background_check_status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- 3. Housing Units table
CREATE TABLE HousingUnits (
    unit_id INT PRIMARY KEY AUTO_INCREMENT,
    unit_type VARCHAR(50) NOT NULL,
    location VARCHAR(100),
    size_sqft INT,
    rent_amount DECIMAL(10, 2),
    status ENUM('available', 'occupied', 'maintenance') DEFAULT 'available'
);

-- 4. Applications table
CREATE TABLE Applications (
    application_id INT PRIMARY KEY AUTO_INCREMENT,
    applicant_id INT NOT NULL,
    unit_id INT NOT NULL,
    application_date DATE DEFAULT CURRENT_DATE,
    status ENUM('submitted', 'in_review', 'approved', 'rejected', 'waitlisted') DEFAULT 'submitted',
    FOREIGN KEY (applicant_id) REFERENCES Applicants(applicant_id) ON DELETE CASCADE,
    FOREIGN KEY (unit_id) REFERENCES HousingUnits(unit_id) ON DELETE SET NULL
);

-- 5. Leases table
CREATE TABLE Leases (
    lease_id INT PRIMARY KEY AUTO_INCREMENT,
    application_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    lease_terms TEXT,
    lease_status ENUM('active', 'terminated', 'expired') DEFAULT 'active',
    FOREIGN KEY (application_id) REFERENCES Applications(application_id) ON DELETE CASCADE
);

-- 6. Payments table
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    lease_id INT,
    applicant_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date DATE DEFAULT CURRENT_DATE,
    payment_type ENUM('rent', 'deposit', 'late_fee', 'other') NOT NULL,
    status ENUM('pending', 'completed', 'failed') DEFAULT 'completed',
    FOREIGN KEY (lease_id) REFERENCES Leases(lease_id) ON DELETE SET NULL,
    FOREIGN KEY (applicant_id) REFERENCES Applicants(applicant_id) ON DELETE SET NULL
);

-- 7. Waitlist table (optional for managing waitlisted applicants)
CREATE TABLE Waitlist (
    waitlist_id INT PRIMARY KEY AUTO_INCREMENT,
    applicant_id INT NOT NULL,
    unit_id INT NOT NULL,
    added_date DATE DEFAULT CURRENT_DATE,
    status ENUM('waiting', 'notified', 'removed') DEFAULT 'waiting',
    FOREIGN KEY (applicant_id) REFERENCES Applicants(applicant_id) ON DELETE CASCADE,
    FOREIGN KEY (unit_id) REFERENCES HousingUnits(unit_id) ON DELETE CASCADE
);

-- 8. Notifications table (optional for managing communication with applicants)
CREATE TABLE Notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    applicant_id INT,
    lease_id INT,
    message TEXT NOT NULL,
    sent_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('sent', 'pending', 'failed') DEFAULT 'sent',
    FOREIGN KEY (applicant_id) REFERENCES Applicants(applicant_id) ON DELETE SET NULL,
    FOREIGN KEY (lease_id) REFERENCES Leases(lease_id) ON DELETE SET NULL
);

-- 9. Audit Logs table (optional for compliance and tracking)
CREATE TABLE AuditLogs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    action VARCHAR(255) NOT NULL,
    user_id INT,
    action_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    details TEXT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE SET NULL
);
