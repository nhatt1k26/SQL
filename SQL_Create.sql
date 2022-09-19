create database bkhn;
use bkhn;

CREATE TABLE SV(
	MaSV char(8) primary key,
	HoTenDem varchar(50) not null,
	Ten varchar(20) not null,
	Lop varchar(30),
	Khoa int,
	NgaySinh Date,
	QueQuan nvarchar(30),
)

create table KetquaHT(
	MaSV char(8) not null,
	MaHP char(6) not null,
	HocKy char(8),
	MaLop char(10),
	DiemThiGK dec(2,1),
	DiemThiCK dec(2,1)
	foreign key (MaSV) references SV(MaSV)
)

create table NQL(
	MaNQL char(8) primary key,
	TenNQL char(30)
)

Create table GV(
	MaGV char(10) primary key,
	HoTen varchar(50),
	Vien varchar(20),
	NamKinhNghiem dec(2,0)
)

create table LopHoc(
	MaLop char(6) primary key,
	MAGV char(10) not null,
	LichHoc varchar(10),
	foreign key (MaGV) references GV(MaGV)
)

create table BangDKHP(
	MaHP nvarchar(8) primary key,
	MaGV char(10) not null,
	foreign key (MaGV) references GV(MaGV)
)

create table BangDKLop(
	MaSV char(8),
	MaLop char(6),
	primary key(MaSV,MaLop),
	foreign key (MaSV) references SV(MaSV),
	foreign key (MaLop) references LopHoc(MaLop)
)

create table HP(
	MaHP char(6),
	TenHP nvarchar(30),
	SoTC dec(1,0),
	TCHocPhi dec(1,0),
	TrongSo dec(1,1),
)

alter table sv
alter column HoTenDem nvarchar(50)

alter table sv
alter column Ten nvarchar(20)

alter table BangDKHP
add SoTC dec(1),
TCHocPhi float,
TrongSo float
;

alter table GV 
alter column HoTen nvarchar(50);

alter table GV 
alter column Vien nvarchar(50);

alter table BangDKHP
add ThoiLuong int;

alter table LopHoc
add HocPhi int;