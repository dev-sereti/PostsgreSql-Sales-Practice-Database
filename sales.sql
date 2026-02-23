
-- SALES DATABASE FOR DATA CLEANING PRACTICE
-- PostgreSQL Script


-- Step 0: Create the database (run this separately or from psql)
-- You may need to connect to the default 'postgres' database first.
-- CREATE DATABASE "Sales";
-- \c Sales

-- STEP 1: DROP EXISTING TABLES (for re-runnability)

DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS customers CASCADE;


-- STEP 2: CREATE TABLES
-- Intentionally loose constraints to allow messy data in.
-- In a clean DB you'd have tighter types/constraints.


CREATE TABLE customers (
    customer_id     SERIAL PRIMARY KEY,
    first_name      VARCHAR(100),
    last_name       VARCHAR(100),
    email           VARCHAR(255),
    phone           VARCHAR(50),
    address         VARCHAR(255),
    city            VARCHAR(100),
    state           VARCHAR(100),
    zip_code        VARCHAR(20),
    country         VARCHAR(100),
    registration_date TEXT,          
    customer_segment  VARCHAR(50)
);

CREATE TABLE products (
    product_id      SERIAL PRIMARY KEY,
    product_name    VARCHAR(255),
    category        VARCHAR(100),
    sub_category    VARCHAR(100),
    brand           VARCHAR(100),
    unit_price      VARCHAR(50),     -- intentionally TEXT to allow '$' symbols etc.
    cost_price      VARCHAR(50),
    weight_kg       VARCHAR(50),
    supplier        VARCHAR(100),
    is_active       VARCHAR(20)
);

CREATE TABLE orders (
    order_id        SERIAL PRIMARY KEY,
    customer_id     INTEGER,
    order_date      TEXT,            -- intentionally TEXT
    ship_date       TEXT,            -- intentionally TEXT
    shipping_method VARCHAR(100),
    order_status    VARCHAR(50),
    payment_method  VARCHAR(50),
    sales_channel   VARCHAR(50),
    region          VARCHAR(50),
    notes           TEXT
);

CREATE TABLE order_items (
    item_id         SERIAL PRIMARY KEY,
    order_id        INTEGER,
    product_id      INTEGER,
    quantity        VARCHAR(20),     -- intentionally TEXT
    unit_price      VARCHAR(50),     -- intentionally TEXT
    discount        VARCHAR(20),     -- intentionally TEXT
    total_amount    VARCHAR(50)      -- intentionally TEXT — often won't match qty*price
);


-- STEP 3: INSERT MESSY CUSTOMER DATA (~200 rows)


INSERT INTO customers
    (first_name, last_name, email, phone, address, city, state, zip_code, country, registration_date, customer_segment)
VALUES
-- Normal records
('John',     'Smith',      'john.smith@email.com',        '(555) 123-4567',  '123 Main St',           'New York',      'NY',    '10001',   'USA',    '2022-01-15',  'Premium'),
('Jane',     'Doe',        'jane.doe@email.com',          '555-234-5678',    '456 Oak Ave',            'Los Angeles',   'CA',    '90001',   'USA',    '2022-02-20',  'Regular'),
('Robert',   'Johnson',    'robert.j@email.com',          '(555)345-6789',   '789 Pine Rd',            'Chicago',       'IL',    '60601',   'USA',    '2022-03-10',  'Premium'),
('Emily',    'Williams',   'emily.w@email.com',           '555.456.7890',    '321 Elm St',             'Houston',       'TX',    '77001',   'USA',    '2022-04-05',  'Regular'),
('Michael',  'Brown',      'michael.b@email.com',         '5559876543',      '654 Birch Ln',           'Phoenix',       'AZ',    '85001',   'USA',    '2022-05-18',  'VIP'),

-- Duplicate of John Smith (exact)
('John',     'Smith',      'john.smith@email.com',        '(555) 123-4567',  '123 Main St',           'New York',      'NY',    '10001',   'USA',    '2022-01-15',  'Premium'),

-- Near-duplicate of John Smith (slight differences)
('john',     'smith',      'john.smith@email.com',        '555-123-4567',    '123 Main Street',       'new york',      'ny',    '10001',   'US',     '01/15/2022',  'premium'),
(' John ',   'Smith ',     'JOHN.SMITH@EMAIL.COM',        '(555)123-4567',   '123 Main St.',          'NEW YORK',      'New York', '10001','United States', '2022-01-15', 'PREMIUM'),

