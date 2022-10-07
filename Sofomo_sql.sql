
WITH A (dimension_1 , dimension_2 , dimension_3 , measure_1)  AS
(SELECT 'a' , 'I' , 'K' , 1  UNION ALL
SELECT 'a' , 'J' , 'L' , 7 UNION ALL
SELECT  'b', 'I', 'M', 2 UNION ALL
SELECT 'c', 'J', 'N', 5),

B (dimension_1 , dimension_2, measure_2) AS
(SELECT 'a' , 'J'  , 7  UNION ALL
SELECT 'b' , 'J'  , 10 UNION ALL
SELECT  'd', 'J', 4 ),

MAP (dimension_1 , correct_dimension_2) AS
(SELECT 'a' , 'W'   UNION ALL
SELECT 'a' , 'W' UNION ALL
SELECT  'b', 'X' UNION ALL
SELECT  'c', 'Y' UNION ALL
SELECT  'b', 'X' UNION ALL
SELECT  'd', 'Z' ),

A_MAPPED AS
(SELECT A.dimension_1, any_value(MAP.correct_dimension_2) dimension_2, A.dimension_3, measure_1
FROM A 
LEFT JOIN MAP USING (dimension_1)
GROUP BY A.dimension_1,  A.dimension_3, measure_1),

B_MAPPED AS
(SELECT B.dimension_1, any_value(MAP.correct_dimension_2) dimension_2, B.measure_2
FROM B 
LEFT JOIN MAP USING (dimension_1)
GROUP BY B.dimension_1, measure_2),

A_AGG AS
(SELECT dimension_1, dimension_2, sum(measure_1) measure_1
FROM A_MAPPED
GROUP BY dimension_1, dimension_2)


SELECT
dimension_1,
dimension_2,
ifnull(measure_1,0) measure_1,
ifnull(measure_2,0) measure_2
FROM A_AGG
FULL JOIN B_MAPPED USING (dimension_1,dimension_2)