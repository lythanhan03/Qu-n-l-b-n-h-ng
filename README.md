
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
  + Quản lý số lượng hàng còn
    
 ...
 - Báo cáo và phân tích doanh số:
  + Hệ thống quản lý bán hàng cung cấp các báo cáo chi tiết về doanh số, hiệu suất bán hàng
    
 ....

  + tạo cơ sở dữ liệu quản lý hàng gồm các bảng :
    
  *VatTu*(🔑ID,MaVT,TenVT,DVT,SLHangCon)
  
  *HoaDonBan*(🔑ID, MaHD,NgayXuat,HotenKH,DiaChiKH)
  
  *HangXuat*(🔑ID,*MaHD*,*MaVT*,DonGia,SLBan)
 
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

 Ta có các bảng có liên kết như sau
 
 ![image](https://github.com/lythanhan03/Qu-n-l-b-n-h-ng/assets/168841951/d38a7a51-dc19-4537-b11f-f5b534f268a8)

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
```
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
