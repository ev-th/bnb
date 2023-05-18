TRUNCATE TABLE users, listings, bookings RESTART IDENTITY;

INSERT INTO users (email, password) VALUES ('julian@example.com', '$2a$12$guLKLNOWT4/uR50y16qP8uoM13qqujQ/U6wxeE0EHIC9efxZ43tvy');
INSERT INTO users (email, password) VALUES ('andrea@example.com', '$2a$12$guLKLNOWT4/uR50y16qP8uoM13qqujQ/U6wxeE0EHIC9efxZ43tvy');

INSERT INTO listings (name, price, description, start_date, end_date, user_id) VALUES ('listing_1', 1000, 'sunny place', '2023-04-08', '2023-05-09', '1');
INSERT INTO listings (name, price, description, start_date, end_date, user_id) VALUES ('listing_2', 1500, 'city penthouse', '2024-05-03', '2024-06-23', '2');
INSERT INTO listings (name, price, description, start_date, end_date, user_id) VALUES ('listing_3', 1000000, 'shed in london', '2024-05-03', '2024-06-23', '2');
INSERT INTO listings (name, price, description, start_date, end_date, user_id) VALUES ('listing_4', 250, 'luxurious tent', '2024-05-03', '2024-06-23', '2');
INSERT INTO listings (name, price, description, start_date, end_date, user_id) VALUES ('listing_5', 3000, 'haunted house with friendly ghosts', '2024-05-03', '2024-06-23', '2');
INSERT INTO listings (name, price, description, start_date, end_date, user_id) VALUES ('listing_6', 1500, 'haunted house with mean ghosts', '2024-05-03', '2024-06-23', '1');

INSERT INTO bookings (date, confirmed, listing_id, user_id) VALUES ('2023-04-09', false, '1', '2');
INSERT INTO bookings (date, confirmed, listing_id, user_id) VALUES ('2023-04-10', false, '1', '2');
INSERT INTO bookings (date, confirmed, listing_id, user_id) VALUES ('2024-05-08', false, '2', '1');