-- Missing data in various forms
('Sarah',    'Davis',      NULL,                          '555-111-2222',    '100 Center Blvd',        'Miami',         'FL',    '33101',   'USA',    '2022-06-01',  'Regular'),
('David',    '',           'david@email.com',             '',                '200 West Rd',            'Seattle',       'WA',    '98101',   'USA',    '2022-07-12',  NULL),
('Lisa',     'Anderson',   'N/A',                         'n/a',             '',                       'Boston',        'MA',    '',        'USA',    'None',        'Regular'),
('',         'Taylor',     'taylor@email.com',            '--',              'N/A',                    NULL,            'OR',    '97201',   NULL,     '2022-08-22',  'n/a'),
('Kevin',    NULL,         'kevin@email.com',             '555-333-4444',    '400 North Ave',          'Denver',        'CO',    '80201',   'USA',    '',            '--'),

-- Invalid data
('Amy',      'Wilson',     'amy-at-email.com',            '12345',           '500 South St',           'Atlanta',       'GA',    '30301',   'USA',    '2022-09-15',  'Regular'),
('Chris',    'Martinez',   'chris@',                      'not a phone',     '600 East Blvd',          'Dallas',        'TX',    'ABCDE',   'USA',    '2099-12-31',  'Gold'),
('Nancy',    'Thomas',     'nancy@email..com',            '555-000-0000',    '700 Lake Dr',            'San Fran',      'CA',    '94101',   'USA',    '13/25/2022',  'Premum'),

-- Inconsistent city/state naming
('Mark',     'Jackson',    'mark.j@email.com',            '(555) 444-5555',  '800 River Rd',           'NYC',           'New York','10002', 'US',     '2022-10-05',  'Regular'),
('Laura',    'White',      'laura.w@email.com',           '555-555-6666',    '900 Hill St',            'L.A.',          'California','90002','United States','2022-10-15','regular'),
('James',    'Harris',     'james.h@email.com',           '(555)666-7777',   '1000 Valley Ave',        'S.F.',          'Calif.','94102',   'U.S.A.', '2022-11-01',  'REGULAR'),
('Patricia', 'Clark',      'patricia.c@email.com',        '555 777 8888',    '1100 Mountain Rd',       'Houstan',       'Tx',    '77002',   'usa',    '2022-11-20',  'Prremium'),

-- Typos and misspellings
('Daniel',   'Lewsi',      'daniel.l@email.com',          '(555)888-9999',   '1200 Forest Ln',         'Chciago',       'ILL',   '60602',   'USA',    '2022-12-01',  'Regulr'),
('Jennifer', 'Robinsn',    'jennifer.r@email.com',        '555-999-0000',    '1300 Desert Dr',         'Phoneix',       'Ariz',  '85002',   'USA',    '2022-12-15',  'VPI');

-- Extra whitespace issues
--('  Brian',  'Young  ',    ' brian.y@email.com ',         ' 555-111-0000 ',  '  1400 Beach Blvd  ',    '  Miami  ',     ' FL ',  ' 33102 ', ' USA ',  ' 2023-01-10 ','  Regular  ');

-- Generate more customers procedurally with random messiness
INSERT INTO customers
    (first_name, last_name, email, phone, address, city, state, zip_code, country, registration_date, customer_segment)
