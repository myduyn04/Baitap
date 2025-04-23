/* M1: tính toán và kiểm tra tổng tiền của các hàng hóa trong một đơn hàng có chính xác và hợp lệ (tổng tiền không âm) */
CREATE or ALTER FUNCTION TinhTongThanhTienDonHang (@MaDH VARCHAR(10))
RETURNS FLOAT
AS
BEGIN
    DECLARE @TongThanhTien FLOAT;

    -- Tính tổng Thành Tiền = Đơn Giá Xuất * Số Lượng cho tất cả các mã hàng trong đơn hàng
    SELECT @TongThanhTien = SUM(HangHoaXuat.DonGiaXuat * DatHangChiTiet.SoLuong)
    FROM DatHangChiTiet	JOIN HangHoaXuat ON DatHangChiTiet.MaHang = HangHoaXuat.MaHang
    WHERE DatHangChiTiet.MaDH = @MaDH;

    RETURN @TongThanhTien;
END;
GO;	
SELECT dbo.TinhTongThanhTienDonHang('DH_1000000') AS N'Tổng tiền'
SELECT * FROM DatHangChiTiet
drop function TinhTongThanhTienDonHang
go
-- kiểm tra tổng tiền có hợp lệ hay không(tổng tiền không âm).
create or alter proc TongTienCuaDatHang @MaDH varchar(10), @TongTien numeric(15,0) out
as
begin
	select @TongTien=dbo.TinhTongThanhTienDonHang(@MaDH)
	if @TongTien<0
	begin
		print (@TongTien)
		print (N'Tổng tiền < 0: Không hợp lệ')
	end
	else
	begin
		print (@TongTien)
		print (N'Tổng tiền > 0: Hợp lệ')
	end
end
go;
declare @TongTien numeric (15,0)
exec TongTienCuaDatHang 'DH_1000000', @TongTien out

/* M2: kiểm tra xem một loại hàng hóa đã có trong kho hay chưa, nếu có thì thông báo “Đã có”, 
ngược lại thì thêm hàng hóa mới vào kho. Yêu cầu đối với hàng hóa mới: đơn giá phải > 0 (MaHang, TenHang, DVT, DonGiaNhap) */p
go;
create or alter trigger kiemtraHangNhap
on HangHoaNhap
after insert
as
begin
	declare @MaHang varchar(10), @DonGiaNhap float
	select @MaHang = MaHang, @DonGiaNhap = DonGiaNhap 
	from inserted
	if (select count(*) from HangHoaNhap where MaHang = @MaHang) > 1
	begin
		print(N'Đã có loại hàng hóa này')
		rollback
	end
	else
	begin
		if @DonGiaNhap >= 0
		begin
			print(N'Thêm loại hàng thành công')
		end
		else
		begin
			print(N'Đơn giá nhập <0: không hợp lệ')
			rollback
		end
	end
end
go;

insert into HangHoaNhap (MaHang, TenHang, DVT, DonGiaNhap)
values ('H_1001000', 'Hang Hoa1000', 'Cay', 1000000);

select * from HangHoaNhap
go;
/* M3: Tính tổng doanh thu của toàn bộ đơn hàng theo tháng/quý/năm. */

--Theo tháng
CREATE or alter PROCEDURE DoanhThuTheoThang
    @thang INT, 
    @nam INT,
	@TongTien numeric(15,0) out
AS
BEGIN
    SELECT @TongTien = SUM(TongTien)
    FROM dathang
    WHERE MONTH(NgayLDH) = @thang AND YEAR(NgayLDH) = @nam;

    -- Nếu không có dữ liệu, gán tổng tiền là 0
    SET @TongTien = ISNULL(@TongTien, 0);
    PRINT N'Doanh thu tháng ' + CAST(@thang AS VARCHAR(2)) + N' năm ' + CAST(@nam AS VARCHAR(4)) + ': ' + CAST(@TongTien AS VARCHAR(30));
END;
GO;
declare @tongtien numeric(15,0)
exec doanhthutheothang 10, 2024, @tongtien out
go;

