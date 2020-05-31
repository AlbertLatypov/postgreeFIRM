
SELECT
end_dates_t.end_date,
t1_t2.t1_ddate,
t1_t2.t1_stor,
t1_t2.t1_good,
t1_t2.t1_vol,
t1_t2.t2_vol
INTO daily_count_table
FROM
  (SELECT
    t1.t1_stor, t1.t1_ddate, t1.t1_good, t1.t1_vol, t2.t2_vol
  FROM (SELECT
            income.STORAGE t1_stor,
            income.ddate t1_ddate,
            incgoods.goods t1_good,
            SUM(incgoods.volume) t1_vol
        FROM
            income JOIN incgoods ON income.id=incgoods.id
        GROUP BY
            income.STORAGE, income.ddate, incgoods.goods) AS t1
        FULL OUTER JOIN
        (SELECT
            recept.STORAGE t2_stor,
            recept.ddate t2_ddate,
            recgoods.goods t2_good,
            SUM(recgoods.volume) t2_vol
        FROM
            recept JOIN recgoods ON recept.id=recgoods.id
        GROUP BY
            recept.STORAGE, recept.ddate, recgoods.goods) AS t2
        ON t1.t1_ddate=t2.t2_ddate
  WHERE
      t1_stor=t2_stor AND t1_good=t2_good) AS t1_t2
  CROSS JOIN
    (SELECT end_date
    FROM GENERATE_SERIES('2020-03-01'::DATE, '2020-03-14', '1 day') end_date) AS end_dates_t;
     
 
     
   
   
SELECT DISTINCT (
    outer_t.end_date,  
    outer_t.t1_stor,
    outer_t.t1_good,
    (SELECT
        SUM(inner_t.t1_vol-inner_t.t2_vol)
    FROM
        daily_count_table AS inner_t
    WHERE
        inner_t.t1_ddate < outer_t.end_date
        AND inner_t.t1_stor = outer_t.t1_stor
        AND inner_t.t1_good = outer_t.t1_good
    ))
FROM daily_count_table AS outer_t;