SELECT
    -- First names with random issues
    CASE (random()*15)::int
        WHEN 0 THEN '  ' || fn || '  '
        WHEN 1 THEN UPPER(fn)
        WHEN 2 THEN LOWER(fn)
        WHEN 3 THEN ''
        WHEN 4 THEN NULL
        ELSE fn
    END,
    -- Last names with random issues
    CASE (random()*12)::int
        WHEN 0 THEN ln || '  '
        WHEN 1 THEN UPPER(ln)
        WHEN 2 THEN NULL
        ELSE ln
    END,
    -- Emails with random issues
    CASE (random()*10)::int
        WHEN 0 THEN NULL
        WHEN 1 THEN 'N/A'
        WHEN 2 THEN LOWER(fn) || '-at-email.com'
        WHEN 3 THEN UPPER(LOWER(fn) || '.' || LOWER(ln) || '@email.com')
        ELSE LOWER(fn) || '.' || LOWER(ln) || i::text || '@email.com'
    END,
    -- Phone with random formats
    CASE (random()*8)::int
        WHEN 0 THEN '(' || (500 + (random()*99)::int)::text || ') ' || (100 + (random()*899)::int)::text || '-' || (1000 + (random()*8999)::int)::text
        WHEN 1 THEN (500 + (random()*99)::int)::text || '-' || (100 + (random()*899)::int)::text || '-' || (1000 + (random()*8999)::int)::text
        WHEN 2 THEN (500 + (random()*99)::int)::text || '.' || (100 + (random()*899)::int)::text || '.' || (1000 + (random()*8999)::int)::text
        WHEN 3 THEN ''
        WHEN 4 THEN 'N/A'
        ELSE (5001000000 + (random()*999999999)::bigint)::text
    END,
    -- Address
    (1 + (random()*9999)::int)::text || ' ' ||
        (ARRAY['Main','Oak','Pine','Elm','Cedar','Maple','Birch','Walnut','Cherry','Ash'])[1 + (random()*9)::int] || ' ' ||
        (ARRAY['St','Ave','Rd','Blvd','Ln','Dr','Way','Ct','Pl','Cir'])[1 + (random()*9)::int],
    -- City with inconsistencies
    CASE (random()*15)::int
        WHEN 0 THEN 'new york'
        WHEN 1 THEN 'NEW YORK'
        WHEN 2 THEN 'NYC'
        WHEN 3 THEN 'los angeles'
        WHEN 4 THEN 'L.A.'
        WHEN 5 THEN 'Chciago'
        WHEN 6 THEN 'Houstan'
        WHEN 7 THEN NULL
        ELSE (ARRAY['New York','Los Angeles','Chicago','Houston','Phoenix','Philadelphia','San Antonio','San Diego','Dallas','Austin','Seattle','Denver','Boston','Miami','Atlanta','Portland','Minneapolis','Detroit','Tampa','Orlando'])[1 + (random()*19)::int]
    END,
    -- State with inconsistencies
    CASE (random()*8)::int
        WHEN 0 THEN (ARRAY['New York','California','Illinois','Texas','Arizona'])[1 + (random()*4)::int]
        WHEN 1 THEN (ARRAY['ny','ca','il','tx','az'])[1 + (random()*4)::int]
        ELSE (ARRAY['NY','CA','IL','TX','AZ','PA','FL','WA','CO','MA','OR','GA','MN','MI'])[1 + (random()*13)::int]
    END,
    -- Zip code with issues
    CASE (random()*8)::int
        WHEN 0 THEN ''
        WHEN 1 THEN 'N/A'
        ELSE LPAD((10000 + (random()*89999)::int)::text, 5, '0')
    END,
    -- Country with inconsistencies
    CASE (random()*8)::int
        WHEN 0 THEN 'US'
        WHEN 1 THEN 'U.S.A.'
        WHEN 2 THEN 'United States'
        WHEN 3 THEN 'usa'
        WHEN 4 THEN NULL
        ELSE 'USA'
    END,
    -- Registration date with format issues
    CASE (random()*6)::int
        WHEN 0 THEN TO_CHAR(DATE '2021-01-01' + (random()*1000)::int, 'MM/DD/YYYY')
        WHEN 1 THEN TO_CHAR(DATE '2021-01-01' + (random()*1000)::int, 'DD-Mon-YYYY')
        WHEN 2 THEN ''
        WHEN 3 THEN 'N/A'
        ELSE TO_CHAR(DATE '2021-01-01' + (random()*1000)::int, 'YYYY-MM-DD')
    END,
    -- Customer segment with issues
    CASE (random()*10)::int
        WHEN 0 THEN 'premium'
        WHEN 1 THEN 'REGULAR'
        WHEN 2 THEN 'Premum'
        WHEN 3 THEN 'VPI'
        WHEN 4 THEN NULL
        WHEN 5 THEN 'N/A'
        WHEN 6 THEN 'Regulr'
        ELSE (ARRAY['Premium','Regular','VIP','Enterprise'])[1 + (random()*3)::int]
    END
FROM
    -- Generate names by cross-joining arrays
    UNNEST(ARRAY['Alex','Sam','Jordan','Taylor','Morgan','Casey','Riley','Quinn','Avery','Cameron',
                 'Drew','Blake','Skyler','Reese','Dakota','Peyton','Harper','Logan','Charlie','Frankie']) AS fn,
    UNNEST(ARRAY['Smith','Johnson','Williams','Brown','Jones','Garcia','Miller','Davis','Rodriguez','Martinez']) AS ln,
    generate_series(1,1) AS i   -- multiply if you need more
