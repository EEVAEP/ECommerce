DELIMITER $$
USE `shoppingcart`$$
DROP PROCEDURE IF EXISTS `spGetUserProfileDetails`$$
CREATE PROCEDURE spGetUserProfileDetails(p_UserID INT)
BEGIN
    SELECT 
        fldUser_ID,
        fldFirstname, 
        fldLastname,
        fldEmail,
        fldPhone,
        CONCAT(fldFirstname, ' ', fldLastname) AS fullname
    FROM 
        tblUser
    WHERE 
        fldUser_ID = p_UserID;
END $$
DELIMITER ;