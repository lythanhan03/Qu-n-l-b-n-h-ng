
## QuanLyBanHang
*Quản lý bán hàng là một khía cạnh quan trọng trong hoạt động kinh doanh, đóng vai trò then chốt trong việc thúc đẩy doanh số, duy trì mối quan hệ với khách hàng và tối ưu hóa quy trình bán hàng. Ngày nay để thuận tiện cho việc kinh doanh đã áp dụng rất nhiều sản phẩm công nghệ nhằm mục đích quản lý dễ dàng, nhanh chóng, chính xác và bảo mật.*

Họ và tên: **Lý thành An**

MSSV: **K215480106001**

Đề tài: **Quản lý bán hàng**

## Các chức năng 
- Quản lý vật tư:
  + Thêm, sửa và xoá vật tư
  + Tìm kiếm vật tư
  + Kiểm tra số lượng vật tư
- Quản lý hoá đơn bán:
  + Thêm, sửa và xoá hoá đơn bán
  + Thêm chi tiết hoá đơn bán
  +  Cập nhật hoá đơn
  +  Tìm kiếm hoá đơn
 - Quản lý số lượng hàng :
   + Quản lý số lượng hàng còn, và đặt lại hàng nếu số lượng hàng còn nhỏ hơn ngưỡng tự chọn
    
 - Báo cáo và phân tích doanh số:
   + Hệ thống quản lý bán hàng cung cấp các báo cáo chi tiết về doanh số, hiệu suất bán hàng
    
  + tạo cơ sở dữ liệu quản lý hàng gồm các bảng :
    
  *VatTu*(🔑ID,MaVT,TenVT,DVT,SLHangCon)
  
  *HoaDonBan*(🔑ID, MaHD,NgayXuat,HotenKH,DiaChiKH)
  
  *HangXuat*(🔑ID,*MaHD*,*MaVT*,DonGia,SLBan)

  Tạo thêm các bảng sau để phục vụ cho các chức năng

  *DatHangLai*(🔑ID,MaVT,TenVT,SLHangCon,NgayDatHangLai)

  *BaoCaoDoanhThuThang*(🔑MaHD,HoTenKH,TongDoanhThu,TongDoanhThuThangHienTai)
 
 Dựa trên cơ sở sở dữ liệu trên ta tiến hành tạo các bảng như sau:

Tạo database có tên là BTLSQL để tiến hành bài tập lớn này:
```sql
--- Tạo Database
CREATE DATABASE BTLSQL;
GO
---  gọi và sử dụng database vừa tạo
USE BTLSQL;
GO
```
 
 Tạo bảng Vật tư
 ```sql
 CREATE TABLE VatTu
(
    ID INT IDENTITY(1,1) PRIMARY KEY,
    MaVT NVARCHAR(50) NOT NULL UNIQUE,
    TenVT NVARCHAR(50) NOT NULL,
    DVT NVARCHAR(50) NOT NULL,
    SLHangCon INT NOT NULL
);
```
>-   **ID**: Trường ID được định nghĩa là khóa chính (Primary Key) với tính tự tăng (`IDENTITY(1,1)`), tức là giá trị ID sẽ tự động tăng mỗi khi có bản ghi mới được thêm vào bảng.
>-   **MaVT**: Mã vật tư, là một chuỗi không có giá trị NULL (`NOT NULL`) và duy nhất (`UNIQUE`). Đây là trường để xác định duy nhất mỗi vật tư.
>-   **TenVT**: Tên vật tư, cũng là một chuỗi không NULL.
>-   **DVT**: Đơn vị tính của vật tư, ví dụ như "cái", "chiếc", "kg",...
>-   **SLHangCon**: Số lượng hàng còn trong kho của vật tư.

Tạo bảng Hoá đơn bán
```sql
CREATE TABLE HoaDonBan
(
    ID INT IDENTITY(1,1) PRIMARY KEY,
    MaHD NVARCHAR(50) NOT NULL UNIQUE,
    NgayXuat DATE NOT NULL,
    HoTenKH NVARCHAR(50) NOT NULL,
    DiaChiKH NVARCHAR(100)
);
 ```
 

