CREATE TABLE goods_groups(
  id SERIAL, 
  name VARCHAR(255), 
  PRIMARY KEY(id)
);
CREATE TABLE partners(
  id SERIAL, 
  name VARCHAR(255), 
  PRIMARY KEY(id)
);
CREATE TABLE goods(
  id SERIAL, 
  name VARCHAR(255), 
  group_id INT REFERENCES goods_groups(id), 
  PRIMARY KEY(id)
);
CREATE TABLE price_list(
  id SERIAL, 
  name VARCHAR(255), 
  PRIMARY KEY(id)
);
CREATE TABLE price_list_prices(
  id SERIAL, 
  ddate DATE, 
  price_id INT REFERENCES price_list(id), 
  value DECIMAL(18, 4), 
  PRIMARY KEY(id)
);
CREATE TABLE partners_goods_groups(
  id SERIAL, 
  name VARCHAR(255), 
  PRIMARY KEY(id)
);
CREATE TABLE partners_goods_links(
  id SERIAL, 
  partner_group_id INT REFERENCES partners_goods_groups(id), 
  group_id INT REFERENCES goods_groups(id), 
  PRIMARY KEY(id)
);
CREATE TABLE partners_goods_prices(
  id SERIAL, 
  group_id INT REFERENCES partners_goods_groups(id), 
  price_id INT REFERENCES price_list(id), 
  partner_id INT REFERENCES partners(id), 
  PRIMARY KEY(id)
);

INSERT INTO goods_groups(name) 
SELECT 
  'group ' || floor(
    random() * 100 + 1
  ):: varchar(255) 
FROM 
  generate_series(1, 6);
INSERT INTO partners(name) 
SELECT 
  'group ' || floor(
    random() * 100 + 1
  ):: varchar(255) 
FROM 
  generate_series(1, 2);
INSERT INTO price_list(name) 
SELECT 
  'price ' || floor(
    random() * 100 + 1
  ):: varchar(255) 
FROM 
  generate_series(1, 6);
INSERT INTO goods(name, group_id) 
SELECT 
  t1.name, 
  t2.id 
FROM 
  (
    SELECT 
      'good ' || floor(
        random() * 100 + 1
      ):: varchar(255) AS name, 
      ROW_NUMBER() OVER() r_id 
    FROM 
      generate_series(1, 100)
  ) t1 
  INNER JOIN (
    SELECT 
      ROW_NUMBER() OVER() r_id, 
      t.id 
    FROM 
      (
        SELECT 
          id 
        FROM 
          goods_groups CROSS 
          JOIN generate_series(1, 1000) 
        ORDER BY 
          random()
      ) t
  ) t2 ON t1.r_id = t2.r_id;
INSERT INTO price_list_prices(ddate, value, price_id) 
SELECT 
  t1.dat, 
  ROUND(
    AVG(t1.val)
  ) AS val, 
  t2.id 
FROM 
  (
    SELECT 
      DATE(
        NOW() + (
          random() * (NOW() + '90 days' - NOW())
        ) + '30 days'
      ) AS dat, 
      floor(
        random() * 1000 + 1
      ):: INT AS val, 
      ROW_NUMBER() OVER() r_id 
    FROM 
      generate_series(1, 100)
  ) t1 
  INNER JOIN (
    SELECT 
      ROW_NUMBER() OVER() r_id, 
      t.id 
    FROM 
      (
        SELECT 
          id 
        FROM 
          price_list CROSS 
          JOIN generate_series(1, 1000) 
        ORDER BY 
          random()
      ) t
  ) t2 ON t1.r_id = t2.r_id 
GROUP BY 
  t2.id, 
  t1.dat;
INSERT INTO partners_goods_groups(name) 
SELECT 
  'partner group ' || floor(
    random() * 100 + 1
  ):: varchar(255) 
FROM 
  generate_series(1, 3);
INSERT INTO partners_goods_links(partner_group_id, group_id) 
SELECT 
  DISTINCT t1.id, 
  t2.id 
FROM 
  (
    SELECT 
      ROW_NUMBER() OVER() AS r_id, 
      id 
    FROM 
      partners_goods_groups
  ) t1 
  INNER JOIN (
    SELECT 
      ROW_NUMBER() OVER() r_id, 
      t.id 
    FROM 
      (
        SELECT 
          id 
        FROM 
          goods_groups CROSS 
          JOIN generate_series(1, 7) 
        ORDER BY 
          random()
      ) t
  ) t2 ON (
    (t2.r_id % t1.r_id = 0) 
    AND (t1.r_id != 1)
  ) 
  OR (t1.r_id = t2.r_id);
INSERT INTO partners_goods_prices(group_id, partner_id, price_id) 
SELECT 
  p_group_id, 
  p_id, 
  price_id 
FROM 
  (
    SELECT 
      t4.row_id, 
      t4.p_group_id, 
      t4.p_id, 
      t5.id AS price_id 
    FROM 
      (
        SELECT 
          ROW_NUMBER() OVER() row_id, 
          t3.p_group_id, 
          t3.p_id 
        FROM 
          (
            SELECT 
              DISTINCT t1.id AS p_group_id, 
              t2.id AS p_id 
            FROM 
              (
                SELECT 
                  ROW_NUMBER() OVER() AS r_id, 
                  id 
                FROM 
                  partners_goods_groups
              ) t1 
              INNER JOIN (
                SELECT 
                  ROW_NUMBER() OVER() r_id, 
                  t.id 
                FROM 
                  (
                    SELECT 
                      id 
                    FROM 
                      partners CROSS 
                      JOIN generate_series(1, 7) 
                    ORDER BY 
                      random()
                  ) t
              ) t2 ON (
                (t2.r_id % t1.r_id = 0) 
                AND (t1.r_id != 1)
              ) 
              OR (t1.r_id = t2.r_id)
          ) t3
      ) t4 
      INNER JOIN (
        SELECT 
          ROW_NUMBER() OVER() r_id2, 
          id 
        FROM 
          price_list
      ) t5 ON t5.r_id2 = t4.row_id
  ) t7;


SELECT 
  (t.cnt > 1) AS if_not_crosses 
FROM 
  (
    SELECT 
      price_id, 
      partner_id, 
      count(*) AS cnt 
    FROM 
      partners_goods_prices 
    GROUP BY 
      partner_id, 
      price_id
  ) t 
GROUP BY 
  t.cnt;


SELECT 
  t1.id, 
  t1.ddate, 
  t1.price_id, 
  t1.value 
FROM 
  price_list_prices t1 
  INNER JOIN (
    SELECT 
      price_id, 
      MAX(ddate) AS ddate 
    FROM 
      price_list_prices 
    WHERE 
      price_id IN (
        SELECT 
          price_id 
        FROM 
          partners_goods_prices 
        WHERE 
          partner_id = 8
      ) 
    GROUP BY 
      price_id
  ) t ON (t.price_id = t1.price_id) 
  AND (t.ddate = t1.ddate) 
WHERE 
  t1.ddate >= '2019-06-26';
