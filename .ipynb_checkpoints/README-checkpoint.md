# challenge-7

"sql query
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
- isolate (or group) the transactions
CREATE VIEW cardholder_transactions AS
SELECT ch.id AS cardholder_id, c.card AS credit_card, t.id AS transaction_id, t.amount
FROM card_holder ch
JOIN credit_card c ON ch.id = c.cardholder_id
JOIN transaction t ON c.card = t.card;

-- transactions that are less than $2.00 per cardholder
CREATE VIEW small_transactions_per_cardholder AS
SELECT cht.cardholder_id, COUNT(*) AS small_transaction_count
FROM cardholder_transactions cht
WHERE cht.amount < 2.00
GROUP BY cht.cardholder_id;

-- top 100 highest transactions made between 7:00 am and 9:00 am
CREATE VIEW top_100_transactions_7_to_9 AS
SELECT *
FROM transaction
WHERE date_part('hour', date) >= 7 AND date_part('hour', date) < 9
ORDER BY amount DESC
LIMIT 100;

-- Fraudulent Transactions Across Time Frames to find comparision
CREATE VIEW fraudulent_transactions_timeframe AS
SELECT date_part('hour', date) AS hour, COUNT(*) AS fraudulent_transactions_count
FROM transaction
WHERE amount < 2.00
GROUP BY date_part('hour', date)
ORDER BY hour;

-- top 5 merchants prone to being hacked using small transactions
CREATE VIEW top_5_hacked_merchants AS
SELECT m.name AS merchant_name, COUNT(*) AS small_transaction_count
FROM transaction t
JOIN merchant m ON t.id_merchant = m.id
WHERE t.amount < 2.00
GROUP BY m.name
ORDER BY small_transaction_count DESC
LIMIT 5;

-- for python
CREATE VIEW transaction_view AS
SELECT 
    t.id AS transaction_id,
    t.date AS transaction_date,
    t.amount AS transaction_amount,
    c.card AS credit_card_number,
    c.cardholder_id
FROM 
    transaction t
JOIN 
    credit_card c ON t.card = c.card;"

## Is there any evidence to suggest that a credit card has been hacked? Explain your rationale?

Yes, Becaause of the fact that there are more <2& transactions.

## What are the top 100 highest transactions made between 7:00 am and 9:00 am?

transaction ID 3163, 2451, 2840, 1442 are biggest

## Do you see any anomalous transactions that could be fraudulent?

yes the top transactions are of greater Monetary value compared to other where it is lower than 50$

## Is there a higher number of fraudulent transactions made during this time frame versus the rest of the day?

Yes

## If you answered yes to the previous question, explain why you think there might be fraudulent transactions during this time frame.

I think this because there are lot of <2$ transactions form the same card id.

## What are the top 5 merchants prone to being hacked using small transactions?

"Wood-Ramirez","Hood-Phillips","Baker Inc","Mcdaniel, Hines and Mcfarland","Hamilton-Mcfarland".

!["entity relationship diagram"](ERD.png)

# Part 2

## plots of cardholder id 2 and 18:

!["card holder 2"](card_holder_2.png)

!["card holder 18"](card_holder_18.png)

## combined plot

!["card holder 18 and 2"](card_holder_2and18.png)

yes it the pattern suggest a fradulent transaction. because of the sudden spikes in transaction.

## plot for card holder 25

!["card holder 25"](boxplot.png)

Yes I do see anomalies in the box plot where there are transactions in greater amounts and large number of less then 50$ transactions.