--Theo quý
CREATE or alter PROCEDURE DoanhThuTheoQuyProc 
    @quy INT, 
    @nam INT,
	@TongTien NUMERIC(15,0) out
AS
BEGIN
    IF @quy = 1
    BEGIN
        SELECT @TongTien = SUM(TongTien)
        FROM dathang
        WHERE YEAR(NgayLDH) = @nam 
        AND MONTH(NgayLDH) IN (1, 2, 3);
    END
    ELSE IF @quy = 2
    BEGIN
        SELECT @TongTien = SUM(TongTien)
        FROM dathang
        WHERE YEAR(NgayLDH) = @nam 
        AND MONTH(NgayLDH) IN (4, 5, 6);
    END
    ELSE IF @quy = 3
    BEGIN
        SELECT @TongTien = SUM(TongTien)
        FROM dathang
        WHERE YEAR(NgayLDH) = @nam 
        AND MONTH(NgayLDH) IN (7, 8, 9);
    END
    ELSE IF @quy = 4
    BEGIN
        SELECT @TongTien = SUM(TongTien)
        FROM dathang
        WHERE YEAR(NgayLDH) = @nam 
        AND MONTH(NgayLDH) IN (10, 11, 12);
    END

    SET @TongTien = ISNULL(@TongTien, 0);
    PRINT N'Doanh thu quý ' + CAST(@quy AS VARCHAR(1)) + N' năm ' + CAST(@nam AS VARCHAR(4)) + ': ' + CAST(@TongTien AS VARCHAR(30));
END;
GO;
declare @tongtien numeric(15,0)
exec doanhthutheoquyproc 4, 2024, @tongtien out
go;

--Doanh thu theo năm
create or alter proc DoanhThuTheoNam (@nam int, @TongTien numeric (15, 0) out)
as
begin
    select @TongTien = sum(TongTien)
    from dathang
    where year(NgayLDH) = @nam
	PRINT N'Doanh thu năm ' + CAST(@nam AS VARCHAR(4)) + ': ' + CAST(@TongTien AS VARCHAR(30))
end
go;
declare @TongTien numeric(15,0)
exec doanhthutheonam 2024, @tongtien out;
go;

/* M5: Kiểm tra số lượng hàng hóa của mỗi loại hàng hóa còn trong kho tại thời điểm kiểm tra.*/
create or alter proc KiemTraTonKho @MaKho varchar(10), @MaHang varchar (10), @TonKho int out
as
begin
	select @TonKho=	(sum(NhapKhoChiTiet.ThucNhap)-sum(XuatKhoChiTiet.ThucXuat)) 
					from NhapKhoChiTiet join NhapKho on NhapKhoChiTiet.MaPNK=NhapKho.MaPNK
										join Kho on NhapKho.MaKho=Kho.MaKho
										join XuatKho on Kho.MaKho=XuatKho.MaKho
										join XuatKhoChiTiet on XuatKho.SoPXK=XuatKhoChiTiet.SoPXK
					where	NhapKhoChiTiet.MaHang=@MaHang
					and		XuatKhoChiTiet.MaHang=@MaHang
					and		NhapKho.MaKho=@MaKho
					and		XuatKho.MaKho=@MaKho
end
go;

declare @MaKho varchar(10), @MaHang varchar (10), @TonKho int 
exec KiemTraTonKho 'K1001', 'H_1000002', @TonKho out
print @TonKho

select * from NhapKho
select * from NhapKhoChiTiet
select * from XuatKho
select * from XuatKhoChiTiet
go;

--M6: Tính tổng chi phí hàng hóa nhập theo tháng/quý/năm.
--Tính chi phí theo tháng
create or alter procedure TongChiPhiNhapTheoThang
    @Thang int,
    @Nam int,
	@TongChiPhi float out
as
begin
    -- tính tổng chi phí nhập theo tháng và năm
    select @TongChiPhi = sum(nk.TongTien)
    from nhapkho nk
    where month(nk.NgayNhap) = @Thang and year(nk.NgayNhap) = @Nam;

    -- trả về kết quả và thông báo
    print(N'Tổng chi phí hàng hóa nhập theo tháng ' + cast(@Thang as varchar(2)) + N' năm ' + cast(@Nam as varchar(4)) + N' là: ' + cast(isnull(@TongChiPhi, 0) as varchar(30)));
