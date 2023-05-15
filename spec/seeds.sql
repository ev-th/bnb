TRUNCATE TABLE users, listings, bookings RESTART IDENTITY;

INSERT INTO users (email, password) VALUES ('julian@example.com', 'asdasd');
INSERT INTO users (email, password) VALUES ('andrea@example.com', 'dsadsa');

INSERT INTO listings (name, price, description, start_date, end_date, user_id) VALUES ('listing_1', '1,000.00', 'sunny place', '2023-04-08', '2023-05-09', '1');
INSERT INTO listings (name, price, description, start_date, end_date, user_id) VALUES ('listing_2', '1,500.00', 'city penthouse', '2024-05-03', '2024-06-23', '2');

INSERT INTO bookings (date, confirmed, listing_id, user_id) VALUES ('2023-04-09', false, '1', '2');
INSERT INTO bookings (date, confirmed, listing_id, user_id) VALUES ('2023-04-10', false, '1', '2');
INSERT INTO bookings (date, confirmed, listing_id, user_id) VALUES ('2024-05-08', false, '2', '1');