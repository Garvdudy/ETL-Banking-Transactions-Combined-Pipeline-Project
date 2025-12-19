-- Basic Querries
show databases;
use banking_transaction;
RENAME TABLE banking_transactions_working_sheet TO transactions;
describe transactions;
show tables;


-- checking the data
select
	max(transaction_amount) as highest_amount,
	min(transaction_amount) as lowest_amount
from transactions;


select count(*) as transactions_above_5k
from transactions
where transaction_amount > 5000;


select transaction_id, customer_last_name, transaction_amount, country_name, merchant
from transactions
where transaction_amount > 5000
order by transaction_amount desc
limit 20;


select count(*) as total_refunds
from transactions
where purchase_refund_tracking = 'Refund / Reversal';


select round(avg(transaction_amount), 2) as avg_transaction_amount
from transactions;


select count(*) as total_frauds
from transactions
where is_fraud = '1'; -- 0 means fine whereas 1 means fraud.


select country_name,
		round(sum(transaction_amount), 1) as total_amount
from transactions
group by country_name
order by total_amount desc;


select amount_bucket, count(transaction_amount) as total_transactions
from transactions
group by amount_bucket
order by total_transactions desc;


-- Update the column mount_bucket
select distinct amount_bucket
from transactions;

UPDATE transactions
SET amount_bucket = 'Refund'
WHERE (amount_bucket = '' OR amount_bucket IS NULL)
  AND transaction_amount < 0;


select card_type,
	round(avg(transaction_amount), 2) as avg_transaction
    from transactions
    group by card_type
    order by avg_transaction desc;


select country_name,
	count(*) as total_frauds
from transactions
where is_fraud = '1'
group by country_name
order by total_frauds desc;


select purchase_refund_tracking,
	count(*) as total_transaction,
    round(sum(transaction_amount),0) as total_anount
from transactions
group by purchase_refund_tracking;


select merchant,
	count(*) as total_transactions,
    round(sum(transaction_amount), 2) as total_sales
from transactions
group by merchant
order by total_sales desc
limit 10;


select country_name, channel,
	round(sum(transaction_amount), 2) as total_sales
from transactions
group by country_name, channel
order by total_sales desc;

SELECT 
    merchant_category,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_cases,
    ROUND(SUM(is_fraud)*100.0 / COUNT(*), 2) AS fraud_rate_percent,
    ROUND(AVG(risk_score), 2) AS avg_risk_score
FROM transactions
GROUP BY merchant_category
ORDER BY fraud_rate_percent DESC;