end;
go;

declare @TongChiPhi float 
exec TongChiPhiNhapTheoThang 10, 2024, @TongChiPhi out
go;

--Tính chi phí theo quý/ năm
CREATE or alter PROCEDURE TongChiPhiNhapTheoQuy
    @quy INT, 
    @nam INT,
	@TongChiPhi FLOAT out
AS
BEGIN
    IF @quy = 1
    BEGIN
        SELECT @TongChiPhi = SUM(TongTien)
        FROM NhapKho
        WHERE YEAR(NgayNhap) = @nam 
        AND MONTH(NgayNhap) IN (1, 2, 3);
    END
    ELSE IF @quy = 2
    BEGIN
       SELECT @TongChiPhi = SUM(TongTien)
        FROM NhapKho
        WHERE YEAR(NgayNhap) = @nam 
        AND MONTH(NgayNhap) IN (4, 5, 6);
    END
    ELSE IF @quy = 3
    BEGIN
        SELECT @TongChiPhi = SUM(TongTien)
        FROM NhapKho
        WHERE YEAR(NgayNhap) = @nam 
        AND MONTH(NgayNhap) in (7, 8, 9);
    END
    ELSE IF @quy = 4
    BEGIN
        SELECT @TongChiPhi = SUM(TongTien)
        FROM NhapKho
        WHERE YEAR(NgayNhap) = @nam 
        AND MONTH(NgayNhap) in (10, 11, 12);
    END

    SET @TongChiPhi = ISNULL(@TongChiPhi, 0);
    PRINT N'Chi phí nhập quý: ' + CAST(@quy AS VARCHAR(1)) + N' năm ' + CAST(@nam AS VARCHAR(4)) + ': ' + CAST(@TongChiPhi AS VARCHAR(30));
END;
GO;

declare @TongChiPhi float 
exec TongChiPhiNhapTheoQuy 4, 2024, @TongChiPhi out
go;

--Tính chi phí theo năm
create or alter procedure TongChiPhiNhapTheoNam
    @Nam int,
	@TongChiPhi float out
as
begin
    -- tính tổng chi phí nhập theo năm
    select @TongChiPhi = sum(nk.TongTien)
    from nhapkho nk
    where year(nk.NgayNhap) = @Nam;

    -- trả về kết quả và thông báo
    print(N'Tổng chi phí hàng hóa nhập năm ' + cast(@Nam as varchar(4)) + N' là: ' + cast(isnull(@TongChiPhi, 0) as varchar(30)));
end;
go;

declare @TongChiPhi float 
exec TongChiPhiNhapTheoNam 2024, @TongChiPhi out
go;

/* M7: Module thêm khách hàng, nếu trong csdl Mã khách hàng đã tồn tại thì thông báo “Đã có”, 
ngược lại thì thêm thông tin của khách hàng mới (Mã khách hàng, tên khách hàng, số điện thoại, địa chỉ) */

create or alter trigger kiemtraThemMoiKH
on KhachHang
after insert
as
begin

	declare @MaKH varchar(10), @SDTKH varchar(11) 
	select @MaKH=	MaKH
					from inserted
	select @SDTKH=	SDTKH
					from inserted
----IF EXISTS (select 1 from FROM inserted i JOIN KhachHang kh ON i.MaKH = kh.MaKH AND i.SDTKH = kh.SDTKH)
    
	if (select count(*) from KhachHang where MaKH = @MaKH and SDTKH = @SDTKH) > 1
	begin
		print(N'Khách hàng đã tồn tại')
		rollback
	end
	else
	begin
		print(N'Thêm Khách hàng thành công')
	end
end
go;

insert into KhachHang(MaKH, TenKH, SDTKH, DiaChiKH) 
values ('1001002', 'Nguyen Van A', '0905755990', 'Da Nang')
select * from KhachHang
go;

