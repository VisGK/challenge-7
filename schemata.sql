CREATE TABLE card_holder (
  id INT NOT NULL,
  name VARCHAR(255) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE credit_card (
  card VARCHAR NOT NULL,
  cardholder_id INT NOT NULL,
  PRIMARY KEY (card),
  FOREIGN KEY (cardholder_id) REFERENCES card_holder(id)
);

CREATE TABLE merchant_category (
  id INT NOT NULL,
  name VARCHAR(255) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE merchant (
  id INT NOT NULL,
  name VARCHAR(255) NOT NULL,
  id_merchant_category INT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (id_merchant_category) REFERENCES merchant_category(id)
);

CREATE TABLE transaction (
  id INT NOT NULL,
  date TIMESTAMP NOT NULL,
  amount float NOT NULL,
  card VARCHAR NOT NULL,
  id_merchant INT NOT NULL,
  PRIMARY KEY (id, card, id_merchant),
  FOREIGN KEY (card) REFERENCES credit_card(card),
  FOREIGN KEY (id_merchant) REFERENCES merchant(id)
);