LIMIT 175;


-- STEP 4: INSERT MESSY PRODUCT DATA (~50 rows)


INSERT INTO products
    (product_name, category, sub_category, brand, unit_price, cost_price, weight_kg, supplier, is_active)
VALUES
-- Clean records
('Laptop Pro 15',       'Electronics',   'Laptops',       'TechBrand',    '999.99',   '650.00',  '2.1',   'Global Supply Co',  'Yes'),
('Wireless Mouse',      'Electronics',   'Accessories',   'TechBrand',    '29.99',    '12.50',   '0.1',   'Global Supply Co',  'Yes'),
('USB-C Cable 6ft',     'Electronics',   'Cables',        'CableCo',      '12.99',    '3.00',    '0.05',  'Cable World Inc',   'Yes'),
('Office Chair Ergo',   'Furniture',     'Chairs',        'ComfortPlus',  '349.99',   '180.00',  '15.0',  'Furniture Direct',  'Yes'),
('Standing Desk',       'Furniture',     'Desks',         'ComfortPlus',  '599.99',   '320.00',  '35.0',  'Furniture Direct',  'Yes'),
('Notebook A5',         'Office Supplies','Paper',        'PaperMate',    '4.99',     '1.50',    '0.2',   'Office Depot',      'Yes'),
('Ballpoint Pen 12pk',  'Office Supplies','Pens',         'PenCraft',     '8.99',     '2.80',    '0.15',  'Office Depot',      'Yes'),
('Monitor 27"',         'Electronics',   'Monitors',      'ViewTech',     '449.99',   '280.00',  '5.5',   'Display Corp',      'Yes'),
('Keyboard Mechanical', 'Electronics',   'Accessories',   'KeyMaster',    '79.99',    '35.00',   '0.8',   'Global Supply Co',  'Yes'),
('Webcam HD 1080p',     'Electronics',   'Accessories',   'ViewTech',     '59.99',    '22.00',   '0.15',  'Display Corp',      'Yes'),

-- Price with currency symbols (dirty)
('Printer Laser',       'Electronics',   'Printers',      'PrintPro',     '$299.99',  '$150.00', '8.0',   'Print Solutions',   'Yes'),
('Ink Cartridge Black', 'Office Supplies','Ink',           'PrintPro',     '$24.99',   '$8.00',   '0.1',   'Print Solutions',   'Yes'),
('Ink Cartridge Color', 'Office Supplies','ink',           'PrintPro',     '34.99$',   '12.00',   '0.1',   'Print Solutions',   'yes'),

-- Category inconsistencies
('Desk Lamp LED',       'Furniture',     'Lighting',      'LightCo',      '39.99',    '15.00',   '1.2',   'Light World',       'Yes'),
('Desk Lamp LED',       'furniture',     'Lighting',      'LightCo',      '39.99',    '15.00',   '1.2',   'Light World',       'Y'),
('Filing Cabinet',      'FURNITURE',     'Storage',       'SteelCase',    '189.99',   '95.00',   '25.0',  'Furniture Direct',  'YES'),
('Whiteboard 4x3',      'Offce Supplies','Boards',        'BoardMax',     '89.99',    '40.00',   '3.0',   'Office Depot',      'Yes'),
('Sticky Notes 12pk',   'Office Suplies','Paper',         'PaperMate',    '6.99',     '2.00',    '0.3',   'Office Depot',      'Yes'),
('Stapler Heavy Duty',  'Office supplies','Staplers',      'BindAll',      '19.99',    '8.00',    '0.5',   'Office Depot',      'Yes'),

-- Missing/invalid data
('Headphones Wireless', 'Electronics',   'Audio',         'SoundMax',     '149.99',   NULL,      '0.25',  'Audio World',       'Yes'),
('Tablet 10"',          'Electronics',   'Tablets',       '',             '399.99',   '220.00',  'N/A',   '',                  NULL),
('Phone Case',          'Electronics',   'Accessories',   'CaseCo',       '',         '3.00',    '0.05',  'Case World',        'Yes'),
('Mouse Pad XL',        'Electronics',   'Accessories',   NULL,           '14.99',    '4.00',    '0.3',   NULL,                'Y'),

