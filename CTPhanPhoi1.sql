
GO
create database CTPhanPhoi
use CTPhanPhoi

CREATE TABLE NhaCungCap 
(
  MaNCC VARCHAR(10) NOT NULL,
  TenNCC VARCHAR(30) NOT NULL,
  TenNGH VARCHAR(30) NOT NULL,
  MaThue VARCHAR(15) NOT NULL,
  DiaChi VARCHAR(100) NOT NULL,
  STK VARCHAR(15) NOT NULL,
  PRIMARY KEY (MaNCC)
);

CREATE TABLE KhachHang
(
  MaKH VARCHAR(10) NOT NULL,
  TenKH VARCHAR(30) NOT NULL,
  SDTKH VARCHAR(10) NOT NULL,
  DiaChiKH VARCHAR(50) NOT NULL,
  PRIMARY KEY (MaKH)
);

CREATE TABLE NhanVien
(
  MaNV VARCHAR(10) NOT NULL,
  TenNV VARCHAR(30) NOT NULL,
  ViTri VARCHAR(30) NOT NULL,
  PRIMARY KEY (MaNV)
);

CREATE TABLE DatHang
(
  MaDH VARCHAR(10) NOT NULL,
  NgayLDH DATE NOT NULL,
  TongTien FLOAT NOT NULL,
  MaKH VARCHAR(10) NOT NULL,
  MaNV VARCHAR(10) NOT NULL,
  PRIMARY KEY (MaDH),
  FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
  FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);

CREATE TABLE HangHoaXuat
(
  MaHang VARCHAR(10) NOT NULL,
  TenHang VARCHAR(50) NOT NULL,
  DVT VARCHAR(10) NOT NULL,
  DonGiaXuat FLOAT NOT NULL,
  PRIMARY KEY (MaHang)
);

CREATE TABLE DatHangChiTiet
(
  MaDH VARCHAR(10) NOT NULL,
  SoLuong INT NOT NULL,
  ThanhTien FLOAT NOT NULL,
  MaHang VARCHAR(10) NOT NULL,
  PRIMARY KEY (MaDH),
  FOREIGN KEY (MaHang) REFERENCES HangHoaXuat(MaHang),
  FOREIGN KEY (MaDH) REFERENCES DatHang(MaDH)
);
CREATE TABLE ThanhToan
(
  SoPTT VARCHAR(10) NOT NULL,
  MaNV VARCHAR(10) NOT NULL,
  NgayTT DATE NOT NULL,
  Pmethod VARCHAR(20) NOT NULL,
  VAT FLOAT NOT NULL,
  TongTien FLOAT NOT NULL,
  MaNCC VARCHAR(10) NOT NULL,
  PRIMARY KEY (SoPTT),
  FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
  FOREIGN KEY (MaNCC) REFERENCES NhaCungCap(MaNCC)
);

CREATE TABLE Kho
(
  MaKho VARCHAR(5) NOT NULL,
  DiaChi VARCHAR(50) NOT NULL,
  PRIMARY KEY (MaKho)
);

CREATE TABLE XuatKho
(
  SoPXK VARCHAR(7) NOT NULL,
  NgayXuat DATE NOT NULL,
  LyDo VARCHAR(50) NOT NULL,
  TongTien FLOAT NOT NULL,
  MaKho VARCHAR(5) NOT NULL,
  PRIMARY KEY (SoPXK),
  FOREIGN KEY (MaKho) REFERENCES Kho(MaKho)
);

CREATE TABLE NhapKho
(
  MaPNK VARCHAR(7) NOT NULL,
  NgayNhap DATE NOT NULL,
  TongTien FLOAT NOT NULL,
  MaKho VARCHAR(5) NOT NULL,
  MaNCC VARCHAR(10) NOT NULL,
  PRIMARY KEY (MaPNK),
  FOREIGN KEY (MaNCC) REFERENCES NhaCungCap(MaNCC),
  FOREIGN KEY (MaKho) REFERENCES Kho(MaKho)
);

