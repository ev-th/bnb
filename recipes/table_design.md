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
  price money,
  description text,
  start_date timestamp,
  end_date timestamp,
  user_id int,
  constraint fk_user foreign key(user_id)
    references users(id)
    on delete cascade
);

CREATE TABLE bookings (
  id SERIAL PRIMARY KEY,
  date timestamp,
  confirmation_status boolean,
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

<!-- BEGIN GENERATED SECTION DO NOT EDIT -->

---

**How was this resource?**  
[😫](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Ftwo_table_design_recipe_template.md&prefill_Sentiment=😫) [😕](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Ftwo_table_design_recipe_template.md&prefill_Sentiment=😕) [😐](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Ftwo_table_design_recipe_template.md&prefill_Sentiment=😐) [🙂](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Ftwo_table_design_recipe_template.md&prefill_Sentiment=🙂) [😀](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Ftwo_table_design_recipe_template.md&prefill_Sentiment=😀)  
Click an emoji to tell us.

<!-- END GENERATED SECTION DO NOT EDIT -->