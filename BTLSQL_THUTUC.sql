-----------THỦ TỤC - VẬT TƯ---------------
--- Thủ tục Thêm Vật Tư Mới
CREATE PROCEDURE ThemVatTu
    @MaVT NVARCHAR(50),
    @TenVT NVARCHAR(50),
    @DVT NVARCHAR(50),
    @SLHangCon INT
AS
BEGIN
    INSERT INTO VatTu (MaVT, TenVT, DVT, SLHangCon)
    VALUES (@MaVT, @TenVT, @DVT, @SLHangCon);
END;
GO

--- Thủ tục Cập Nhật Thông Tin Vật Tư
CREATE PROCEDURE CapNhatVatTu
    @MaVT NVARCHAR(50),
    @TenVT NVARCHAR(50),
    @DVT NVARCHAR(50),
    @SLHangCon INT
AS
BEGIN
    UPDATE VatTu
    SET TenVT = @TenVT, DVT = @DVT, SLHangCon = @SLHangCon
    WHERE MaVT = @MaVT;
END;
GO

--- Thủ tục Xóa Vật Tư
CREATE PROCEDURE XoaVatTu
    @MaVT NVARCHAR(50)
AS
BEGIN
    DELETE FROM VatTu
    WHERE MaVT = @MaVT;
END;
GO

--- Thủ tục Tìm Kiếm Vật Tư
CREATE PROCEDURE TimKiemVatTu
    @Keyword NVARCHAR(50)
AS
BEGIN
    SELECT * FROM VatTu
    WHERE MaVT LIKE '%' + @Keyword + '%'
       OR TenVT LIKE '%' + @Keyword + '%'
       OR DVT LIKE '%' + @Keyword + '%';
END;
GO

--- Thủ tục Kiểm Tra Tồn Kho
CREATE PROCEDURE KiemTraTonKho
    @MaVT NVARCHAR(50)
AS
BEGIN
    SELECT SLHangCon FROM VatTu
    WHERE MaVT = @MaVT;
END;
GO
----- test các thủ tục đã tạo
-- thêm vật tư
EXEC ThemVatTu 
    @MaVT = 'VT011',
    @TenVT = 'mũ bảo hiểm',
    @DVT = 'chiếc',
    @SLHangCon = 50;
--- cập nhật
EXEC CapNhatVatTu 
    @MaVT = 'VT011',
    @TenVT = 'mũ bảo hiểm nữ',
    @DVT = 'Chiếc',
    @SLHangCon = 50;
--- xoá vật tư
EXEC XoaVatTu 
    @MaVT = 'VT011';
-- tìm kiếm vật tư
EXEC TimKiemVatTu 
    @Keyword = 'bút';
--- kiểm tra hàng tồn kho bằng mã vt
EXEC KiemTraTonKho 
    @MaVT = 'VT002';

-------- THỦ TỤC - HOÁ ĐƠN --------------
--- Thủ tục Thêm Hóa Đơn Bán
CREATE PROCEDURE ThemHoaDonBan
    @MaHD NVARCHAR(50),
    @NgayXuat DATE,
    @HoTenKH NVARCHAR(50),
    @DiaChiKH NVARCHAR(100)
AS
BEGIN
    INSERT INTO HoaDonBan (MaHD, NgayXuat, HoTenKH, DiaChiKH)
    VALUES (@MaHD, @NgayXuat, @HoTenKH, @DiaChiKH);
END;
GO

--- Thủ tục Sửa Hóa Đơn Bán
CREATE PROCEDURE SuaHoaDonBan
    @MaHD NVARCHAR(50),
    @NgayXuat DATE,
    @HoTenKH NVARCHAR(50),
    @DiaChiKH NVARCHAR(100)
AS
BEGIN
    UPDATE HoaDonBan
    SET NgayXuat = @NgayXuat, HoTenKH = @HoTenKH, DiaChiKH = @DiaChiKH
    WHERE MaHD = @MaHD;
END;
GO

--- Thủ tục Xóa Hóa Đơn Bán
CREATE PROCEDURE XoaHoaDonBan
    @MaHD NVARCHAR(50)
AS
BEGIN
    DELETE FROM HoaDonBan
    WHERE MaHD = @MaHD;
