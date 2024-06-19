--- Tạo Database
CREATE DATABASE BTLSQL;
GO
---  gọi và sử dụng database vừa tạo
USE BTLSQL;
GO

--- Tạo Bảng VatTu
CREATE TABLE VatTu
(
    ID INT IDENTITY(1,1) PRIMARY KEY,
    MaVT NVARCHAR(50) NOT NULL UNIQUE,
    TenVT NVARCHAR(50) NOT NULL,
    DVT NVARCHAR(50) NOT NULL,
    SLHangCon INT NOT NULL
);
GO

--- Tạo Bảng HoaDonBan
CREATE TABLE HoaDonBan
(
    ID INT IDENTITY(1,1) PRIMARY KEY,
    MaHD NVARCHAR(50) NOT NULL UNIQUE,
    NgayXuat DATE NOT NULL,
    HoTenKH NVARCHAR(50) NOT NULL,
    DiaChiKH NVARCHAR(100)
);
GO

--- Tạo Bảng HangXuat
CREATE TABLE HangXuat
(
    ID INT IDENTITY(1,1) PRIMARY KEY,
    MaHD NVARCHAR(50) NOT NULL,
    MaVT NVARCHAR(50) NOT NULL,
    DonGia INT NOT NULL,
    SLBan INT NOT NULL,
    FOREIGN KEY(MaHD) REFERENCES HoaDonBan(MaHD) ON DELETE CASCADE,
    FOREIGN KEY(MaVT) REFERENCES VatTu(MaVT) ON DELETE CASCADE
);
GO
CREATE TABLE DatHangLai
(
    ID INT IDENTITY(1,1) PRIMARY KEY,
    MaVT NVARCHAR(50) NOT NULL,
    TenVT NVARCHAR(50) NOT NULL,
    SLHangCon INT NOT NULL,
    NgayDatHangLai DATE DEFAULT GETDATE()
);
GO

CREATE TABLE CauHinh
(
    ThamSo NVARCHAR(50) PRIMARY KEY,
    GiaTri INT
);
-- Thêm ngưỡng kiểm tra vào bảng cấu hình
INSERT INTO CauHinh (ThamSo, GiaTri)
VALUES ('Threshold', 10);
--- Thêm Dữ liệu vào Bảng VatTu
INSERT INTO VatTu (MaVT, TenVT, DVT, SLHangCon) VALUES
('VT001', 'Bút bi', 'Cây', 100),
('VT002', 'Tập vở', 'Quyển', 200),
('VT003', 'Thước kẻ', 'Cái', 150),
('VT004', 'Cặp sách', 'Cái', 75),
('VT005', 'Bút chì', 'Cây', 120),
('VT006', 'Gôm tẩy', 'Cái', 180),
('VT007', 'Máy tính bỏ túi', 'Cái', 50),
('VT008', 'Giấy A4', 'Ream', 90),
('VT009', 'Bảng trắng', 'Cái', 30),
('VT010', 'Bút dạ quang', 'Cây', 110);
GO
--- Thêm Dữ liệu vào Bảng HoaDonBan
INSERT INTO HoaDonBan (MaHD, NgayXuat, HoTenKH, DiaChiKH) VALUES
('HD001', '2024-06-01', 'Nguyễn Văn A', '123 Đường ABC, TP.HCM'),
('HD002', '2024-06-02', 'Trần Thị B', '456 Đường XYZ, Hà Nội'),
('HD003', '2024-06-03', 'Lê Văn C', '789 Đường DEF, Đà Nẵng'),
('HD004', '2024-06-04', 'Phạm Thị D', '101 Đường GHI, Hải Phòng'),
('HD005', '2024-06-05', 'Hoàng Văn E', '102 Đường JKL, Cần Thơ');
GO
--- Thêm Dữ liệu vào Bảng HangXuat
INSERT INTO HangXuat (MaHD, MaVT, DonGia, SLBan) VALUES
('HD001', 'VT001', 5000, 10),
('HD001', 'VT002', 10000, 5),
('HD002', 'VT003', 8000, 7),
('HD002', 'VT004', 150000, 2),
('HD003', 'VT005', 3000, 20),
('HD003', 'VT006', 2000, 15),
('HD004', 'VT007', 120000, 3),
('HD004', 'VT008', 50000, 1),
('HD005', 'VT009', 200000, 1),
('HD005', 'VT010', 10000, 8);
GO

SELECT * 
FROM HangXuat

