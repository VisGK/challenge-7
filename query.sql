-- isolate (or group) the transactions
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
    credit_card c ON t.card = c.card;