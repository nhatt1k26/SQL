--Câu 3: 
/*
drop table Z_QueryTable1
drop table Z_TongSoTC
drop table Z_KQMonHoc
drop table Z_CPA
drop table Z_DSSV_Yeu
drop table Z_DS_TruotMon
--go*/

--Câu 1: Lưu lại tổng học phí của mỗi sinh viên
select sum(HocPhi) as tonghocphi, MaSV from LopHoc join BangDKLop
on LopHoc.MaLop = BangDKLop.MaLop
group by MaSV

--Cau 2: Luu thong tin CPA tinh den ky hien tai cua moi sinh vien
--Tạo kết quả CPA của mỗi sinh viên
select  MaSV, sum(DiemTBMon* soTC)/sum(soTC) as CPA into Z_CPA
from HP join Z_KQMonHoc on HP.MaHP = Z_KQMonHoc.MaHP
group by MaSV
order by MaSV

-- Lưu lại thông tin của các lớp học được sv đăng ký
select LopHoc.MaLop, MaHP, HocPhi,LichHoc,BangDKLop.MaSV into Z_QueryTable1
from BangDKLop join LopHoc on BangDKLop.MaLop=LopHoc.MaLop

--Hiển thị bảng số lượng tín chỉ mà mỗi sinh viên đã đăng ký trong kỳ học hiện tại
select MaSV,sum(SoTC) as TongSoTC into Z_TongSoTC from Z_QueryTable1 join HP
on Z_QueryTable1.MaHP = HP.MaHP
group by MaSV
order by MaSV

--Tạo bảng kết quả môn học của các SV(tính điểm trung bình môn dựa trên điểm GK và CK)  
select MaSV, MaHP,sum(DiemThiGK)*0.3 + sum(DiemThiCK)*0.7 as DiemTBMon into Z_KQMonHoc from KetquaHT
group by MaSV, MaHP



-- Hiển Thị điểm CPA kỳ trước của những sinh viên có tổng số tín chỉ đăng ký ở kỳ học hiện tại lớn hơn 10
-- cmt: những sinh viên không có kết quả học tập sẽ không được hiển thị
select * from Z_TongSoTC join Z_CPA on Z_CPA.MaSV = Z_TongSoTC.MaSV
where TongSoTC>=10

--Câu 4:


--Hiển thị ( theo thứ tự mã số sinh viên) danh sách các sinh viên có điểm trung bình môn nhỏ hơn 5
select SV.MaSV, HoTenDem,Ten, MaHP,DiemTBMon into Z_DS_TruotMon from SV join Z_KQMonHoc on SV.MaSv = Z_KQMonHoc.MaSV
where Z_KQMonHoc.DiemTBMon<=4
order by MaSV

--Tạo bảng thông tin số môn trượt 
select MaSV, count(MaHP) as MonTruot into Z_SoMonTruot
from Z_DS_TruotMon
group by MaSV
order by MaSV

-- Hiển thị mã số và sô môn trượt của những sinh viên có số môn trượt lớn hơn 1
select * from Z_SoMonTruot
where MonTruot>=2

--Câu 5: Hiển thị số môn do viện toán ứng dụng và tin học quản lý 
-- ( Suggest : số môn do mỗi viện quản lý ) 
select Count(MaHP) as SoMonVienToanQuanLy from LopHoc
where MaHP like 'MI%'


-- Câu 6 Biết rằng trong năm 2019 có 132 sinh viên được tuyển thẳng do 
-- Ghi lại thông tin những sv đã đăng ký học phần 'MI2063' có thể học ( điều kiện : đã qua học phần 'MI1111' )
select sv.MaSV, Ten, Lop,DiemTBMon into Z_QueryTable2 from SV join Z_KQMonHoc on SV.MaSV = Z_KQMonHoc.MaSV
where SV.MaSV >= 20190000 and SV.MaSV<= 20190132
and Z_KQMonHoc.MaHP = 'MI1111' and Z_KQMonHoc.DiemTBMon>=4.0

select  Z_QueryTable2.MaSV,Ten,Lop from Z_QueryTable2 join BangDKHP on Z_QueryTable2.MaSV = BangDKHP.MaSV
where MaHP='MI2063'

--Câu 7: Cho biết thông tin của các giáo viên giảng dạy các lớp học có số sinh
-- viên K64 viện Toán ứng dụng và Tin học (có mã số sinh viên từ 20192000 đến
-- 20196000) từ 2 người trở lên
select count(MaSV) as SVMI, Lophoc.MaLop into Z_QueryTable3
from BangDKLop inner join LopHoc on BangDKLop.MaLop = LopHoc.MaLop
where MaSV>=20192000 and MaSV<=20196000
group by LopHoc.MaLop

select * from GV
where MaGV in (select MaGV from Z_QueryTable3 inner join LopHoc on Z_QueryTable3.MaLop = LopHoc.MaLop where SVMI>=2)


-- Câu 8: Tiến hành kiểm tra lịch học sinh viên và đưa ra thông
-- tin các lớp học trùng thời khóa biểu
select MaSV,LopHoc.MaLop, MaHP,LichHoc into Z_QueryTable4
from BangDKLop inner join LopHoc on BangDKLop.MaLop = LopHoc.MaLop

select A1.MaSV,A1.MaLop, A1.MaHP,A1.LichHoc
from Z_QueryTable4 as A1 inner join Z_QueryTable4 as A2 on 
(A1.MaSV = A2.MaSV and A1.MaHP<>A2.MaHP and A1.LichHoc = A2.LichHoc)
order by A1.MaSV


-- Câu 9:Cho biết thông tin những lớp học đang mở ở học kỳ hiện tại mà không
--cần học phần điều kiện là môn Giải tích 1 và do giảng viên có từ 3 năm
--kinh nghiệm trở lên.

select LopHoc.MaLop, MaGV, TenHP from LopHoc inner join HP on LopHoc.MaHP=HP.MaHP
where (MaGV in( select MaGV from GV where NamKinhNghiem > =3 )) and (HPDieuKien<>'MI1111' or HPDieuKien is null) 

--Câu 10: Cho biết Sinh viên của lớp Tài năng toán tin K64 có điểm CPA đứng thứ 2
--của lớp với điều kiện đã đăng ký tối thiểu 15 tín chỉ
select MaHP,MaSV into Z_QueryTable5 from BangDKLop inner join LopHoc on BangDKLop.MaLop = LopHoc.MaLop
where MaSV in (Select SV.MaSV from BangDKLop inner join SV on SV.MaSV = BangDKLop.MaSV
where SV.Lop = 'CTTN-Toán tin' and SV.Khoa=64)

select MaSV,Sum(SoTC) as TongSo into Z_QueryTable6 from Z_QueryTable5 inner join HP
on HP.MaHP = Z_QueryTable5.MaHP
group by MaSV 

select Z_CPA.MaSV, Z_CPA.CPA into Z_QueryTable7 from Z_QueryTable6 inner join Z_CPA on Z_QueryTable6.MaSV = Z_CPA.MaSV

select MaSV,CPA from Z_QueryTable7
where CPA = (select max(CPA) from Z_QueryTable7 
where CPA <> (select max(CPA) from Z_QueryTable7)