CREATE TABLE XuatKhoChiTiet
(
  SoPXK VARCHAR(7) NOT NULL,
  TheoYC INT NOT NULL,
  ThucXuat INT NOT NULL,
  ThanhTien FLOAT NOT NULL,
  MaHang VARCHAR(10) NOT NULL,
  PRIMARY KEY (SoPXK),
  FOREIGN KEY (SoPXK) REFERENCES XuatKho(SoPXK),
  FOREIGN KEY (MaHang) REFERENCES HangHoaXuat(MaHang)
);

CREATE TABLE HangHoaNhap
(
  MaHang VARCHAR(10) NOT NULL,
  TenHang VARCHAR(50) NOT NULL,
  DVT VARCHAR(10) NOT NULL,
  DonGiaNhap FLOAT NOT NULL,
  PRIMARY KEY (MaHang)
);

CREATE TABLE ThanhToanChiTiet
(
  SoPTT VARCHAR(10) NOT NULL,
  MaHang VARCHAR(10) NOT NULL,
  SoLuong INT NOT NULL,
  ThanhTien FLOAT NOT NULL,
  PRIMARY KEY (SoPTT),
  FOREIGN KEY (SoPTT) REFERENCES ThanhToan(SoPTT),
  FOREIGN KEY (MaHang) REFERENCES HangHoaNhap(MaHang)
);

CREATE TABLE NhapKhoChiTiet
(
  MaPNK VARCHAR(7) NOT NULL,
  TheoCT INT NOT NULL,
  ThucNhap INT NOT NULL,
  ThanhTien FLOAT NOT NULL,
  MaHang VARCHAR(10) NOT NULL,
  PRIMARY KEY (MaPNK),
  FOREIGN KEY (MaHang) REFERENCES HangHoaNhap(MaHang),
  FOREIGN KEY (MaPNK) REFERENCES NhapKho(MaPNK)
);

-- Nhap 1001 du lieu : Bang Kh
CREATE PROCEDURE K1
AS
BEGIN
    DECLARE @stt INT = 1,
            @doi INT = 1000000,
            @sdt int = 905000000; 

    WHILE @stt <= 1001 -- Chèn 1001 bản ghi
    BEGIN
        INSERT INTO KhachHang (MaKH, TenKH, SDTKH, DiaChiKH)
        VALUES (CAST(@doi AS VARCHAR(10)),
                'Khach Hang ' + CAST(@stt AS VARCHAR(10)),
                '0' + CAST(@sdt AS VARCHAR(10)),
                'Dia Chi ' + CAST(@stt AS VARCHAR(10)));
        
        SET @stt = @stt + 1;
        set @doi = @doi +1
		set @sdt = @sdt + 1
    END
END;
exec K1
-- Bang Nv
CREATE PROCEDURE K2
AS
BEGIN
    DECLARE @stt INT = 1,
            @doi INT = 1000000

    WHILE @stt <= 1001 -- Chèn 1001 bản ghi
    BEGIN
        INSERT INTO NhanVien(MaNV,TenNV,ViTri)
        VALUES ('NV_' + CAST(@doi AS VARCHAR(10)),
                'Nhan vien ' + CAST(@stt AS VARCHAR(10)),
                'Vi Tri ' + CAST(@stt AS VARCHAR(10)));
        
        SET @stt = @stt + 1;
        set @doi = @doi +1
    END
END;
exec K2
-- Bang DatHang
Create proc K3
as
Begin
	declare	@tt int= 1000000,
			@ma int = 1
	while @ma < 1001
	begin
		insert into DatHang (MaDH,NgayLDH,TongTien,MaKH,MaNV)
		values (
		'DH_' + cast(@tt as varchar(10)),
		getdate(),
		cast(@tt as varchar(10)),
		cast(@tt as varchar(10)),
		'NV_' + cast(@tt as varchar(10))
		)
		set @tt = @tt + 1
		set @ma = @ma + 1
	end
