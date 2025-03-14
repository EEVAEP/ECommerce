DELIMITER $$
USE shoppingcart $$
DROP PROCEDURE IF EXISTS spPlaceOrderDetails $$
CREATE PROCEDURE spPlaceOrderDetails(
	userId INT,
    addressId INT,
    cardPart VARCHAR(4),
    productId INT,
    quantity INT,
    phonenumber VARCHAR(10)
)
BEGIN
	DECLARE orderId VARCHAR(64);
    DECLARE totalPrice DECIMAL(10,2);
    DECLARE totalTax DECIMAL(10,2);
    DECLARE unitPrice DECIMAL(10,2);
    DECLARE unitTax DECIMAL(10,2);
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
	BEGIN 
    ROLLBACK;
	END;
    
	START TRANSACTION;
	SET orderId = UUID();
    IF productId = -1 THEN
		SELECT
			ROUND(SUM(TC.fldQuantity * (P.fldPrice + (P.fldPrice * P.fldTax) / 100)), 2) ,
			ROUND(SUM(TC.fldQuantity * ((P.fldPrice * P.fldTax) / 100)), 2)
		INTO 
			totalPrice,
            totalTax
		FROM
			tblCart AS TC
			INNER JOIN tblProduct AS P ON TC.fldProductId = P.fldProduct_ID
		WHERE
			TC.fldUserId = userId
			AND TC.fldQuantity > 0;
        
		INSERT INTO tblOrder(
			fldOrder_ID,
			fldUserId,
			fldAddressId,
			fldTotalPrice,
			fldTotalTax,
            fldPhonenumber,
			fldOrderDate,
            fldCardPart
		)VALUES(
			orderId,
			userId,
			addressId,
			totalPrice,
			totalTax,
            phonenumber,
            NOW(),
			cardPart
			);

		INSERT INTO tblOrderItems(
			fldOrderId,
			fldProductId,
			fldQuantity,
			fldUnitPrice,
			fldUnitTax
		)
		SELECT 
			orderId,
			TC.fldProductId,
			TC.fldQuantity,
			P.fldPrice,
			P.fldTax
		FROM
			tblCart AS TC
			INNER JOIN tblProduct AS P ON TC.fldProductId = P.fldProduct_ID
		WHERE
			TC.fldUserId = userId
			AND TC.fldQuantity > 0 ;
		DELETE FROM tblCart WHERE fldUserId = userId;    
    ELSE 
		SELECT 
			fldPrice,
            fldTax,
            (quantity)*(fldPrice+(fldPrice*fldTax)/100) AS totalPrice,
            (quantity)*(fldPrice*fldTax)/100 AS totalTax
		INTO 
			unitPrice,
            unitTax,
            totalPrice,
            totalTax
		FROM 
			tblProduct
		WHERE 
			fldProduct_ID = productId ;
		INSERT INTO tblOrder(
			fldOrder_ID,
			fldUserId,
			fldAddressId,
			fldTotalPrice,
			fldTotalTax,
			fldPhonenumber,
			fldOrderDate,
            fldCardPart
		)VALUES(
			orderId,
			userId,
			addressId,
			totalPrice,
			totalTax,
			 phonenumber,
            NOW(),
			cardPart
		);
		INSERT INTO tblOrderItems(
			fldOrderId,
			fldProductId,
			fldQuantity,
			fldUnitPrice,
			fldUnitTax
		)VALUES(
			orderId,
			productId,
			quantity,
			unitPrice,
			unitTax
		);
	END IF ;
    COMMIT ;
    SELECT orderId AS OrderId;
END $$
DELIMITER ;

