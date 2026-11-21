SELECT
t.txn_id,
t.txn_datetime,
t.txn_type,
t.amount,
t.cashback_amount,
t.status,
u.user_id,
u.signup_date,
u.city,
u.gender,
u.birth_year,
u.acquisition_channel,
u.kyc_status,
m.merchant_id,
m.category,
m.city,
m.join_date,
m.merchant_name,
p.promo_id,
p.promo_name,
p.target,
p.start_date,
p.end_date,
p.cashback_persen,
p.maks_cashback,
p.min_transaksi
FROM `searadata-513813.sakunusa.transactions` AS t
LEFT JOIN `searadata-513813.sakunusa.users` AS u
  ON t.user_id = u.user_id
LEFT JOIN `searadata-513813.sakunusa.merchants` AS m
  ON t.merchant_id = m.merchant_id
LEFT JOIN `searadata-513813.sakunusa.promos` AS p
  ON t.promo_id = p.promo_id;

SELECT
  p.promo_id,
  p.promo_name,
  COUNT(t.txn_id) AS total_transaksi,
  SUM(t.amount) AS total_volume_rupiah,
  SUM(t.cashback_amount) AS total_pengeluaran_cashback,
  ROUND(SUM(t.amount) / NULLIF(SUM(t.cashback_amount), 0), 2) AS roi_multiplier
FROM `searadata-513813.sakunusa.transactions` AS t
JOIN `searadata-513813.sakunusa.promos` AS p
  ON t.promo_id = p.promo_id
WHERE t.status = 'Berhasil'
GROUP BY 1, 2
ORDER BY total_volume_rupiah DESC;

SELECT
  u.acquisition_channel,
  COUNT(DISTINCT u.user_id) AS total_user,
  COUNT(DISTINCT t.user_id) AS total_user_active,
  COUNT(t.txn_id) AS total_transaction,
  SUM(t.amount) AS total_volume_rupiah,
  ROUND(SUM(t.amount) / COUNT(DISTINCT u.user_id), 0) AS avg_volume_per_user
FROM `searadata-513813.sakunusa.users` AS u
LEFT JOIN `searadata-513813.sakunusa.transactions` AS t
  ON u.user_id = t.user_id AND t.status = 'Berhasil'
GROUP BY 1
ORDER BY total_volume_rupiah DESC;

SELECT
  m.category,
  COUNT(DISTINCT m.merchant_id) AS total_merchant,
  COUNT(t.txn_id) AS total_transaction,
  SUM(t.amount) AS total_volume_rupiah,
  ROUND(AVG(t.amount), 0) AS avg_transaction_value
FROM `searadata-513813.sakunusa.transactions` AS t
JOIN `searadata-513813.sakunusa.merchants` AS m
  ON t.merchant_id = m.merchant_id
WHERE t.status = 'Berhasil'
GROUP BY 1
ORDER BY total_volume_rupiah DESC;