end
exec K3
-- K4 Bang HangHoaXuat
Create proc K4
as
Begin
	declare	@tt int= 1000000,
			@dvt varchar(50) = 'Goi',
			@ma int = 1
	while @ma < 1001
	begin
		insert into HangHoaXuat(MaHang,TenHang,DVT,DonGiaXuat)
		values (
		'H_' + cast(@tt as varchar(10)),
		'Hang Hoa '+ cast(@ma as varchar(10)),
		cast(@dvt as varchar(50)),
		cast(@tt as varchar(10))
		)
		if @ma > 500
			set @dvt = 'Cay'
		set @tt = @tt + 1
		set @ma = @ma + 1
	end
end
exec K4
-- K5 DatHangChiTiet
Create proc K5
as
Begin
	declare	@tt int= 1000000,
			@sl int = 10,
			@ma int = 1
	while @ma < 1001
	begin
		insert into DatHangChiTiet(MaDH,SoLuong,ThanhTien,MaHang)
		values (
		'DH_' + cast(@tt as varchar(10)),
		cast(@sl as varchar(10)),
		cast(@tt as varchar(50)),
		'H_'+ cast(@tt as varchar(10))
		)
		if @sl > 50
			set @sl = 10
		set @sl= @sl + 1
		set @tt = @tt + 1
		set @ma = @ma + 1
	end
end
exec K5
--K6 Kho
Create proc K6
as
Begin
	declare	@tt int= 1000,
			@ma int = 1
	while @ma < 1001
	begin
		insert into Kho(MaKho,DiaChi)
		values (
		'K' + cast(@tt as varchar(10)),
		'Dia Chi Kho '+ cast(@ma as varchar(10))
		)
		set @tt = @tt + 1
		set @ma = @ma + 1
	end
end
exec K6
-- K7 XuatKho
Create proc K7
as
Begin
	declare	@tt int= 1000000,
			@stt int = 1000,
			@LyDo varchar(50) = 'Ban Hang',
			@ma int = 1
	while @ma < 1001
	begin
		insert into XuatKho(SoPXK,NgayXuat,LyDo,TongTien,MaKho)
		values (
		'PXK' + cast(@stt as varchar(10)),
		getdate(),
		cast(@LyDo as varchar(50)),
		cast(@tt as varchar(10)),
		'K' + cast(@stt as varchar(10))
		)
		if @ma > 500
			set @LyDo = 'Bo Sung'
		set @tt = @tt + 1
		set @ma = @ma + 1
		set @stt = @stt +1
	end
end
exec K7
-- K8 Bang XuatKhoChiTiet
Create proc K8
as
Begin
	declare	@tt int= 1000000,
			@stt int = 1000,
			@yc int = 4,
			@ma int = 1
	while @ma < 1001
	begin
		insert into XuatKhoChiTiet(SoPXK,TheoYC,ThucXuat,ThanhTien,MaHang)
		values (
		'PXK' + cast(@stt as varchar(10)),
		cast(@yc + 1 as varchar(10)),
		cast(@yc as varchar(10)),
		cast(@tt as varchar(10)),
		'H_' + cast(@tt as varchar(10))
		)
		if @ma = 500
			set @yc = 1

		set @yc = @yc + 1
		set @tt = @tt + 1
		set @ma = @ma + 1
		set @stt = @stt +1
	end
end
exec K8
-- K9 Bang NCC
Create proc K9
as
Begin
	declare	@stt int = 1000,
			@stk int = 12345678,
			@ma int = 1
	while @ma < 1001
	begin
		insert into NhaCungCap(MaNCC,TenNCC,TenNGH,MaThue,DiaChi,STK)
		values (
		'MC_' + cast(@stt as varchar(10)),
		'Nha Cung Cap ' + cast(@ma as varchar(10)),
		'Nguoi Giao Hang '+ cast(@ma as varchar(10)),
		'MT_' + cast(@stt as varchar(10)),
		'Dia Chi NCC '+ cast(@ma as varchar(10)),
		cast(@stk as varchar(10))
		)
		set @stk = @stk + 1
		set @ma = @ma + 1
		set @stt = @stt +1
	end
