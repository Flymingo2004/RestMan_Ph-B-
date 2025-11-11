-- =============================================
-- RestMan Database - Complete Schema
-- =============================================

-- Tạo database
DROP DATABASE IF EXISTS restman;
CREATE DATABASE restman CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE restman;

-- =============================================
-- Bảng users - Quản lý người dùng
-- =============================================
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    full_name VARCHAR(100),
    role ENUM('customer', 'manager', 'salestaff', 'warehouse') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =============================================
-- Bảng customers - Thông tin khách hàng
-- =============================================
CREATE TABLE customers (
    id INT PRIMARY KEY,
    user_id INT NOT NULL,
    phone VARCHAR(20),
    address VARCHAR(255),
    has_membership_card BOOLEAN DEFAULT FALSE,
    membership_points INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- =============================================
-- Bảng menu_food - Danh sách món ăn
-- =============================================
CREATE TABLE menu_food (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    description TEXT,
    ingredients TEXT,
    type ENUM('dish', 'combo') NOT NULL DEFAULT 'dish',
    image_url VARCHAR(255),
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =============================================
-- Bảng tables - Quản lý bàn ăn
-- =============================================
CREATE TABLE tables (
    id INT PRIMARY KEY AUTO_INCREMENT,
    table_number VARCHAR(20) NOT NULL UNIQUE,
    customer_name VARCHAR(100),
    seat_capacity INT NOT NULL,
    status ENUM('empty', 'occupied', 'reserved') DEFAULT 'empty',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =============================================
-- Bảng receipts - Hóa đơn
-- =============================================
CREATE TABLE receipts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    table_id INT NOT NULL,
    customer_id INT,
    staff_id INT NOT NULL,
    receipt_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    discount_amount DECIMAL(10, 2) DEFAULT 0,
    final_amount DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'paid', 'cancelled') DEFAULT 'pending',
    payment_method ENUM('cash', 'card', 'transfer') DEFAULT 'cash',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (table_id) REFERENCES tables(id),
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    FOREIGN KEY (staff_id) REFERENCES users(id)
);

-- =============================================
-- Bảng receipt_details - Chi tiết hóa đơn
-- =============================================
CREATE TABLE receipt_details (
    id INT PRIMARY KEY AUTO_INCREMENT,
    receipt_id INT NOT NULL,
    food_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    notes TEXT,
    FOREIGN KEY (receipt_id) REFERENCES receipts(id) ON DELETE CASCADE,
    FOREIGN KEY (food_id) REFERENCES menu_food(id)
);

-- =============================================
-- INSERT DỮ LIỆU MẪU
-- =============================================

-- Users
INSERT INTO users (username, password, email, full_name, role) VALUES
('customer1', '123456', 'nguyenvana@example.com', 'Nguyễn Văn A', 'customer'),
('customer2', '123456', 'tranthib@example.com', 'Trần Thị B', 'customer'),
('manager1', '123456', 'manager@restman.com', 'Lê Văn Quản Lý', 'manager'),
('staff1', '123456', 'staff1@restman.com', 'Phạm Thị Thu', 'salestaff'),
('staff2', '123456', 'staff2@restman.com', 'Hoàng Văn Nam', 'salestaff');

-- Customers
INSERT INTO customers (id, user_id, phone, address, has_membership_card, membership_points) VALUES
(1, 1, '0901234567', '236 Nguyễn Trãi, Hà Đông', TRUE, 1500),
(2, 2, '0907654321', '111 Trần Phú, Quảng Ninh', FALSE, 0);

-- Menu Food
INSERT INTO menu_food (name, price, description, ingredients, type, is_available) VALUES
-- Món ăn chính
('Phở Bò Tái', 55000, 'Phở bò tái truyền thống Hà Nội với nước dùng hầm xương 8 tiếng', 'Bánh phở, thịt bò tái, hành, ngò, giá đỗ', 'dish', TRUE),
('Bún Bò Huế', 60000, 'Bún bò Huế chính gốc với nước dùng đậm đà', 'Bún, thịt bò, chả, giò heo, sả, ớt', 'dish', TRUE),
('Phở Bò Chín', 65000, 'Phở Bò Chín, thơm ngon hấp dẫn', 'Phở, Bò chín tới, rau củ', 'dish', TRUE),
('Phở Gà', 89000, 'Gà rán giòn tan với bí quyết tẩm ướp đặc biệt', 'Phở, Gà', 'dish', TRUE),
('Phở Bò Kobe', 120000, 'Phở bò thượng hạng', 'Phở, Bò kobe, Bò thái chỉ', 'dish', TRUE),
('Mì Ý Sốt Bò Bằm', 75000, 'Mì Ý sốt bò bằm kiểu Ý chính gốc', 'Mì Ý, thịt bò bằm, cà chua, phô mai', 'dish', TRUE),
('Lẩu Truyền Thông', 180000, 'Lẩu truyền thống chua cay đặc trưng cho 2-3 người', 'Tôm, mực, cá, nấm, rau củ, nước lẩu Thái', 'dish', TRUE),
('Bít Tết Bò Úc', 150000, 'Bít tết bò Úc nhập khẩu, độ chín tùy chọn', 'Thịt bò Úc, khoai tây, rau củ, sốt tiêu đen', 'dish', TRUE),
('Salad Trộn', 45000, 'Salad rau củ quả tươi mát với sốt đặc biệt', 'Rau xà lách, cà chua, dưa chuột, bắp cải, sốt salad', 'dish', TRUE),
('Gà Nước', 135000, 'Cá hồi Na Uy nướng chanh sả thơm lừng', 'Cá hồi, chanh, sả, mật ong, gia vị', 'dish', TRUE),

-- Combo
('Combo Gia Đình', 250000, 'Combo dành cho 4 người: 1 Gà rán, 2 Cơm gà, 2 Salad, 4 Nước ngọt', 'Gà rán, cơm gà teriyaki, salad, nước ngọt', 'combo', TRUE),
('Combo Sinh Nhật', 350000, 'Combo tiệc sinh nhật: 2 Pizza, 1 Gà rán, 4 Nước ngọt, 1 Bánh kem nhỏ', 'Pizza hải sản, gà rán, nước ngọt, bánh kem', 'combo', TRUE),
('Combo Hẹn Hò', 200000, 'Combo cho 2 người: 2 Bít tết, 1 Salad, 2 Nước ép', 'Bít tết bò, salad, nước ép trái cây', 'combo', TRUE),
('Combo Văn Phòng', 150000, 'Combo trưa văn phòng: 3 Cơm gà, 3 Nước ngọt', 'Cơm gà teriyaki, nước ngọt', 'combo', TRUE);

-- Tables
INSERT INTO tables (table_number, customer_name, seat_capacity, status) VALUES
('B01', NULL, 2, 'empty'),
('B02', 'Nguyễn Văn A', 4, 'occupied'),
('B03', NULL, 4, 'empty'),
('B04', 'Trần Thị B', 6, 'occupied'),
('B05', NULL, 2, 'empty'),
('B06', 'Lê Văn C', 4, 'occupied'),
('B07', NULL, 8, 'empty'),
('B08', 'Phạm Thị D', 4, 'occupied'),
('B09', NULL, 2, 'empty'),
('B10', NULL, 6, 'empty');

-- Receipts (Hóa đơn đang chờ thanh toán)
INSERT INTO receipts (table_id, customer_id, staff_id, total_amount, discount_amount, final_amount, status) VALUES
(2, 1, 4, 340000, 34000, 306000, 'pending'),  -- Bàn B02 - Nguyễn Văn A
(4, 2, 4, 280000, 0, 280000, 'pending'),       -- Bàn B04 - Trần Thị B
(6, NULL, 5, 150000, 0, 150000, 'pending'),    -- Bàn B06 - Lê Văn C
(8, NULL, 5, 445000, 0, 445000, 'pending');    -- Bàn B08 - Phạm Thị D

-- Receipt Details (Chi tiết món ăn đã gọi)
-- Hóa đơn 1 - Bàn B02
INSERT INTO receipt_details (receipt_id, food_id, quantity, unit_price, total_price) VALUES
(1, 1, 2, 55000, 110000),   -- 2 Phở bò tái
(1, 4, 1, 89000, 89000),    -- 1 Gà rán
(1, 9, 2, 45000, 90000),    -- 2 Salad
(1, 6, 1, 75000, 75000);    -- 1 Mì Ý

-- Hóa đơn 2 - Bàn B04
INSERT INTO receipt_details (receipt_id, food_id, quantity, unit_price, total_price) VALUES
(2, 2, 2, 60000, 120000),   -- 2 Bún bò Huế
(2, 3, 2, 65000, 130000);   -- 2 Cơm gà teriyaki

-- Hóa đơn 3 - Bàn B06
INSERT INTO receipt_details (receipt_id, food_id, quantity, unit_price, total_price) VALUES
(3, 14, 1, 150000, 150000); -- 1 Combo văn phòng

-- Hóa đơn 4 - Bàn B08
INSERT INTO receipt_details (receipt_id, food_id, quantity, unit_price, total_price) VALUES
(4, 5, 1, 120000, 120000),  -- 1 Pizza hải sản
(4, 8, 1, 150000, 150000),  -- 1 Bít tết
(4, 10, 1, 135000, 135000), -- 1 Cá hồi nướng
(4, 9, 1, 45000, 45000);    -- 1 Salad

-- =============================================
-- VIEWS VÀ PROCEDURES HỖ TRỢ
-- =============================================

-- View: Thông tin hóa đơn đầy đủ
CREATE VIEW v_receipt_full_info AS
SELECT 
    r.id as receipt_id,
    r.receipt_date,
    t.table_number,
    t.customer_name,
    u.full_name as staff_name,
    r.total_amount,
    r.discount_amount,
    r.final_amount,
    r.status,
    r.payment_method
FROM receipts r
JOIN tables t ON r.table_id = t.id
JOIN users u ON r.staff_id = u.id;

-- View: Chi tiết món ăn trong hóa đơn
CREATE VIEW v_receipt_detail_info AS
SELECT 
    rd.receipt_id,
    rd.id as detail_id,
    mf.name as food_name,
    mf.type as food_type,
    rd.quantity,
    rd.unit_price,
    rd.total_price,
    rd.notes
FROM receipt_details rd
JOIN menu_food mf ON rd.food_id = mf.id;

-- =============================================
-- KẾT THÚC SCRIPT
-- =============================================