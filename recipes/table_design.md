# Two Tables Design Recipe Template

## 1. Extract nouns from the user stories or specification

```

Any signed-up user can list a new space.

Users can list multiple spaces.

Users should be able to name their space, 
provide a short description of the space, 
and a price per night.

Users should be able to offer a range of dates where their space is available.

Any signed-up user can request to hire any space for one night, 
and this should be approved by the user that owns that space.

Nights for which a space has already been booked 
should not be available for users to book that space.

Until a user has confirmed a booking request, 
that space can still be booked for that night.
```

## 4. Write the SQL.

```sql

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email text,
  password text
);

CREATE TABLE listings (
  id SERIAL PRIMARY KEY,
  name text,
  price float,
  description text,
  start_date DATE,
  end_date DATE,
  user_id int,
  constraint fk_user foreign key(user_id)
    references users(id)
    on delete cascade
);

CREATE TABLE bookings (
  id SERIAL PRIMARY KEY,
  date DATE,
  confirmed boolean,
  listing_id integer,
  user_id integer,
  constraint fk_user foreign key(user_id)
    references users(id)
    on delete cascade,
  constraint fk_listing foreign key(listing_id)
    references listings(id)
    on delete cascade
);

```

```
TRUNCATE TABLE users, listings, bookings RESTART IDENTITY;

INSERT INTO users (email, password) VALUES ('julian@gmail.com', 'asdasd');
INSERT INTO users (email, password) VALUES ('andrea@gmail.com', 'dsadsa');

INSERT INTO listings (name, price, description, start_date, end_date, user_id) VALUES ('listing_1', '1,000.00', 'sunny place', '2023-04-08', '2023-05-09', '1');
INSERT INTO listings (name, price, description, start_date, end_date, user_id) VALUES ('listing_2', '1,500.00', 'city penthouse', '2024-05-03', '2024-06-23', '2');

INSERT INTO bookings (date, confirmed, listing_id, user_id) VALUES ('2023-04-09', false, '1', '2');
INSERT INTO bookings (date, confirmed, listing_id, user_id) VALUES ('2023-04-10', false, '1', '2');
INSERT INTO bookings (date, confirmed, listing_id, user_id) VALUES ('2024-05-08', false, '2', '1');
```


<!-- BEGIN GENERATED SECTION DO NOT EDIT -->

---

**How was this resource?**  
[😫](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Ftwo_table_design_recipe_template.md&prefill_Sentiment=😫) [😕](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Ftwo_table_design_recipe_template.md&prefill_Sentiment=😕) [😐](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Ftwo_table_design_recipe_template.md&prefill_Sentiment=😐) [🙂](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Ftwo_table_design_recipe_template.md&prefill_Sentiment=🙂) [😀](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Ftwo_table_design_recipe_template.md&prefill_Sentiment=😀)  
Click an emoji to tell us.

<!-- END GENERATED SECTION DO NOT EDIT -->