end
exec K9
-- K10 Bang NhapKho
Create proc K10
as
Begin
	declare	@tt int= 1000000,
			@stt int = 1000,
			@ma int = 1
	while @ma < 1001
	begin
		insert into NhapKho(MaPNK,NgayNhap,TongTien,MaKho,MaNCC)
		values (
		'PNK' + cast(@stt as varchar(10)),
		getdate(),
		cast(@tt as varchar(10)),
		'K' + cast(@stt as varchar(10)),
		'MC_' + cast(@stt as varchar(10))
		)
		set @tt = @tt + 1
		set @ma = @ma + 1
		set @stt = @stt +1
	end
end
exec K10
-- K11 Bang HangHoaNhap
Create proc K11
as
Begin
	declare	@tt int= 1000000,
			@dvt varchar(50) = 'Goi',
			@ma int = 1
	while @ma < 1001
	begin
		insert into HangHoaNhap(MaHang,TenHang,DVT,DonGiaNhap)
		values (
		'H_' + cast(@tt as varchar(10)),
		'Hang Hoa '+ cast(@ma as varchar(10)),
		cast(@dvt as varchar(50)),
		cast(@tt as varchar(10))
		)
		if @ma > 500
			set @dvt = 'Cay'
		set @tt = @tt + 1
		set @ma = @ma + 1
	end
end
exec K11
-- K12 Bang NhapKhoChiTiet
Create proc K12
as
Begin
	declare	@tt int= 1000000,
			@stt int = 1000,
			@yc int = 4,
			@ma int = 1
	while @ma < 1001
	begin
		insert into NhapKhoChiTiet(MaPNK,TheoCT,ThucNhap,ThanhTien,MaHang)
		values (
		'PNK' + cast(@stt as varchar(10)),
		cast(@yc + 1 as varchar(10)),
		cast(@yc as varchar(10)),
		cast(@tt as varchar(10)),
		'H_' + cast(@tt as varchar(10))
		)

		set @yc = @yc + 1
		set @tt = @tt + 1
		set @ma = @ma + 1
		set @stt = @stt +1
	end
end
exec K12
-- K13 Bang ThanhToan
Create proc K13
as
Begin
	declare	@tt int= 1000000,
			@stt int = 1000,
			@Met varchar(50) = 'Tien Mat',
			@tax int = 1,
			@ma int = 1
	while @ma < 1001
	begin
		insert into ThanhToan(SoPTT,MaNV,NgayTT,Pmethod,VAT,TongTien,MaNCC)
		values (
		'PTT_' + cast(@stt as varchar(10)),
		'NV_'+ cast(@tt as varchar(10)),
		getdate(),
		@met,
		cast(@tax as varchar(10)),
		cast(@tt as varchar(50)),
		'MC_' + cast(@stt as varchar(10))
		)
		if @ma = 500
			set @Met = 'Chuyen Khoan'
			set @tax = 1
		set @tax = @tax +1
		set @tt = @tt + 1
		set @ma = @ma + 1
		set @stt = @stt +1
	end
end
exec K13
-- K14 ThanhToanChiTiet
Create proc K14
as
Begin
	declare	@tt int= 1000000,
			@stt int = 1000,
			@ma int = 1
	while @ma < 1001
	begin
		insert into ThanhToanChiTiet(SoPTT,MaHang,SoLuong,ThanhTien)
		values (
		'PTT_' + cast(@stt as varchar(10)),
		'H_'+ cast(@tt as varchar(10)),
		cast(@ma as varchar(10)),
		cast(@tt as varchar(50))
		)
		set @tt = @tt + 1
		set @ma = @ma + 1
		set @stt = @stt +1
	end
end
exec K14
--Module CT Phan Phoi.

-- M10: Module tìm tháng có doanh thu cao nhất và thấp nhất trong năm yêu cầu.
CREATE proc M10(
    @nyc INT,
    @tcn VARCHAR(10) OUTPUT,   -- Tên tháng có doanh thu cao nhất
    @dtcn FLOAT OUTPUT,         -- Doanh thu cao nhất
    @ttn VARCHAR(10) OUTPUT,    -- Tên tháng có doanh thu thấp nhất
    @dttn FLOAT OUTPUT  )         -- Doanh thu thấp nhất
