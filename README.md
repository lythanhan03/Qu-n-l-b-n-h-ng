#QuanLyBanHang
Baid tập lớn môn hệ quản trị cơ sở dữ liệu
Họ và tên: Lý thành An
MSSV: K215480106001
Đề tài: Quản lý bán hàng
- các yêu cầu bài toán(demo):
  +) tạo cơ sở dữ liệu quản lý hàng gồm các bảng:
  VatTu(MaVT,TenVT,DVT,SLHangCon)
  HoaDonBan(MaHD,NgayXuat,HotenKH)
  HangXuat(MaHD,MaVT,DonGia,SLBan)
  +) tạo view đưa ra các hoá đơn xuất vật tư trong năm 2024
  gồm(MaHD,NgayXuat,MaVT,TenVT,ThanhTien)
  +) hàm trả về bảng gồm các thông tin
  (MaHD,NgayXuat,MaVT,DonGia,SLBan,NgayThu)
  +)tạo trigger để tự động giảm số lượng còn(SLHangCon) trong bảng VatTu
  mỗi khi thêm mới dữ liệu cho bảng HangXuat(đưa ra thông báo lỗi nếu SLBan>SLHangCon)