> -   **ID**: Trường ID là khóa chính với tính tự động tăng.
>-   **MaHD**: Mã hóa đơn bán, là một chuỗi không NULL và duy nhất.
>-   **NgayXuat**: Ngày xuất hóa đơn, là một giá trị DATE không NULL.
>-   **HoTenKH**: Họ tên khách hàng mua hàng, là một chuỗi không NULL.
>-   **DiaChiKH**: Địa chỉ khách hàng, có thể NULL.

Tạo bảng Hàng xuất (chi tiết hoá đơn)
 ```sql
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
 ```
 >-   **ID**: Trường ID là khóa chính với tính tự động tăng.
>-   **MaHD**: Mã hóa đơn liên kết với bảng `HoaDonBan`, là một chuỗi không NULL.
>-   **MaVT**: Mã vật tư liên kết với bảng `VatTu`, là một chuỗi không NULL.
>-   **DonGia**: Đơn giá của vật tư khi xuất bán, là một số nguyên không NULL.
>-   **SLBan**: Số lượng vật tư được bán trong hóa đơn, là một số nguyên không NULL.
>-   **FOREIGN KEY**: Định nghĩa ràng buộc khóa ngoại để đảm bảo tính toàn vẹn tham chiếu dữ liệu giữa các bảng. Trường `MaHD` tham chiếu đến `MaHD` trong bảng `HoaDonBan`, và trường `MaVT` tham chiếu đến `MaVT` trong bảng `VatTu`. Tùy chọn `ON DELETE CASCADE` chỉ định rằng nếu một hóa đơn hoặc một vật tư được xóa, thì các bản ghi liên quan trong bảng `HangXuat` cũng sẽ bị xóa để duy trì tính toàn vẹn dữ liệu.
```sql
CREATE TABLE DatHangLai
(
    ID INT IDENTITY(1,1) PRIMARY KEY,
    MaVT NVARCHAR(50) NOT NULL,
    TenVT NVARCHAR(50) NOT NULL,
    SLHangCon INT NOT NULL,
    NgayDatHangLai DATE DEFAULT GETDATE()
);
```
➡️ Bảng này được tạo thêm để phục vụ cho chức năng kiểm tra hàng tồn kho và đặt lại hàng

>- **ID**: Định nghĩa cột ID là khóa chính (primary key), với kiểu dữ liệu là INT, sử dụng IDENTITY(1,1) để tự động tăng giá trị và bắt đầu từ 1.

>- **MaVT**: Định nghĩa cột MaVT với kiểu dữ liệu NVARCHAR(50), không cho phép giá trị NULL.

>- **TenVT**: Định nghĩa cột TenVT với kiểu dữ liệu NVARCHAR(50), không cho phép giá trị NULL.

>- **SLHangCon**: Định nghĩa cột SLHangCon với kiểu dữ liệu INT, không cho phép giá trị NULL.

>- **NgayDatHangLai**: Định nghĩa cột NgayDatHangLai với kiểu dữ liệu DATE, và sử dụng DEFAULT GETDATE() để mặc định giá trị của cột là ngày hiện tại khi có sự thay đổi
```sql
CREATE TABLE BaoCaoDoanhThuThang (
    MaHD NVARCHAR(50) PRIMARY KEY,
    HoTenKH NVARCHAR(50),
    TongDoanhThu INT
);
```
➡️ Bảng này được tạo nhằm phục vụ cho chức năng báo cáo doanh thu hàng tháng

>- **MaHD**: Định nghĩa cột MaHD là khóa chính (primary key) của bảng, với kiểu dữ liệu NVARCHAR(50). Khóa chính này sẽ đảm bảo tính duy nhất của mỗi dòng dữ liệu trong bảng BaoCaoDoanhThuThang.

>- **HoTenKH**: Định nghĩa cột HoTenKH với kiểu dữ liệu NVARCHAR(50), không có ràng buộc khóa chính.

>- **TongDoanhThu**: Định nghĩa cột TongDoanhThu với kiểu dữ liệu INT, lưu trữ tổng doanh thu của mỗi hóa đơn.

 Ta có các bảng có liên kết như sau
 
