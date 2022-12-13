﻿-- CAU 1: Tao csdl QLHANG gồm 3 bang
CREATE DATABASE QLHANG
GO
USE QLHANG
GO

CREATE TABLE VATTU(
    MAVT varchar(10) PRIMARY KEY, 
    TENVT nvarchar(50),
    DVTINH nvarchar(50),
    SLCON INT
);

CREATE TABLE HDBAN(
    MAHD varchar(10) PRIMARY KEY, 
    NGAYXUAT DATE,
    HOTENKHACH nvarchar(50)
);

CREATE TABLE HANGXUAT(
    MAHD varchar(10),
    MAVT varchar(10),
    DONGIA INT,
    SLBAN INT,
    CONSTRAINT HANGXUAT_PK PRIMARY KEY (MAHD, MAVT)
);

ALTER TABLE HANGXUAT ADD CONSTRAINT FK_HANGXUAT_HDBAN
FOREIGN KEY (MAHD) REFERENCES HDBAN (MAHD);
ALTER TABLE HANGXUAT ADD CONSTRAINT FK_HANGXUAT_VATTU
FOREIGN KEY (MAVT) REFERENCES VATTU (MAVT);

INSERT INTO VATTU VALUES
('VT01', 'GACH', 'VIEN', 100000),
('VT02', 'XI-MANG', 'BAO', 3000);

INSERT INTO HDBAN VALUES
('HD01', '2022-11-18', 'TRAN NGUYEN VAN CONG'),
('HD02', '2022-6-28', 'CHAU HOANG TUNG');

INSERT INTO HANGXUAT VALUES
('HD01', 'VT01', 7000, 500),
('HD01', 'VT02', 35000, 30),
('HD02', 'VT01', 7200, 100),
('HD02', 'VT02', 38000, 40);


-- CAU 2: Dua ra hoa don co tong tien vat tu nhieu nhat
SELECT TOP 1
MAHD, SUM(SLBAN * DONGIA) AS N'Tổng Tiền'
FROM HANGXUAT
GROUP BY MAHD
ORDER BY SUM(SLBAN * DONGIA) Desc;

-- CAU 3: Viet ham voi tham so truyen vao
go
CREATE FUNCTION f3 (
    @MAHD varchar(10)
)
RETURNS TABLE
AS
RETURN
    SELECT 
        HX.MAHD,
        HD.NGAYXUAT,
        HX.MAVT,
        HX.DONGIA,
        HX.SLBAN,  
        CASE
            WHEN DATENAME(dw,HD.NGAYXUAT) = 'Monday' THEN N'Thứ hai'            
            WHEN DATENAME(dw,HD.NGAYXUAT) = 'Tuesday' THEN N'Thứ ba'
            WHEN DATENAME(dw,HD.NGAYXUAT) = 'Wednesday' THEN N'Thứ tư'
            WHEN DATENAME(dw,HD.NGAYXUAT) = 'Thursday' THEN N'Thứ năm'
            WHEN DATENAME(dw,HD.NGAYXUAT) = 'Friday' THEN N'Thứ sáu'
            WHEN DATENAME(dw,HD.NGAYXUAT) = 'Saturday' THEN N'Thứ bảy'
            ELSE N'Chủ nhật'
        END AS NGAYTHU  
    FROM HANGXUAT HX
    INNER JOIN HDBAN HD ON HX.MAHD = HD.MAHD
    WHERE HX.MAHD = @MAHD;
go
-- CAU 4: Tao thu tuc luu tru in ra tong tien vat tu xuat theo thang va nam
CREATE PROCEDURE p4 
@thang int, @nam int 
AS
SELECT 
SUM(SLBAN * DONGIA)
FROM HANGXUAT HX
INNER JOIN HDBAN HD ON HX.MAHD = HD.MAHD
where MONTH(HD.NGAYXUAT) = @THANG AND YEAR(HD.NGAYXUAT) = @NAM;