----------KIỂM TRA HÀNG TỒN KHO- NHẬP LẠI HÀNG--------
CREATE TRIGGER trg_Kiemtrakho_DatLaiHang
ON HangXuat
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @MaVT NVARCHAR(50), @SLBan INT, @Threshold INT;

    -- Lấy giá trị ngưỡng từ bảng cấu hình
    SELECT @Threshold = GiaTri
    FROM CauHinh
    WHERE ThamSo = 'Threshold';

    DECLARE inserted_cursor CURSOR FOR
    SELECT MaVT, SLBan
    FROM inserted;

    OPEN inserted_cursor;

    FETCH NEXT FROM inserted_cursor INTO @MaVT, @SLBan;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Cập nhật số lượng hàng tồn kho
        UPDATE VatTu
        SET SLHangCon = SLHangCon - @SLBan
        WHERE MaVT = @MaVT;

        -- Kiểm tra mức tồn kho sau khi cập nhật
        DECLARE @SLHangCon INT;
        SELECT @SLHangCon = SLHangCon
        FROM VatTu
        WHERE MaVT = @MaVT;

        -- Nếu số lượng hàng còn dưới ngưỡng, thêm vào bảng đặt hàng lại
        IF @SLHangCon < @Threshold
        BEGIN
            INSERT INTO DatHangLai (MaVT, TenVT, SLHangCon)
            SELECT MaVT, TenVT, SLHangCon
            FROM VatTu
            WHERE MaVT = @MaVT;

            PRINT 'Vật tư cần đặt hàng lại: ' + @MaVT + ', Số lượng còn: ' + CAST(@SLHangCon AS NVARCHAR);
        END

        FETCH NEXT FROM inserted_cursor INTO @MaVT, @SLBan;
    END

    CLOSE inserted_cursor;
    DEALLOCATE inserted_cursor;
END;
GO
--------------------Test triger kiểm tra và đặt lại hàng---------------
INSERT INTO VatTu (MaVT, TenVT, DVT, SLHangCon)
VALUES 
('VT011', 'Quat cam tay', 'Cái', 100),
('VT012', 'Ban chai', 'Cái', 200);

-- Thêm dữ liệu mẫu vào bảng HoaDonBan
INSERT INTO HoaDonBan (MaHD, NgayXuat, HoTenKH, DiaChiKH)
VALUES 
('HD008', '2023-06-18', 'Hoang Dinh Cuong', '123 Le Loi'),
('HD007', '2023-06-18', 'Pham Van Nam', '456 Tran Phu');

-- Thêm dữ liệu mẫu vào bảng HangXuat để kích hoạt trigger
INSERT INTO HangXuat (MaHD, MaVT, DonGia, SLBan)
VALUES 
('HD008', 'VT011', 50000, 95),
('HD007', 'VT012', 100000, 195);

-- Kiểm tra bảng DatHangLai để xem các vật tư cần đặt hàng lại
SELECT * FROM DatHangLai;

----------Baos cáo doanh thu hàng tháng------------
CREATE TABLE BaoCaoDoanhThuThang (
    MaHD NVARCHAR(50) PRIMARY KEY,
    HoTenKH NVARCHAR(50),
    TongDoanhThu INT
);

DECLARE @MaHD NVARCHAR(50), @HoTenKH NVARCHAR(50), @TongDoanhThu INT;

DECLARE sales_report_cursor CURSOR FOR
SELECT HB.MaHD, HB.HoTenKH, SUM(HX.DonGia * HX.SLBan) AS TongDoanhThu
FROM HoaDonBan HB
INNER JOIN HangXuat HX ON HB.MaHD = HX.MaHD
WHERE MONTH(HB.NgayXuat) = MONTH(GETDATE()) AND YEAR(HB.NgayXuat) = YEAR(GETDATE())
GROUP BY HB.MaHD, HB.HoTenKH;

OPEN sales_report_cursor;

FETCH NEXT FROM sales_report_cursor INTO @MaHD, @HoTenKH, @TongDoanhThu;

WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO BaoCaoDoanhThuThang (MaHD, HoTenKH, TongDoanhThu)
    VALUES (@MaHD, @HoTenKH, @TongDoanhThu);

    FETCH NEXT FROM sales_report_cursor INTO @MaHD, @HoTenKH, @TongDoanhThu;
END

CLOSE sales_report_cursor;
DEALLOCATE sales_report_cursor;
------- thêm cột tổng hoá tiền của tất cả các hoá đơn vào bảng BaoCaoDoanhThuThang
ALTER TABLE BaoCaoDoanhThuThang
ADD TongDoanhThu_TatCa_HD INT;
-- Cập nhật giá trị cho cột Tổng doanh thu của tất cả hóa đơn trong BaoCaoDoanhThuThang
UPDATE BaoCaoDoanhThuThang
SET TongDoanhThu_TatCa_HD = (
    SELECT SUM(TongDoanhThu)
    FROM BaoCaoDoanhThuThang
);
EXEC sp_rename 'BaoCaoDoanhThuThang.TongDoanhThu_TatCa_HD', 'TongDoanhThuThangHienTai', 'COLUMN';

-- Xem bảng báo cáo doanh thu hàng tháng
SELECT * FROM BaoCaoDoanhThuThang;
--- Xem tổng doanh thu tháng dạng chuỗi json---
SELECT TOP 1 CONCAT('{Tong_Doanh_Thu_Thang_Nay_La": ', CONVERT(NVARCHAR(MAX), TongDoanhThuThangHienTai), '}') AS JsonString
FROM BaoCaoDoanhThuThang;








 