-- Negative/zero prices (errors)
('HDMI Cable 3ft',      'Electronics',   'Cables',        'CableCo',      '-9.99',    '2.50',    '0.03',  'Cable World Inc',   'Yes'),
('Paper Ream 500',      'Office Supplies','Paper',        'PaperMate',    '0',        '3.50',    '2.5',   'Office Depot',      'Yes'),

-- Extreme outlier
('Gold Plated Pen',     'Office Supplies','Pens',         'LuxWrite',     '9999.99',  '5000.00', '0.05',  'Luxury Goods Ltd',  'Yes'),

-- Duplicate product different casing
('laptop pro 15',       'electronics',   'laptops',       'techbrand',    '999.99',   '650.00',  '2.1',   'global supply co',  'yes'),
('LAPTOP PRO 15',       'ELECTRONICS',   'LAPTOPS',       'TECHBRAND',    '999.99',   '650.00',  '2.1',   'GLOBAL SUPPLY CO',  'YES'),

-- More products for variety
('Bookshelf 5-Tier',    'Furniture',     'Shelving',      'WoodCraft',    '129.99',   '65.00',   '18.0',  'Furniture Direct',  'Yes'),
('Desk Organizer',      'Office Supplies','Organization', 'OrgPro',       '24.99',    '10.00',   '0.8',   'Office Depot',      'Yes'),
('Power Strip 6-Outlet','Electronics',   'Power',         'PowerSafe',    '19.99',    '7.00',    '0.4',   'Global Supply Co',  'Yes'),
('Surge Protector',     'Electronics',   'Power',         'PowerSafe',    '34.99',    '14.00',   '0.6',   'Global Supply Co',  'Yes'),
('Ethernet Cable 10ft', 'Electronics',   'Cables',        'CableCo',      '8.99',     '2.00',    '0.1',   'Cable World Inc',   'Yes'),
('Webcam Cover',        'Electronics',   'Accessories',   'PrivShield',   '3.99',     '0.50',    '0.01',  'Privacy Products',  'Yes'),
('Document Shredder',   'Electronics',   'Office Machines','ShreddIt',    '149.99',   '75.00',   '8.0',   'Office Depot',      'Yes'),
('Calculator Scientific','Office Supplies','Calculators',  'MathPro',     '19.99',    '8.00',    '0.2',   'Office Depot',      'Yes'),
('Binder 3-Ring 1"',    'Office Supplies','Binders',      'BindAll',      '5.99',     '2.00',    '0.3',   'Office Depot',      'Yes'),
('Tape Dispenser',      'Office Supplies','Tape',         'StickyStuff',  '7.99',     '3.00',    '0.25',  'Office Depot',      'Yes'),
('Scissors 8"',         'Office Supplies','Cutting',      'SharpEdge',    '6.99',     '2.50',    '0.15',  'Office Depot',      'Yes'),
('Paper Clips 100ct',   'Office Supplies','Fasteners',    'BindAll',      '2.99',     '0.80',    '0.1',   'Office Depot',      'Yes'),
('Rubber Bands Asst',   'Office Supplies','Fasteners',    'BindAll',      '3.49',     '1.00',    '0.1',   'Office Depot',      'Yes'),
('Marker Set 12pk',     'Office Supplies','Writing',      'ColorWrite',   '11.99',    '4.50',    '0.2',   'Office Depot',      'Yes'),
('Highlighter 6pk',     'Office Supplies','Writing',      'ColorWrite',   '5.49',     '1.80',    '0.1',   'Office Depot',      'Yes'),
('Correction Tape 6pk', 'Office Supplies','Writing',      'FixIt',        '8.99',     '3.00',    '0.15',  'Office Depot',      'Yes'),
('Envelope #10 100ct',  'Office Supplies','Mailing',      'MailMax',      '9.99',     '3.50',    '0.5',   'Office Depot',      'Yes'),
('Bubble Mailer 25ct',  'Office Supplies','Mailing',      'MailMax',      '14.99',    '6.00',    '0.8',   'Office Depot',      'Yes'),
('Label Maker',         'Electronics',   'Office Machines','LabelPro',    '39.99',    '18.00',   '0.5',   'Office Depot',      'Yes'),
('Label Tape Refill',   'Office Supplies','Labels',       'LabelPro',     '12.99',    '4.00',    '0.05',  'Office Depot',      'Yes');



-- STEP 5: INSERT MESSY ORDER DATA (~300 rows)


