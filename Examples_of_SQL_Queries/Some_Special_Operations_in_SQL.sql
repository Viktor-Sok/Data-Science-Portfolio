USE myflixdb;
SHOW TABLES;
-- set escape character for a wildcard
SELECT * FROM movies WHERE title LIKE '67o%%' ESCAPE 'o';
-- regular expressions to search for complex  patterns
SELECT * FROM `movies` WHERE `title` REGEXP '^[abc]';
-- built-in functions
SELECT ROUND(6.49);
-- user-defiened functions
DELIMITER //
CREATE FUNCTION sf_past_movie_return_date (return_date DATE)
  RETURNS VARCHAR(3)
   DETERMINISTIC
    BEGIN
     DECLARE sf_value VARCHAR(3);
        IF curdate() > return_date
            THEN SET sf_value = 'Yes';
        ELSEIF  curdate() <= return_date
            THEN SET sf_value = 'No';
        END IF;
     RETURN sf_value;
    END 
//
DELIMITER ;
-- creating views
CREATE VIEW `accounts_v_members` AS SELECT `membership_number`,`full_names`,`gender` FROM `members`;
-- creating index
CREATE INDEX title_index1 ON movies(title);
-- creating procedure
--#SET TERMINATOR @
CREATE PROCEDURE UPDATE_ICON (IN SID INTEGER, IN LS INTEGER)
LANGUAGE SQL
BEGIN

UPDATE CHICAGO_PUBLIC_SCHOOLS SET LEADERS_SCORE = LS WHERE SCHOOL_ID = SID;

IF LS > 0 AND LS < 20 THEN
UPDATE CHICAGO_PUBLIC_SCHOOLS
SET LEADERS_ICON = 'Very weak' WHERE SCHOOL_ID = SID;

ELSEIF LS < 40 THEN
UPDATE CHICAGO_PUBLIC_SCHOOLS
SET LEADERS_ICON = 'Weak' WHERE SCHOOL_ID = SID;

ELSEIF LS < 60 THEN
UPDATE CHICAGO_PUBLIC_SCHOOLS
SET LEADERS_ICON = 'Average' WHERE SCHOOL_ID = SID;


ELSEIF LS < 80 THEN
UPDATE CHICAGO_PUBLIC_SCHOOLS
SET LEADERS_ICON = 'Strong' WHERE SCHOOL_ID = SID;

ELSEIF LS < 100 THEN
UPDATE CHICAGO_PUBLIC_SCHOOLS
SET LEADERS_ICON = 'Very strong' WHERE SCHOOL_ID = SID;

END IF;
END
@
