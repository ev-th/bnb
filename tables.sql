
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email text,
  password text
);

CREATE TABLE listings (
  id SERIAL PRIMARY KEY,
  name text,
  price integer,
  description text,
  start_date DATE,
  end_date DATE,
  user_id integer,
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