-- Insert hand-crafted problematic orders first
INSERT INTO orders
    (customer_id, order_date, ship_date, shipping_method, order_status, payment_method, sales_channel, region, notes)
VALUES
-- Normal orders
(1,  '2023-01-15', '2023-01-18', 'Standard',    'Delivered',  'Credit Card',  'Online',    'East',    NULL),
(2,  '2023-01-20', '2023-01-23', 'Express',     'Delivered',  'PayPal',       'Online',    'West',    NULL),
(3,  '2023-02-05', '2023-02-08', 'Standard',    'Delivered',  'Credit Card',  'In-Store',  'Central', NULL),
(4,  '2023-02-14', '2023-02-17', 'Overnight',   'Delivered',  'Debit Card',   'Online',    'South',   NULL),
(5,  '2023-03-01', '2023-03-04', 'Standard',    'Shipped',    'Credit Card',  'Online',    'West',    NULL),

-- Duplicate order
(1,  '2023-01-15', '2023-01-18', 'Standard',    'Delivered',  'Credit Card',  'Online',    'East',    NULL),

-- Ship date BEFORE order date (logical error)
(10, '2023-04-15', '2023-04-10', 'Standard',    'Delivered',  'Credit Card',  'Online',    'East',    'Urgent order — backdated?'),

-- Future dates
(12, '2099-01-01', '2099-01-05', 'Standard',    'Processing', 'Credit Card',  'Online',    'East',    NULL),

-- Missing/null dates
(15, NULL,          NULL,         'Standard',    'Pending',    'Credit Card',  'Online',    'East',    NULL),
(16, '',            '',           'Express',     'Shipped',    NULL,           '',          NULL,      NULL),
(17, 'N/A',         'N/A',        NULL,          NULL,         'N/A',          'N/A',       'N/A',     'Bad record'),

-- Inconsistent date formats
(20, '03/15/2023',  '03/18/2023', 'Standard',    'Delivered',  'Credit Card',  'Online',    'East',    NULL),
(21, '15-Mar-2023', '18-Mar-2023','Express',     'Delivered',  'PayPal',       'Online',    'West',    NULL),
(22, '2023/04/01',  '2023/04/04', 'Standard',    'Delivered',  'Credit Card',  'In-Store',  'Central', NULL),
(23, 'April 5, 2023','April 8, 2023','Overnight','Delivered',  'Debit Card',   'Online',    'South',   NULL),

-- Status inconsistencies
(25, '2023-04-20', '2023-04-23', 'Standard',    'delivered',  'Credit Card',  'Online',    'East',    NULL),
(26, '2023-04-22', '2023-04-25', 'Express',     'DELIVERED',  'PayPal',       'Online',    'West',    NULL),
(27, '2023-04-25', NULL,         'Standard',    'Shiped',     'Credit Card',  'In-Store',  'Central', 'Typo in status'),
(28, '2023-05-01', NULL,         'Standard',    'Pendng',     'Debit Card',   'Online',    'South',   NULL),
(29, '2023-05-05', '2023-05-08', 'Express',     'Canceld',    'Credit Card',  'Online',    'East',    NULL),
(30, '2023-05-10', '2023-05-13', 'Standrd',     'Delivered',  'Crdit Card',   'Onlne',     'Wst',     'Multiple typos'),

-- Shipping method inconsistencies
(31, '2023-05-15', '2023-05-18', 'standard',    'Delivered',  'Credit Card',  'Online',    'East',    NULL),
(32, '2023-05-20', '2023-05-23', 'EXPRESS',     'Delivered',  'PayPal',       'Online',    'West',    NULL),
(33, '2023-05-25', '2023-05-26', 'Over Night',  'Delivered',  'Credit Card',  'In-Store',  'Central', NULL),
(34, '2023-06-01', '2023-06-04', '2-Day',       'Delivered',  'Debit Card',   'Online',    'South',   NULL),
(35, '2023-06-05', '2023-06-08', 'Two Day',     'Delivered',  'Credit Card',  'Online',    'East',    NULL);

-- Generate more orders procedurally
INSERT INTO orders
    (customer_id, order_date, ship_date, shipping_method, order_status, payment_method, sales_channel, region, notes)
