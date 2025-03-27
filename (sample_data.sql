USE personal_finance_tracker;

-- Insert sample user
INSERT INTO Users (username, email, password_hash) VALUES 
('john_doe', 'john.doe@example.com', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8'); -- password: 'password'

-- Get the user ID
SET @user_id = LAST_INSERT_ID();

-- Insert custom payment methods
INSERT INTO Payment_Methods (name, description, user_id) VALUES
('Credit Card', 'VISA ending in 1234', @user_id),
('Debit Card', 'Bank debit card', @user_id),
('Cash', 'Physical cash', @user_id),
('Bank Transfer', 'Direct bank transfer', @user_id);

-- Insert custom category
INSERT INTO Categories (name, type, user_id) VALUES
('Side Hustle', 'income', @user_id);

-- Insert sample transactions (mixed income and expenses)
INSERT INTO Transactions (user_id, category_id, amount, date, description, method_id) VALUES
-- Income
(@user_id, 1, 3000.00, '2023-05-01', 'Monthly salary', NULL),
(@user_id, 2, 500.00, '2023-05-05', 'Freelance project', NULL),
(@user_id, 17, 200.00, '2023-05-10', 'Weekend gig', NULL), -- custom category
-- Expenses
(@user_id, 6, 150.75, '2023-05-02', 'Weekly groceries', 1),
(@user_id, 7, 120.50, '2023-05-03', 'Electricity bill', 2),
(@user_id, 11, 75.30, '2023-05-07', 'Dinner with friends', 1),
(@user_id, 9, 45.00, '2023-05-08', 'Bus pass', 3),
(@user_id, 10, 29.99, '2023-05-12', 'Netflix subscription', 2);

-- Insert savings goals
INSERT INTO Savings_Goals (user_id, name, target_amount, current_amount, target_date, description) VALUES
(@user_id, 'Emergency Fund', 5000.00, 1200.00, '2023-12-31', '3 months of living expenses'),
(@user_id, 'Vacation', 2000.00, 350.00, '2023-08-15', 'Summer trip to Europe');
