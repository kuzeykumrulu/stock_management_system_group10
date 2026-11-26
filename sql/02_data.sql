-- =====================================================================
-- CMPE341 - Stock Management System
-- 02_data.sql : Data loading (at least 3 records per table)
-- =====================================================================

INSERT INTO category (category_name, description) VALUES
('Electronics',       'Computers, peripherals and electronic devices'),
('Office Supplies',   'Paper, pens, folders and other stationery'),
('Furniture',         'Office desks, chairs and storage units'),
('Cleaning',          'Cleaning materials and hygiene products'),
('Networking',        'Switches, routers, cables and accessories');

INSERT INTO supplier (supplier_name, contact_name, phone, email, city) VALUES
('TeknoDagitim A.S.',   'Mehmet Yilmaz', '0312 555 1010', 'sales@teknodagitim.com',  'Ankara'),
('Kirtasiye Dunyasi',   'Ayse Demir',    '0216 444 2020', 'info@kirtasiyedunyasi.com','Istanbul'),
('Ofis Mobilya Ltd.',   'Ali Kaya',      '0232 333 3030', 'contact@ofismobilya.com', 'Izmir'),
('Temiz Kimya',         'Zeynep Arslan', '0224 222 4040', 'order@temizkimya.com',    'Bursa'),
('NetLink Bilisim',     'Burak Sahin',   '0312 666 5050', 'b2b@netlink.com.tr',      'Ankara');

INSERT INTO product (sku, product_name, unit, unit_price, reorder_level, category_id, supplier_id) VALUES
('EL-001', 'Laptop 15.6" i5 16GB',          'pcs', 24999.00,  5, 1, 1),
('EL-002', 'Wireless Mouse',                'pcs',   449.90, 20, 1, 1),
('EL-003', '24" LED Monitor',               'pcs',  4799.00, 12, 1, 1),
('OS-001', 'A4 Copy Paper (500 sheets)',    'box',   189.50, 50, 2, 2),
('OS-002', 'Ballpoint Pen Blue (50 pack)',  'box',   245.00, 15, 2, 2),
('FU-001', 'Ergonomic Office Chair',        'pcs',  6499.00,  4, 3, 3),
('FU-002', 'Office Desk 140x70',            'pcs',  5299.00,  3, 3, 3),
('CL-001', 'Surface Cleaner 5L',            'lt',    329.00, 10, 4, 4),
('NW-001', '24-Port Gigabit Switch',        'pcs',  7850.00,  5, 5, 5),
('NW-002', 'Cat6 UTP Cable 305m',           'box',  3150.00,  5, 5, 5);

INSERT INTO warehouse (warehouse_name, city, address, capacity) VALUES
('Ankara Central',  'Ankara',   'Ostim OSB, 1234. Cad. No:5, Yenimahalle', 10000),
('Istanbul Depot',  'Istanbul', 'Tuzla Organize Sanayi, 3. Sok. No:12',    15000),
('Izmir Depot',     'Izmir',    'Kemalpasa OSB, 8. Cad. No:21',             6000);

INSERT INTO employee (first_name, last_name, job_role, phone, email, hire_date, warehouse_id) VALUES
('Emre',   'Celik',   'Warehouse Manager',    '0532 100 0001', 'emre.celik@stockco.com',   '2021-03-15', 1),
('Selin',  'Aydin',   'Purchasing Officer',   '0532 100 0002', 'selin.aydin@stockco.com',  '2022-06-01', 1),
('Can',    'Ozturk',  'Sales Representative', '0532 100 0003', 'can.ozturk@stockco.com',   '2023-01-10', 2),
('Deniz',  'Koc',     'Stock Clerk',          '0532 100 0004', 'deniz.koc@stockco.com',    '2023-09-04', 2),
('Elif',   'Yildiz',  'Warehouse Manager',    '0532 100 0005', 'elif.yildiz@stockco.com',  '2020-11-20', 3),
('Mert',   'Polat',   'Sales Representative', '0532 100 0006', 'mert.polat@stockco.com',   '2024-02-12', 1);

INSERT INTO customer (customer_name, phone, email, city) VALUES
('Atilim Teknoloji Ltd.',  '0312 400 1111', 'purchasing@atilimtek.com',  'Ankara'),
('Bosphorus Consulting',   '0212 400 2222', 'office@bosphorusc.com',     'Istanbul'),
('Ege Yazilim A.S.',       '0232 400 3333', 'admin@egeyazilim.com',      'Izmir'),
('Kizilay Eczanesi',       '0312 400 4444', 'kizilayecz@gmail.com',      'Ankara'),
('Marmara Lojistik',       '0216 400 5555', 'info@marmaralojistik.com',  'Kocaeli');

INSERT INTO inventory (product_id, warehouse_id, quantity, shelf_location) VALUES
(1, 1, 12, 'A-01'), (1, 2,  3, 'B-04'),
(2, 1, 85, 'A-02'), (2, 2, 40, 'B-01'),
(3, 1,  6, 'A-03'), (3, 3,  4, 'C-02'),
(4, 1, 30, 'D-10'), (4, 2, 120,'D-01'), (4, 3, 15, 'D-05'),
(5, 2, 22, 'D-02'),
(6, 1,  2, 'F-01'), (6, 3,  9, 'F-03'),
(7, 3,  1, 'F-04'),
(8, 1, 18, 'K-01'), (8, 2,  7, 'K-02'),
(9, 1,  4, 'N-01'),
(10,1,  2, 'N-02'), (10,2,  6, 'N-03');

INSERT INTO purchase_order (order_date, status, supplier_id, employee_id, warehouse_id) VALUES
('2026-09-02', 'Received',  1, 2, 1),
('2026-09-18', 'Received',  2, 2, 2),
('2026-10-05', 'Received',  5, 2, 1),
('2026-10-27', 'Pending',   3, 5, 3),
('2026-11-08', 'Cancelled', 4, 2, 1);

INSERT INTO purchase_order_item (po_id, product_id, quantity, unit_cost) VALUES
(1, 1, 10, 21500.00), (1, 2, 60, 310.00), (1, 3, 8, 3950.00),
(2, 4, 150, 140.00), (2, 5, 30, 180.00),
(3, 9, 5, 6600.00),  (3, 10, 6, 2700.00),
(4, 6, 10, 5100.00), (4, 7, 5, 4300.00),
(5, 8, 20, 250.00);

INSERT INTO sales_order (order_date, status, customer_id, employee_id, warehouse_id) VALUES
('2026-09-10', 'Delivered', 1, 6, 1),
('2026-09-25', 'Delivered', 2, 3, 2),
('2026-10-03', 'Delivered', 3, 5, 3),
('2026-10-14', 'Shipped',   1, 6, 1),
('2026-10-30', 'Delivered', 5, 3, 2),
('2026-11-06', 'Pending',   4, 6, 1);

INSERT INTO sales_order_item (so_id, product_id, quantity, unit_price) VALUES
(1, 1, 3, 24999.00), (1, 2, 5, 449.90), (1, 3, 3, 4799.00),
(2, 4, 40, 189.50),  (2, 5, 10, 245.00),
(3, 6, 4, 6499.00),  (3, 7, 2, 5299.00),
(4, 9, 1, 7850.00),  (4, 10, 2, 3150.00), (4, 2, 10, 449.90),
(5, 4, 25, 189.50),  (5, 8, 6, 329.00),
(6, 8, 3, 329.00),   (6, 4, 5, 189.50);