/* M8: module thêm thông tin của một nhân viên mới, nếu trong csdl đã có mã nhân viên thì thông báo “Đã có”, 
ngược lại thì thêm thông tin của nhân viên mới (Mã nhân viên, tên nhân viên, vị trí) */

create or alter trigger capnhatTTNV
on NhanVien
after insert
as
begin
	declare @MaNV varchar(10)
	select @MaNV=MaNV from inserted
----IF EXISTS (select 1 from FROM inserted i JOIN NhanVien nv ON i.MaNV = nv.MaNV )
	if (select count(*) from NhanVien where MaNV=@MaNV)>1
	begin
		print(N'Đã có')
		rollback
	end
	else
	begin
		print(N'Thêm nhân viên thành công')
	end
end
go;

insert into NhanVien (MaNV, TenNV, ViTri) values ('NV_1001002', 'Nguyen Thi B', 'NV Sales')
select * from NhanVien
go;

/* M9: Module thêm nhà cung cấp, nếu trong csdl Mã nhà cung cấp đã tồn tại thì thông báo “Đã có”, 
ngược lại thì thêm thông tin của nhà cung cấp (Mã nhà cung cấp, tên nhà cung cấp, tên người giao hàng, mã thuế, địa chỉ, stk) */

create or alter trigger kiemtraThemMoiNCC
on NhaCungCap
after insert
as
begin
	declare @MaNCC varchar(10)
	select @MaNCC=	MaNCC from inserted
----IF EXISTS (select 1 from FROM inserted i JOIN NhaCungCap ncc ON i.MaNV = ncc.MaNCC )
	if (select count(*) from NhaCungCap where MaNCC=@MaNCC)>1
	begin
		print(N'Nhà cung cấp đã tồn tại')
		rollback
	end
	else
	begin
		print(N'Thêm nhà cung cấp thành công')
	end
end
go;

insert into NhaCungCap (MaNCC, TenNCC, TenNGH, MaThue, DiaChi, STK)
values ('MC_3009', 'Cong Ty Quy Thien', 'Tran Van C', 'MT_4000', 'Da Nang', '72057225')
select * from NhaCungCap
go;

-- M10: Module tìm tháng có doanh thu cao nhất và thấp nhất trong năm yêu cầu.
CREATE or alter proc M10(
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
GO;

declare @nyc INT, @dtcn FLOAT, @dttn FLOAT, @tcn VARCHAR(10), @ttn VARCHAR(10);
exec dbo.M10 2024, @tcn OUTPUT, @dtcn OUTPUT, @ttn OUTPUT, @dttn OUTPUT;
print N'Tháng cao nhất: ' + @tcn + ' | Doanh thu cao nhất: ' + cast(@dtcn AS VARCHAR(50));
print N'Tháng thấp nhất: ' + @ttn + ' | Doanh thu thấp nhất: ' + cast(@dttn AS VARCHAR(50));
GO;

--M11. Module tìm ra top 5 khách hàng đặt nhiều đơn hàng nhất trong theo năm yêu cầu.
Create or alter function M11(@nyc int)
returns table
AS
return	SELECT TOP 5 KhachHang.TenKH,COUNT(*) AS SoDonHang
		FROM DatHang JOIN KhachHang ON DatHang.MaKH = KhachHang.MaKH
		WHERE YEAR(NgayLDH) = @nyc
		GROUP BY KhachHang.TenKH
		ORDER BY SoDonHang DESC; 
GO;

select *from dbo.M11(2024)
GO;

-- M12: Module tìm ra top 10  sản phẩm được bán nhiều nhất trong tháng và năm yêu cầu với điều kiện giá của sản phẩm trên 50.000 đồng.
Create or alter function M12(@namyc int, @tyc int)
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
			AND DonGiaXuat > 50000 -- Lớn hơn 50.000 đồng.
		GROUP BY HangHoaXuat.TenHang -- Nhóm theo tên sản phẩm
		ORDER BY Sum(ThucXuat) DESC;   -- Sắp xếp theo số lượng xuất giảm dần

	return
end
go;

select * from dbo.M12(2024, 10)
go; 

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
go;

select * from dbo.M13(2024)
go;