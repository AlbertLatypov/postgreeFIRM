WITH RECURSIVE r AS (
   SELECT id, par_id
   FROM drevo

   UNION

   SELECT drevo.id, drevo.par_id
   FROM drevo
      JOIN r
          ON drevo.par_id = r.id
)

SELECT * FROM r;
