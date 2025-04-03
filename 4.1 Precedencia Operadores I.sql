/*
SGDB: MySQL
Programador: Angie M. Ibarrola Valenzuela
Fecha: Jan 17, 2025
Script: Precedencia Operadores SQL I 
*/

-- 1.
SELECT 10 * 2 + 5;
	SELECT (10 * 2) + 5;
	SELECT 20 + 5;
	SELECT 25;

-- 2.
SELECT 12 / 3 + 2 + 10 * 2 % 5;
	SELECT (12 / 3) + 2 + ((10 * 2) % 5);
	SELECT 4 + 2 + (20 % 5);
	SELECT 4 + 2 + 0;
	SELECT 6;

-- 3.
SELECT 2 + 3 < 5 OR 2 * 3 = 6;
	SELECT (2 + 3) < 5 OR (2 * 3) = 6;
	SELECT (5 < 5) OR (6 = 6);
	SELECT 0 OR 1;
	SELECT 1;

-- 4.
SELECT 5 * 2 > 10 AND NOT 3 + 2 = 5;
	SELECT (5 * 2) > 10 AND (NOT ((3 + 2) = 5));
	SELECT 0 AND (NOT (5 = 5));
	SELECT 0 AND (NOT 1);
	SELECT 0 AND 0;
	SELECT 0;

-- 5.
SELECT 15 MOD 4 = 0 AND 20 DIV 3 < 7;
	SELECT (15 MOD 4) = 0 AND (20 DIV 3) < 7;
	SELECT (3 = 0) AND (6 < 7);
	SELECT 0 AND 1;
	SELECT 0;