SELECT
    -- Random customer_id (some may not exist — orphans)
    CASE (random()*20)::int
        WHEN 0 THEN 9999   -- orphan reference
        ELSE 1 + (random() * 199)::int
    END,
    -- Order date with format issues
    CASE (random()*8)::int
        WHEN 0 THEN TO_CHAR(DATE '2023-01-01' + (random()*365)::int, 'MM/DD/YYYY')
        WHEN 1 THEN TO_CHAR(DATE '2023-01-01' + (random()*365)::int, 'DD-Mon-YYYY')
        WHEN 2 THEN ''
        WHEN 3 THEN NULL
        ELSE TO_CHAR(DATE '2023-01-01' + (random()*365)::int, 'YYYY-MM-DD')
    END,
    -- Ship date (sometimes before order date for logical errors)
    CASE (random()*10)::int
        WHEN 0 THEN NULL
        WHEN 1 THEN ''
        WHEN 2 THEN TO_CHAR(DATE '2023-01-01' + (random()*365)::int - 10, 'YYYY-MM-DD')  -- possibly before order
        ELSE TO_CHAR(DATE '2023-01-01' + (random()*365)::int + (1 + (random()*7)::int), 'YYYY-MM-DD')
    END,
    -- Shipping method with inconsistencies
    CASE (random()*10)::int
        WHEN 0 THEN 'standard'
        WHEN 1 THEN 'EXPRESS'
        WHEN 2 THEN 'Over Night'
        WHEN 3 THEN 'Standrd'
        WHEN 4 THEN NULL
        WHEN 5 THEN '2-Day'
        ELSE (ARRAY['Standard','Express','Overnight','2-Day','Economy'])[1 + (random()*4)::int]
    END,
    -- Order status with issues
    CASE (random()*12)::int
        WHEN 0 THEN 'delivered'
        WHEN 1 THEN 'DELIVERED'
        WHEN 2 THEN 'Shiped'
        WHEN 3 THEN 'Pendng'
        WHEN 4 THEN 'Canceld'
        WHEN 5 THEN NULL
        WHEN 6 THEN 'Procesing'
        ELSE (ARRAY['Delivered','Shipped','Processing','Pending','Cancelled','Returned'])[1 + (random()*5)::int]
    END,
    -- Payment method
    CASE (random()*8)::int
        WHEN 0 THEN 'credit card'
        WHEN 1 THEN 'PAYPAL'
        WHEN 2 THEN 'Crdit Card'
        WHEN 3 THEN NULL
        ELSE (ARRAY['Credit Card','PayPal','Debit Card','Wire Transfer','Cash','Gift Card'])[1 + (random()*5)::int]
    END,
    -- Sales channel
    CASE (random()*6)::int
        WHEN 0 THEN 'online'
        WHEN 1 THEN 'IN-STORE'
        WHEN 2 THEN NULL
        ELSE (ARRAY['Online','In-Store','Phone','Wholesale'])[1 + (random()*3)::int]
    END,
    -- Region
    CASE (random()*8)::int
        WHEN 0 THEN 'east'
        WHEN 1 THEN 'WEST'
        WHEN 2 THEN NULL
        WHEN 3 THEN 'N/A'
        ELSE (ARRAY['East','West','Central','South','Northeast','Southeast','Northwest','Southwest'])[1 + (random()*7)::int]
    END,
    -- Notes (mostly null)
    CASE (random()*15)::int
        WHEN 0 THEN 'Customer called about this order'
        WHEN 1 THEN 'RUSH ORDER'
        WHEN 2 THEN 'Possible fraud — review needed'
        WHEN 3 THEN 'Gift wrapping requested'
        ELSE NULL
    END
FROM generate_series(1, 275);



-- STEP 6: INSERT MESSY ORDER ITEMS DATA (~500+ rows)


-- Hand-crafted problem rows
INSERT INTO order_items
    (order_id, product_id, quantity, unit_price, discount, total_amount)
VALUES
-- Normal
(1, 1,  '1',  '999.99',  '0',     '999.99'),
(1, 2,  '2',  '29.99',   '0',     '59.98'),
(2, 3,  '3',  '12.99',   '0.10',  '35.07'),    -- 12.99*3*0.9 = 35.073 (rounding issue)
(3, 4,  '1',  '349.99',  '0.15',  '297.49'),
(4, 5,  '1',  '599.99',  '0',     '599.99'),
(5, 6,  '10', '4.99',    '0.05',  '47.41'),