END;
GO

--- Thủ tục Thêm Chi Tiết Hóa Đơn
CREATE PROCEDURE ThemChiTietHoaDon
    @MaHD NVARCHAR(50),
    @MaVT NVARCHAR(50),
    @DonGia INT,
    @SLBan INT
AS
BEGIN
    INSERT INTO HangXuat (MaHD, MaVT, DonGia, SLBan)
    VALUES (@MaHD, @MaVT, @DonGia, @SLBan);
END;
GO

--- Thủ tục Cập Nhật Số Lượng Chi Tiết Hóa Đơn
CREATE PROCEDURE CapNhatSoLuongChiTietHoaDon
    @MaHD NVARCHAR(50),
    @MaVT NVARCHAR(50),
    @SLBan INT
AS
BEGIN
    UPDATE HangXuat
    SET SLBan = @SLBan
    WHERE MaHD = @MaHD AND MaVT = @MaVT;
END;
GO

--- Thủ tục Xóa Dòng trong Chi Tiết Hóa Đơn
CREATE PROCEDURE XoaChiTietHoaDon
    @MaHD NVARCHAR(50),
    @MaVT NVARCHAR(50)
AS
BEGIN
    DELETE FROM HangXuat
    WHERE MaHD = @MaHD AND MaVT = @MaVT;
END;
GO
----- test các thủ tục hoá đơn bán
----1 thêm hoá đơn bán
EXEC ThemHoaDonBan 
    @MaHD = 'HD006',
    @NgayXuat = '2024-06-06',
    @HoTenKH = 'Vũ Thị F',
    @DiaChiKH = '789 Đường NMO, Đà Nẵng';
----2 sửa hoá đơn bán
EXEC SuaHoaDonBan 
    @MaHD = 'HD006',
    @NgayXuat = '2024-06-07',
    @HoTenKH = 'Vũ Thị F',
    @DiaChiKH = '789 Đường NMO, Đà Nẵng, Việt Nam';
---3 xoá hoá đơn bán
EXEC XoaHoaDonBan 
    @MaHD = 'HD006';
---4 thêm cho tiết hoá đơn bán
EXEC ThemChiTietHoaDon 
    @MaHD = 'HD005',
    @MaVT = 'VT002',
    @DonGia = 10000,
    @SLBan = 3;
----5 cập nhật số lượng bán trong bảng(HangXuat) 
EXEC CapNhatSoLuongChiTietHoaDon 
    @MaHD = 'HD005',
    @MaVT = 'VT002',
    @SLBan = 5;
---6 xoá chi tiết hoá đơn(HangXuat)
EXEC XoaChiTietHoaDon 
    @MaHD = 'HD005',
    @MaVT = 'VT002';

---- tìm kiếm hoá đơn theo tháng và năm-----
--- Tạo View Hiển Thị Tất Cả Các Hóa Đơn Xuất Vật Tư
CREATE VIEW HoaDonXuatVatTu AS
SELECT 
    hd.MaHD,
    hd.NgayXuat,
    hd.HoTenKH,
    hd.DiaChiKH,
    hx.MaVT,
    hx.DonGia,
    hx.SLBan,
    vt.TenVT,
    vt.DVT
FROM 
    HoaDonBan hd
JOIN 
    HangXuat hx ON hd.MaHD = hx.MaHD
JOIN 
    VatTu vt ON hx.MaVT = vt.MaVT;
GO

--- Tạo Thủ Tục Lọc Hóa Đơn Xuất Vật Tư Theo Tháng và Năm
CREATE PROCEDURE LayHoaDonTheoThangNam
    @Month INT,
    @Year INT
AS
BEGIN
    SELECT 
        MaHD,
        NgayXuat,
        HoTenKH,
        DiaChiKH,
        MaVT,
        TenVT,
        DVT,
        DonGia,
        SLBan
    FROM 
        HoaDonXuatVatTu
    WHERE 
        MONTH(NgayXuat) = @Month AND YEAR(NgayXuat) = @Year;
END;
GO
---- sử dụng thủ tục lấy hoá đơn theo tháng năm
EXEC LayHoaDonTheoThangNam 
    @Month = 6,
    @Year = 2024;






