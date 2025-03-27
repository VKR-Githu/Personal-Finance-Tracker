-- Create database
CREATE DATABASE IF NOT EXISTS personal_finance_tracker;
USE personal_finance_tracker;

-- Users table
CREATE TABLE IF NOT EXISTS Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Categories table
CREATE TABLE IF NOT EXISTS Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    type ENUM('income', 'expense') NOT NULL,
    user_id INT NULL, -- NULL means it's a default category
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Payment Methods table
CREATE TABLE IF NOT EXISTS Payment_Methods (
    method_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Transactions table
CREATE TABLE IF NOT EXISTS Transactions (
    trans_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    category_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    date DATE NOT NULL,
    description VARCHAR(255),
    method_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id),
    FOREIGN KEY (method_id) REFERENCES Payment_Methods(method_id)
) ENGINE=InnoDB;

-- Savings Goals table
CREATE TABLE IF NOT EXISTS Savings_Goals (
    goal_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    target_amount DECIMAL(10, 2) NOT NULL,
    current_amount DECIMAL(10, 2) DEFAULT 0,
    target_date DATE,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Create indexes for performance
CREATE INDEX idx_transactions_user_date ON Transactions(user_id, date);
CREATE INDEX idx_transactions_user_category ON Transactions(user_id, category_id);
CREATE INDEX idx_savings_goals_user ON Savings_Goals(user_id);

-- Insert default categories
INSERT IGNORE INTO Categories (name, type) VALUES
-- Income categories
('Salary', 'income'),
('Freelance', 'income'),
('Investments', 'income'),
('Gifts', 'income'),
('Other Income', 'income'),
-- Expense categories
('Groceries', 'expense'),
('Utilities', 'expense'),
('Rent', 'expense'),
('Transportation', 'expense'),
('Entertainment', 'expense'),
('Dining Out', 'expense'),
('Healthcare', 'expense'),
('Education', 'expense'),
('Shopping', 'expense'),
('Other Expense', 'expense');

-- Create application user with limited privileges
CREATE USER IF NOT EXISTS 'finance_app'@'localhost' IDENTIFIED BY 'securepassword123';
GRANT SELECT, INSERT, UPDATE, DELETE ON personal_finance_tracker.* TO 'finance_app'@'localhost';
FLUSH PRIVILEGES;
