a. Liệt kê các bài viết thuộc thể loại nhạc trữ tình:
SELECT * FROM baiviet JOIN theloai ON baiviet.ma_tloai = theloai.ma_tloai
WHERE theloai.ten_tloai = 'Nhạc trữ tình';

b. Liệt kê các bài viết của tác giả “Nhacvietplus”:
SELECT * FROM baiviet JOIN tacgia ON baiviet.ma_tgia = tacgia.ma_tgia
WHERE tacgia.ten_tgia = 'Nhacvietplus';

c. Liệt kê các thể loại chưa có bài viết:
SELECT * FROM theloai WHERE ma_tloai NOT IN (SELECT ma_tloai FROM baiviet);

d. Liệt kê thông tin bài viết đầy đủ:
SELECT baiviet.ma_bviet, baiviet.tieude, baiviet.ten_bhat, tacgia.ten_tgia, theloai.ten_tloai, baiviet.ngayviet 
FROM baiviet
JOIN tacgia ON baiviet.ma_tgia = tacgia.ma_tgia
JOIN theloai ON baiviet.ma_tloai = theloai.ma_tloai;

e. Tìm thể loại có số bài viết nhiều nhất:
SELECT theloai.ten_tloai, COUNT(baiviet.ma_bviet) AS so_bviet 
FROM baiviet 
JOIN theloai ON baiviet.ma_tloai = theloai.ma_tloai 
GROUP BY baiviet.ma_tloai 
ORDER BY so_bviet DESC 
LIMIT 1;

f. Liệt kê 2 tác giả có số bài viết nhiều nhất:
SELECT tacgia.ten_tgia, COUNT(baiviet.ma_bviet) AS so_bviet
FROM baiviet
JOIN tacgia ON baiviet.ma_tgia = tacgia.ma_tgia
GROUP BY tacgia.ma_tgia
ORDER BY so_bviet DESC
LIMIT 2;


g. Liệt kê các bài viết về các bài hát có tựa bài hát chứa 1 trong các từ “yêu”, “thương”, “anh”, “em”:
SELECT * 
FROM baiviet 
WHERE ten_bhat LIKE '%yêu%' OR ten_bhat LIKE '%thương%' OR ten_bhat LIKE '%anh%' OR ten_bhat LIKE '%em%';


h. Liệt kê các bài viết có tiêu đề bài viết hoặc tựa bài hát chứa 1 trong các từ “yêu”, “thương”, “anh”, “em”:
SELECT * 
FROM baiviet 
WHERE tieude LIKE '%yêu%' OR tieude LIKE '%thương%' OR tieude LIKE '%anh%' OR tieude LIKE '%em%' 
   OR ten_bhat LIKE '%yêu%' OR ten_bhat LIKE '%thương%' OR ten_bhat LIKE '%anh%' OR ten_bhat LIKE '%em%';

i. Tạo view có tên vw_Music để hiển thị thông tin về danh sách các bài viết kèm theo tên thể loại và tên tác giả:
CREATE VIEW vw_Music AS
SELECT baiviet.ma_bviet, baiviet.tieude, baiviet.ten_bhat, theloai.ten_tloai, tacgia.ten_tgia, baiviet.ngayviet
FROM baiviet
JOIN theloai ON baiviet.ma_tloai = theloai.ma_tloai
JOIN tacgia ON baiviet.ma_tgia = tacgia.ma_tgia;

j. Tạo thủ tục sp_DSBaiViet để trả về danh sách bài viết của một thể loại (nếu thể loại không tồn tại thì hiển thị lỗi):
DELIMITER //
CREATE PROCEDURE sp_DSBaiViet(IN tenTheLoai VARCHAR(50))
BEGIN
    DECLARE theLoaiCount INT;

    SELECT COUNT(*) INTO theLoaiCount
    FROM theloai
    WHERE ten_tloai = tenTheLoai;

    IF theLoaiCount > 0 THEN
        SELECT baiviet.ma_bviet, baiviet.tieude, baiviet.ten_bhat, tacgia.ten_tgia, baiviet.ngayviet
        FROM baiviet
        JOIN theloai ON baiviet.ma_tloai = theloai.ma_tloai
        JOIN tacgia ON baiviet.ma_tgia = tacgia.ma_tgia
        WHERE theloai.ten_tloai = tenTheLoai;
    ELSE
        SELECT 'Thể loại không tồn tại' AS ErrorMessage;
    END IF;
END //
DELIMITER ;


k. Thêm mới cột SLBaiViet vào bảng theloai và tạo trigger để cập nhật số lượng bài viết khi thêm/sửa/xóa:

ALTER TABLE theloai ADD COLUMN SLBaiViet INT DEFAULT 0;
DELIMITER //
CREATE TRIGGER tg_CapNhatTheLoai
AFTER INSERT ON baiviet
FOR EACH ROW
BEGIN
    UPDATE theloai
    SET SLBaiViet = SLBaiViet + 1
    WHERE ma_tloai = NEW.ma_tloai;
END //
DELIMITER ;


l. Bổ sung thêm bảng Users để lưu thông tin Tài khoản đăng nhập và sử dụng cho chức năng 
Đăng nhập/Quản trị trang web
CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
