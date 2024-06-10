## QuanLyBanHang
Bài tập lớn môn hệ quản trị cơ sở dữ liệu

Họ và tên: **Lý thành An**

MSSV: **K215480106001**

Đề tài: **Quản lý bán hàng**

- các yêu cầu bài toán(demo) :
  + tạo cơ sở dữ liệu quản lý hàng gồm các bảng :
    
  *VatTu*(🔑MaVT,TenVT,DVT,SLHangCon)
  
  *HoaDonBan*(🔑MaHD,NgayXuat,HotenKH)
  
  *HangXuat*(🔑MaHD,🔑MaVT,DonGia,SLBan)
 
  + tạo view đưa ra các hoá đơn xuất vật tư trong năm 2024
    
  gồm(MaHD,NgayXuat,MaVT,TenVT,ThanhTien)
  
  + hàm trả về bảng gồm các thông tin
    
  (MaHD,NgayXuat,MaVT,DonGia,SLBan,NgayThu)
  cột NgayThu hiển thị thứ phụ thuộc vào ngày đã nhập
  
  + tạo trigger để tự động giảm số lượng còn(SLHangCon) trong bảng VatTu
  mỗi khi thêm mới dữ liệu cho bảng HangXuat(đưa ra thông báo lỗi nếu SLBan>SLHangCon)
 - update quá trình làm bài:

   **tạo cơ sở dữ liệu**
   
                                                                                                                     👀👀😻
   ![image](https://github.com/lythanhan03/Qu-n-l-b-n-h-ng/assets/168841951/698dbc32-b8a9-4546-94e9-fbc0a5496630)


   **tạo view đưa ra các hoá đơn xuất vật tư trong năm 2024**
```sql
CREATE VIEW CAU2
AS 
SELECT dbo.HangXuat.MaHD, NgayXuat, dbo.HangXuat.MaVT, TenVT
FROM dbo.HangXuat, dbo.HDBan, dbo.VatTu
WHERE dbo.HangXuat.MaHD = dbo.HDBan.MaHD AND dbo.HangXuat.MaVT = dbo.VatTu.MaVT
AND YEAR(GETDATE()) = YEAR(dbo.HDBan.NgayXuat)
SELECT * FROM CAU2
```
 **hàm trả về bảng gồm các thông tin**
    
  **(MaHD,NgayXuat,MaVT,DonGia,SLBan,NgayThu)**

  **cột NgayThu hiển thị thứ phụ thuộc vào ngày đã nhập**
  ```sql
CREATE FUNCTION getthu(@ngay DATETIME) 
	RETURNS NVARCHAR(100)
	AS
	BEGIN
		DECLARE @songaytrongtuan INT;
		SET @songaytrongtuan = DATEPART(WEEKDAY, @ngay);
		DECLARE @thu NVARCHAR(100);

		IF (@songaytrongtuan = 0)
		BEGIN
			SET @thu = 'thu hai';
		END
		IF (@songaytrongtuan = 1)
		BEGIN
			SET @thu = 'thu ba';
		END
		IF (@songaytrongtuan = 2)
		BEGIN
			SET @thu = 'thu tu';
		END
		IF (@songaytrongtuan = 3)
		BEGIN
			SET @thu = 'thu nam';
		END
		IF (@songaytrongtuan = 4)
		BEGIN
			SET @thu = 'thu sau';
		END
		IF (@songaytrongtuan = 5)
		BEGIN
			SET @thu = 'thu bay';
		END
		IF (@songaytrongtuan = 6)
		BEGIN
			SET @thu = 'chu nhat';
		END

		RETURN @thu;
	END


------- Hàm câu 3
CREATE FUNCTION hamcau3(@mahd INT) RETURNS TABLE
AS
  RETURN 
  SELECT dbo.HDBan.MaHD, NgayXuat, DonGia, SLBan, dbo.getthu(NgayXuat) AS 'NgayThu'
  FROM dbo.HangXuat, dbo.HDBan
  WHERE HDBan.MaHD = dbo.HangXuat.MaHD AND
  dbo.HangXuat.MaHD = @mahd

  SELECT * FROM dbo.hamcau3(4)
```

   
 [update sql.docx](https://github.com/user-attachments/files/15751000/update.sql.docx)