AS
BEGIN
    -- Tìm tháng có doanh thu cao nhất
    SELECT TOP 1
      @tcn = MONTH(NgayLDH),
      @dtcn = SUM(TongTien)
    FROM DatHang
    WHERE YEAR(NgayLDH) = @nyc  -- So sánh năm từ biến đầu vào
    GROUP BY MONTH(NgayLDH)
    ORDER BY sum(TongTien) DESC;

    -- Tìm tháng có doanh thu thấp nhất
    SELECT TOP 1
        @ttn =MONTH(NgayLDH),
        @dttn = SUM(TongTien)
    FROM DatHang
    WHERE YEAR(NgayLDH) = @nyc  -- So sánh năm từ biến đầu vào
    GROUP BY MONTH(NgayLDH)
    ORDER BY sum(TongTien) ASC;
END;
declare @nyc INT, @dtcn FLOAT, @dttn FLOAT, @tcn VARCHAR(10), @ttn VARCHAR(10);
exec dbo.M10 2024, @tcn OUTPUT, @dtcn OUTPUT, @ttn OUTPUT, @dttn OUTPUT;
print 'Tháng cao nhất: ' + @tcn + ' | Doanh thu cao nhất: ' + cast(@dtcn AS VARCHAR(50));
print'Tháng thấp nhất: ' + @ttn + ' | Doanh thu thấp nhất: ' + cast(@dttn AS VARCHAR(50));

--M11. Module tìm ra top 5 khách hàng đặt nhiều đơn hàng nhất trong theo năm yêu cầu.
Create function M11(@nyc int)
returns table
AS
return	SELECT TOP 5 KhachHang.TenKH,COUNT(*) AS SoDonHang
		FROM DatHang JOIN KhachHang ON DatHang.MaKH = KhachHang.MaKH
		WHERE YEAR(NgayLDH) = @nyc
		GROUP BY KhachHang.TenKH
		ORDER BY SoDonHang DESC; 
select *from dbo.M11(2024)

-- M12: Module tìm ra top 10  sản phẩm được bán nhiều nhất trong tháng và năm yêu cầu  với điều kiện giá của sản phẩm trên 50.000 đồng.
Create function M12(@namyc int, @tyc int)
returns @trave table (TenHang varchar(50),
						ThucXuat int)
as
Begin
	Insert into @trave
	Select Top 10 TenHang, Sum(ThucXuat)
		from XuatKhoChiTiet JOIN XuatKho ON XuatKho.SoPXK = XuatKhoChiTiet.SoPXK
		JOIN DatHangChiTiet ON DatHangChiTiet.MaHang = XuatKhoChiTiet.MaHang
		JOIN HangHoaXuat ON HangHoaXuat.MaHang = XuatKhoChiTiet.MaHang
		WHERE MONTH(NgayXuat) = @tyc   -- Tìm trong tháng hiện tại
		AND YEAR(NgayXuat) = @namyc -- Tìm trong năm hiện tại
		And DonGiaXuat >50000 -- Lớn hơn 50.000 đồng.
		GROUP BY HangHoaXuat.TenHang -- Nhóm theo tên sản phẩm
		ORDER BY Sum(ThucXuat) DESC;   -- Sắp xếp theo số lượng xuất giảm dần

	return
end
select * from M12(2024,10)

--M13.Module tìm ra top 3 nhân viên bán được nhiều đơn hàng nhất trong năm yêu cầu.
Create function M13(@nyc int)
returns @trave table (TenNV varchar(50),
						Sl int)
As
Begin 
	Insert into @trave
	Select Top 3 TenNV, Count(MaDH) as SLDH
	from NhanVien join DatHang on DatHang.MaNV = NhanVien.MaNV
	where year(NgayLDH) = @nyc
	Group by TenNV
	Order by Count(DatHang.MaDH) DESC

	return
end
select * from M13(2024)