![image](https://github.com/lythanhan03/Qu-n-l-b-n-h-ng/assets/168841951/8d0f11a2-f44f-406b-a112-315806bbf757)



 Thêm dữ liệu cho các bảng
```sql
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

--- Thêm Dữ liệu vào Bảng HoaDonBan
INSERT INTO HoaDonBan (MaHD, NgayXuat, HoTenKH, DiaChiKH) VALUES
('HD001', '2024-06-01', 'Nguyễn Văn A', '123 Đường ABC, TP.HCM'),
('HD002', '2024-06-02', 'Trần Thị B', '456 Đường XYZ, Hà Nội'),
('HD003', '2024-06-03', 'Lê Văn C', '789 Đường DEF, Đà Nẵng'),
('HD004', '2024-06-04', 'Phạm Thị D', '101 Đường GHI, Hải Phòng'),
('HD005', '2024-06-05', 'Hoàng Văn E', '102 Đường JKL, Cần Thơ');

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
```
 ## Tạo các chức năng
 **1.  Tạo các thủ tục đối với vật tư**
 Xử lý chức năng thêm, sửa, xoá, tìm kiếm và kiểm tra đối với vật tư
 ```sql
 -----------THỦ TỤC - VẬT TƯ---------------
---  Thêm Vật Tư Mới
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

---  Cập Nhật Thông Tin Vật Tư
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

---  Xóa Vật Tư
CREATE PROCEDURE XoaVatTu
    @MaVT NVARCHAR(50)
AS
BEGIN
    DELETE FROM VatTu
    WHERE MaVT = @MaVT;
END;
GO

---  Tìm Kiếm Vật Tư
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

---  Kiểm Tra Tồn Kho
CREATE PROCEDURE KiemTraTonKho
    @MaVT NVARCHAR(50)
AS
BEGIN
    SELECT SLHangCon FROM VatTu
    WHERE MaVT = @MaVT;
END;
GO
```
Sử dụng các thủ tục đã tạo với vật tư
```sql
----- test các thủ tục đã tạo
-- thêm vật tư
EXEC ThemVatTu 
    @MaVT = 'VT200',
    @TenVT = N'Balo',
    @DVT = N'chiếc',
    @SLHangCon = 50;
```
![image](https://github.com/lythanhan03/Qu-n-l-b-n-h-ng/assets/168841951/5e8f390c-663c-482c-96bb-058ea0133fce)
```sql
--- cập nhật
EXEC CapNhatVatTu 
    @MaVT = 'VT200',
    @TenVT = N'Balo Vippro',
    @DVT = N'Chiếc',
    @SLHangCon = 50;
```
![image](https://github.com/lythanhan03/Qu-n-l-b-n-h-ng/assets/168841951/e9732e50-d714-48ca-9a25-261ab9c085f8)
```sql
--- xoá vật tư
EXEC XoaVatTu 
    @MaVT = 'VT200';
```
```sql
-- tìm kiếm vật tư
EXEC TimKiemVatTu 
    @Keyword = 'balo';
```
![image](https://github.com/lythanhan03/Qu-n-l-b-n-h-ng/assets/168841951/c0160f28-d052-4411-a237-79ee89318a6a)
```sql
--- kiểm tra hàng tồn kho bằng mã vt
EXEC KiemTraTonKho 
    @MaVT = 'VT200';
```
![image](https://github.com/lythanhan03/Qu-n-l-b-n-h-ng/assets/168841951/805d57b9-33d4-4029-9405-7019a894996f)

**2. Tạo các thủ tục đối với hoá đơn**
Xử lý chức năng thêm, sửa, xoá, cập nhật hoá đơn
```sql
-------- THỦ TỤC - HOÁ ĐƠN --------------
---  Thêm Hóa Đơn Bán
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

---  Sửa Hóa Đơn Bán
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

---  Xóa Hóa Đơn Bán
CREATE PROCEDURE XoaHoaDonBan
    @MaHD NVARCHAR(50)
AS
BEGIN
    DELETE FROM HoaDonBan
    WHERE MaHD = @MaHD;
END;
GO

---  Thêm Chi Tiết Hóa Đơn
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

---  Cập Nhật Số Lượng Chi Tiết Hóa Đơn
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

---  Xóa Dòng trong Chi Tiết Hóa Đơn
CREATE PROCEDURE XoaChiTietHoaDon
    @MaHD NVARCHAR(50),
    @MaVT NVARCHAR(50)
AS
BEGIN
    DELETE FROM HangXuat
    WHERE MaHD = @MaHD AND MaVT = @MaVT;
END;
GO
```
Sử dụng các thủ tục đã tạo đối với hoá đơn bán: 
```sql
----1 thêm hoá đơn bán
EXEC ThemHoaDonBan 
    @MaHD = 'HD201',
    @NgayXuat = '2023-12-06',
    @HoTenKH = 'Hoang Van Hai',
    @DiaChiKH = 'Ha Noi';
```
![image](https://github.com/lythanhan03/Qu-n-l-b-n-h-ng/assets/168841951/b3be29a6-8872-4eed-a62c-b45e3bc851da)

```sql
----2 sửa hoá đơn bán
EXEC SuaHoaDonBan 
    @MaHD = 'HD201',
    @NgayXuat = '2023-12-07',
    @HoTenKH = 'Hoang Van Hai',
    @DiaChiKH = 'Thai Nguyen';
```
![image](https://github.com/lythanhan03/Qu-n-l-b-n-h-ng/assets/168841951/b72ca841-7035-4342-8ebf-37b7c5dfd0fd)

```sql
---3 xoá hoá đơn bán
EXEC XoaHoaDonBan 
    @MaHD = 'HD201';
```
```sql
---4 thêm cho tiết hoá đơn bán
EXEC ThemChiTietHoaDon 
    @MaHD = 'HD201',
    @MaVT = 'VT002',
    @DonGia = 10000,
    @SLBan = 5;
```
![image](https://github.com/lythanhan03/Qu-n-l-b-n-h-ng/assets/168841951/7ddc2cef-d332-4b75-acec-5e6c839c2838)

```sql
----5 cập nhật số lượng bán trong bảng(HangXuat) 
EXEC CapNhatSoLuongChiTietHoaDon 
    @MaHD = 'HD201',
    @MaVT = 'VT002',
    @SLBan = 20;
```
![image](https://github.com/lythanhan03/Qu-n-l-b-n-h-ng/assets/168841951/9633114b-13bd-4d5c-883d-ac303bd48d83)
```sql
---6 xoá chi tiết hoá đơn(HangXuat)
EXEC XoaChiTietHoaDon 
    @MaHD = 'HD201',
    @MaVT = 'VT002';
```
**Tìm kiếm hoá đơn theo thời gian mong muốn**
```sql
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
```
sử dụng thủ tục tìm kiếm hoá đơn theo thời gian mong muốn
```sql
EXEC LayHoaDonTheoThangNam 
    @Month = 6,
    @Year = 2024;
```
![image](https://github.com/lythanhan03/Qu-n-l-b-n-h-ng/assets/168841951/793d0a8d-c825-4e55-951e-81b8bbf0120a)

**3. Tạo các chức năng**

*3.1 Kiểm tra hàng tồn kho, nhập hàng lại*
```sql
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
```
Tạo một bảng để chuyền tham số và giá trị ngưỡng so sánh
```sql
CREATE TABLE CauHinh
(
    ThamSo NVARCHAR(50) PRIMARY KEY,
    GiaTri INT
);
```
Thử nghiệm chức năng

Bước 1 nhập dữ liệu vào các bảng liên quan

```sql
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
```
> Ban đầu các vật tư 'Quạt cầm tay' có 100 cái

> 'Bàn chải' có 200 cái

> Sau khi đã nhập hoá đơn bán và hàng xuất:
> + Hoá đơn HD008 đã mua vật tư VT011( quạt cầm tay) 95 cái
> + Hoá đơn HD007 đã mua vật tư VT012( Bàn chải) 195 cái

Thử chạy chức năng
```sql
SELECT * FROM DatHangLai;
```
Ta có kết quả như sau: hiển thị số lượng hàng còn và ngày nhập lại và các thông số liên quan đến vật tư đó

![image](https://github.com/lythanhan03/Qu-n-l-b-n-h-ng/assets/168841951/9fb8dd7d-2445-4507-aacf-e86f11500d43)

Ở đây em đang set ngưỡng là 10, nếu nhỏ hơn 10 sẽ nhập hàng lại, như sau

```sql
INSERT INTO CauHinh (ThamSo, GiaTri)
VALUES ('Threshold', 10);
```

Ta có thể điều chỉnh ngưỡng bằng cách sau

```sql
-- Thay đổi ngưỡng kiểm tra
UPDATE CauHinh
SET GiaTri = 20
WHERE ThamSo = 'Threshold';
```

*3.2 Báo cáo doanh thu theo tháng*

```sql
----------Baos cáo doanh thu hàng tháng------------
-- Khai báo các biến dùng trong cursor
DECLARE @MaHD NVARCHAR(50), @HoTenKH NVARCHAR(50), @TongDoanhThu INT;

-- Khai báo và thiết lập cursor để truy vấn doanh thu
DECLARE sales_report_cursor CURSOR FOR
SELECT HB.MaHD, HB.HoTenKH, SUM(HX.DonGia * HX.SLBan) AS TongDoanhThu
FROM HoaDonBan HB
INNER JOIN HangXuat HX ON HB.MaHD = HX.MaHD
WHERE MONTH(HB.NgayXuat) = MONTH(GETDATE()) AND YEAR(HB.NgayXuat) = YEAR(GETDATE())
GROUP BY HB.MaHD, HB.HoTenKH;

-- Mở cursor
OPEN sales_report_cursor;

-- Lấy dữ liệu đầu tiên từ cursor vào các biến
FETCH NEXT FROM sales_report_cursor INTO @MaHD, @HoTenKH, @TongDoanhThu;

-- Lặp qua các kết quả của cursor
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Chèn kết quả vào bảng BaoCaoDoanhThuThang
    INSERT INTO BaoCaoDoanhThuThang (MaHD, HoTenKH, TongDoanhThu)
    VALUES (@MaHD, @HoTenKH, @TongDoanhThu);

    -- Lấy kết quả tiếp theo từ cursor
    FETCH NEXT FROM sales_report_cursor INTO @MaHD, @HoTenKH, @TongDoanhThu;
END

-- Đóng cursor
CLOSE sales_report_cursor;

-- Giải phóng tài nguyên dành cho cursor
DEALLOCATE sales_report_cursor;

-- Thêm cột TongDoanhThu_TatCa_HD vào bảng BaoCaoDoanhThuThang
ALTER TABLE BaoCaoDoanhThuThang
ADD TongDoanhThu_TatCa_HD INT;

-- Cập nhật giá trị cho cột TongDoanhThu_TatCa_HD với tổng doanh thu của tất cả hóa đơn
UPDATE BaoCaoDoanhThuThang
SET TongDoanhThu_TatCa_HD = (
    SELECT SUM(TongDoanhThu)
    FROM BaoCaoDoanhThuThang
);

-- Đổi tên cột TongDoanhThu_TatCa_HD thành TongDoanhThuThangHienTai
EXEC sp_rename 'BaoCaoDoanhThuThang.TongDoanhThu_TatCa_HD', 'TongDoanhThuThangHienTai', 'COLUMN';

```

Để sử dụng chức năng báo cáo doanh thu tháng như sau

Cách thứ nhất: xem bảng báo cáo doanh thu tháng

```sql
-- Xem bảng báo cáo doanh thu hàng tháng
SELECT * FROM BaoCaoDoanhThuThang;
```


Cách thứ hai: xem chuỗi json hiển thị tổng doanh thu tháng này là bao nhiêu

```sql
SELECT TOP 1 CONCAT('{Tong_Doanh_Thu_Thang_Nay_La": ', CONVERT(NVARCHAR(MAX), TongDoanhThuThangHienTai), '}') AS JsonString
FROM BaoCaoDoanhThuThang;
```
kết quả khi xem tổng doanh thu tháng bằng chuỗi json

![image](https://github.com/lythanhan03/Qu-n-l-b-n-h-ng/assets/168841951/adfacdf5-5bd6-42e0-9d8b-0c18f3c5b885)