-- Total doesn't match qty * price * (1-discount) — intentional calculation error
(6, 1,  '1',  '999.99',  '0',     '899.99'),    -- should be 999.99
(6, 7,  '5',  '8.99',    '0',     '50.00'),     -- should be 44.95

-- Negative quantity
(7, 8,  '-2', '449.99',  '0',     '-899.98'),

-- Zero quantity
(7, 9,  '0',  '79.99',   '0',     '0'),

-- Quantity as text
(8, 10, 'two', '59.99',  '0',     '119.98'),
(8, 11, 'N/A', '299.99', 'N/A',   'N/A'),

-- Price with currency symbols
(9, 12, '3',  '$24.99',  '0',     '$74.97'),
(9, 13, '2',  '34.99$',  '5%',    '66.48'),

-- Discount as percentage string vs decimal
(10, 14, '1', '39.99',   '10%',   '35.99'),
(10, 15, '1', '39.99',   '0.10',  '35.99'),

-- Missing values
(11, 16, NULL,  '189.99',  NULL,    NULL),
(11, 17, '',    '89.99',   '',      ''),
(12, 18, '5',   NULL,      '0',     NULL),
(12, 19, '3',   '',        '0',     ''),

-- Extreme discount (>100% — error)
(13, 20, '1',  '19.99',   '1.5',   '-9.99'),

-- Very large quantity (outlier)
(14, 21, '10000', '3.99',  '0.25',  '29925.00'),

-- Duplicate item in same order
(15, 1,  '1',  '999.99',  '0',     '999.99'),
(15, 1,  '1',  '999.99',  '0',     '999.99'),

-- Orphan: order_id that doesn't exist
(99999, 2, '1', '29.99',  '0',     '29.99');


-- Generate more order items procedurally
INSERT INTO order_items
    (order_id, product_id, quantity, unit_price, discount, total_amount)
SELECT
    -- order_id
    1 + (random() * 299)::int,
    -- product_id
    1 + (random() * 49)::int,
    -- quantity with issues
    CASE (random()*15)::int
        WHEN 0 THEN '-1'
        WHEN 1 THEN '0'
        WHEN 2 THEN NULL
        WHEN 3 THEN ''
        WHEN 4 THEN 'N/A'
        ELSE (1 + (random()*20)::int)::text
    END,
    -- unit_price with issues
    CASE (random()*12)::int
        WHEN 0 THEN '$' || ROUND((random()*500)::numeric, 2)::text
        WHEN 1 THEN ROUND((random()*500)::numeric, 2)::text || '$'
        WHEN 2 THEN NULL
        WHEN 3 THEN ''
        WHEN 4 THEN '-' || ROUND((random()*100)::numeric, 2)::text
        ELSE ROUND((1 + random()*500)::numeric, 2)::text
    END,
    -- discount with issues
    CASE (random()*10)::int
        WHEN 0 THEN ((random()*30)::int)::text || '%'
        WHEN 1 THEN NULL
        WHEN 2 THEN ''
        WHEN 3 THEN 'N/A'
        WHEN 4 THEN ROUND((random()*0.5)::numeric, 2)::text
        ELSE '0'
    END,
    -- total_amount — often WRONG on purpose
    CASE (random()*8)::int
        WHEN 0 THEN NULL
        WHEN 1 THEN ''
        WHEN 2 THEN '$' || ROUND((random()*2000)::numeric, 2)::text
        WHEN 3 THEN 'N/A'
        ELSE ROUND((random()*2000)::numeric, 2)::text
    END
FROM generate_series(1, 480);


-- STEP 7: VERIFICATION QUERIES
-- Count rows in each table


DO $$
DECLARE
    c_count INT;
    p_count INT;
    o_count INT;
    i_count INT;
BEGIN
    SELECT COUNT(*) INTO c_count FROM customers;
    SELECT COUNT(*) INTO p_count FROM products;
    SELECT COUNT(*) INTO o_count FROM orders;
    SELECT COUNT(*) INTO i_count FROM order_items;

    
    RAISE NOTICE 'DATABASE POPULATION COMPLETE';
    
    RAISE NOTICE 'Customers:   % rows', c_count;
    RAISE NOTICE 'Products:    % rows', p_count;
    RAISE NOTICE 'Orders:      % rows', o_count;
    RAISE NOTICE 'Order Items: % rows', i_count;
    RAISE NOTICE 'TOTAL:       % rows', c_count + p_count + o_count + i_count;
    
END $$;