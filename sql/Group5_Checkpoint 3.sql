-- GROUP 5: PROJECT CHECKPOINT 3

-- [PART 1] Creating Tables (17 in total)
-- =====================
-- FOUNDATION TABLES (No dependencies)
-- =====================

-- 1. Locations (Store locations, assuming NY)
CREATE TABLE locations (
    location_id SERIAL PRIMARY KEY,
    location_name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    city VARCHAR(100),
    state CHAR(2),
    zip_code VARCHAR(10),
    opened_date DATE,
    type VARCHAR(20) CHECK (type IN ('Queens', 'Brooklyn', 'Manhattan', 'Other'))
);

-- 2. Suppliers (Including distributors and sellers)
CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    supplier_rating DECIMAL(3,2) CHECK (supplier_rating BETWEEN 0 AND 5),
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(20),
    notes TEXT
);

-- 3. Manufacturers (Product manufacturers, can be different from supplier)
CREATE TABLE manufacturers (
    manufacturer_id SERIAL PRIMARY KEY,
    manufacturer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone_number VARCHAR(20),
    notes TEXT
);

-- =====================
-- PRODUCT & SUPPLY CHAIN
-- =====================

-- 4. Products
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    unit_cost DECIMAL(10,2) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    expiration_days INT,
    manufacturer_id INT NOT NULL,
    supplier_id INT NOT NULL,
    FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(manufacturer_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

-- 5. Purchase Orders (Procurement)
CREATE TABLE purchase_orders (
    purchase_order_id SERIAL PRIMARY KEY,
    supplier_id INT NOT NULL,
	location_id INT NOT NULL,
    order_date DATE NOT NULL,
    delivery_date DATE,
    status VARCHAR(20) CHECK (status IN ('Ordered', 'Received', 'Cancelled')),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id),
	FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

-- 6. Deliveries (From suppliers, assuming ABC Foodmart doens't deliver to customers)
CREATE TABLE deliveries (
    delivery_id SERIAL PRIMARY KEY,
    purchase_order_id INT NOT NULL,
    supplier_id INT NOT NULL,
    expected_delivery_date DATE,
    delivery_date DATE NOT NULL,
    status VARCHAR(20) CHECK (status IN ('Scheduled','Delivered','Delayed')),
    FOREIGN KEY (purchase_order_id) REFERENCES purchase_orders(purchase_order_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

-- 7. Purchase Order Details
CREATE TABLE purchase_order_details (
    purchase_order_detail_id SERIAL PRIMARY KEY,
    purchase_order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_cost DECIMAL(10,2),
    FOREIGN KEY (purchase_order_id) REFERENCES purchase_orders(purchase_order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 8. Inventory
CREATE TABLE inventory (
    inventory_id SERIAL PRIMARY KEY,
    product_id INT NOT NULL,
    location_id INT NOT NULL,
    quantity INT NOT NULL,
    entry_date DATE NOT NULL,
    expiration_date DATE,
    purchase_order_id INT,
    delivery_id INT,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id),
    FOREIGN KEY (purchase_order_id) REFERENCES purchase_orders(purchase_order_id),
    FOREIGN KEY (delivery_id) REFERENCES deliveries(delivery_id)
);

-- =====================
-- PEOPLE & OPERATIONS
-- =====================

-- 9. Employees
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    location_id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    department VARCHAR(50),
    salary DECIMAL(10,2),
    hours_per_week DECIMAL(5,2),
    hire_date DATE,
    notes TEXT,
    FOREIGN KEY (location_id) REFERENCES location(location_id)
);

-- 10. Staffing
CREATE TABLE staffing (
    staffing_id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,
    location_id INT NOT NULL,
    shift_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    status VARCHAR(20) DEFAULT 'scheduled',
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

-- 11. Customers
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT,
    gender CHAR(1) CHECK (gender IN ('M','F','O')),
    email VARCHAR(100),
    location_id INT NOT NULL,
    loyalty_member BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

-- =====================
-- SALES & PROMOTIONS
-- =====================

-- 12. Promotions
CREATE TABLE promotions (
    promotion_id SERIAL PRIMARY KEY,
    promotion_name VARCHAR(100),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    target_product_id INT NOT NULL,
    location_id INT NOT NULL,
    discount_percentage DECIMAL(3,2) NOT NULL,
    loyalty_only BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (target_product_id) REFERENCES products(product_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

-- 13. Sales Orders
CREATE TABLE sales_orders (
    sale_order_id SERIAL PRIMARY KEY,
    order_date DATE NOT NULL,
    location_id INT NOT NULL,
    customer_id INT,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (location_id) REFERENCES locations(location_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- 14. Sale Order Details
CREATE TABLE sale_order_details (
    sale_order_detail_id SERIAL PRIMARY KEY,
    sale_order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    discount DECIMAL(5,2) DEFAULT 0,
    promotion_id INT,
    FOREIGN KEY (order_id) REFERENCES sales_orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (promotion_id) REFERENCES promotions(promotion_id)
);

-- =====================
-- FINANCIALS & RETURNS
-- =====================

-- 15. Transactions (Including sales and purchase)
CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    transaction_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    transaction_type VARCHAR(10) NOT NULL CHECK (transaction_type IN ('sale','purchase')),
    payment_type VARCHAR(50),
    sales_order_id INT,
    purchase_order_id INT,
    CHECK (
        (transaction_type = 'sale' AND sales_order_id IS NOT NULL AND purchase_order_id IS NULL)
        OR
        (transaction_type = 'purchase' AND purchase_order_id IS NOT NULL AND sales_order_id IS NULL)
    ),
    FOREIGN KEY (sales_order_id) REFERENCES sales_orders(order_id),
    FOREIGN KEY (purchase_order_id) REFERENCES purchase_orders(purchase_order_id)
);

-- 16. Expenses (Including procurement and other expenses)
CREATE TABLE expenses (
    expense_id SERIAL PRIMARY KEY,
    category VARCHAR(50) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    expense_date DATE NOT NULL,
    location_id INT,
    supplier_id INT,
    description TEXT,
    FOREIGN KEY (location_id) REFERENCES locations(location_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

-- 17. Returns
CREATE TABLE returns (
    return_id SERIAL PRIMARY KEY,
    order_detail_id INT NOT NULL,
    quantity_returned INT NOT NULL
    return_date DATE NOT NULL,
    reason TEXT,
    return_action VARCHAR(20) CHECK (return_action IN ('restocked', 'discarded', 'donated')),
    FOREIGN KEY (order_detail_id) REFERENCES sale_order_details(order_detail_id)
);


-- [PART 2] Creating Triggers and Functions (5 in total)
-- =====================
-- Triggers and Functions
-- =====================

-- ========== TRIGGER FUNCTION 1 ==========
-- Automatically update delivery status based on delivery_date vs expected_delivery_date
CREATE OR REPLACE FUNCTION update_delivery_status()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.delivery_date IS NULL THEN
        RETURN NEW;
    END IF;

    IF NEW.expected_delivery_date IS NULL THEN
        NEW.status := 'Delivered';  -- fallback if expected date missing
    ELSIF NEW.delivery_date <= NEW.expected_delivery_date THEN
        NEW.status := 'Delivered';
    ELSE
        NEW.status := 'Delayed';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_delivery_status
BEFORE UPDATE OF delivery_date ON deliveries
FOR EACH ROW
EXECUTE FUNCTION update_delivery_status();

-- ========== TRIGGER FUNCTION 2 ==========
-- Automatically update inventory.entry_date when a delivery is received
CREATE OR REPLACE FUNCTION update_inventory_entry_date()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE inventory
    SET entry_date = NEW.delivery_date
    WHERE delivery_id = NEW.delivery_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to run the function
CREATE TRIGGER trg_update_inventory_entry_date
AFTER UPDATE OF delivery_date ON deliveries
FOR EACH ROW
WHEN (NEW.delivery_date IS NOT NULL)
EXECUTE FUNCTION update_inventory_entry_date();

-- ========== TRIGGER FUNCTION 3 ==========
-- Automatically calculate total_amount in sales_orders
CREATE OR REPLACE FUNCTION update_sales_total()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE sales_orders
    SET total_amount = (
        SELECT SUM((unit_price - (unit_price * discount / 100)) * quantity)
        FROM sale_order_details
        WHERE order_id = NEW.order_id
    )
    WHERE order_id = NEW.order_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_sales_total
AFTER INSERT OR UPDATE OR DELETE ON sale_order_details
FOR EACH ROW
EXECUTE FUNCTION update_sales_total();

-- ========== TRIGGER FUNCTION 4 ==========
-- Automatically set expiration_date in inventory based from products
CREATE OR REPLACE FUNCTION set_inventory_expiration()
RETURNS TRIGGER AS $$
BEGIN
    SELECT NEW.entry_date + (p.expiration_days || ' days')::INTERVAL
    INTO NEW.expiration_date
    FROM products p
    WHERE p.product_id = NEW.product_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_inventory_expiration
BEFORE INSERT ON inventory
FOR EACH ROW
EXECUTE FUNCTION set_inventory_expiration();


-- ========== TRIGGER FUNCTION 5 ==========
-- Automate inventory tracking so it's not manual
-- Trigger and Function 5.1: Add inventory stock when a delivery is finalized from a purchase order
-- Function: update inventory on delivery
CREATE OR REPLACE FUNCTION upsert_inventory_from_delivery()
RETURNS TRIGGER AS $$
DECLARE
    v_location_id INT;
    product_row RECORD;
BEGIN
    -- Get the delivery location from the purchase order
    SELECT location_id INTO v_location_id
    FROM purchase_orders
    WHERE purchase_order_id = NEW.purchase_order_id;

    -- Loop through each product in the purchase order
    FOR product_row IN
        SELECT product_id, quantity
        FROM purchase_order_details
        WHERE purchase_order_id = NEW.purchase_order_id
    LOOP
        -- Try to update existing inventory
        UPDATE inventory
        SET quantity = quantity + product_row.quantity,
            entry_date = NEW.delivery_date
        WHERE product_id = product_row.product_id
          AND location_id = v_location_id;

        -- If no row exists, insert a new inventory record
        IF NOT FOUND THEN
            INSERT INTO inventory (
                product_id, location_id, quantity,
                entry_date, expiration_date,
                purchase_order_id, delivery_id
            )
            SELECT
                product_row.product_id,
                v_location_id,
                product_row.quantity,
                NEW.delivery_date,
                NEW.delivery_date + (p.expiration_days || ' days')::INTERVAL,
                NEW.purchase_order_id,
                NEW.delivery_id
            FROM products p
            WHERE p.product_id = product_row.product_id;
        END IF;
    END LOOP;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Trigger: when stock is inserted as 'Delivered'
CREATE TRIGGER trg_add_inventory_on_insert
AFTER INSERT ON deliveries
FOR EACH ROW
WHEN (NEW.status = 'Delivered')
EXECUTE FUNCTION upsert_inventory_from_delivery();

-- Trigger: after delivery is marked "Delivered"
CREATE TRIGGER trg_auto_add_inventory_from_delivery
AFTER UPDATE OF status ON deliveries
FOR EACH ROW
WHEN (NEW.status = 'Delivered')
EXECUTE FUNCTION upsert_inventory_from_delivery();

-- Function and Trigger 5.2: Subtract current inventory from sales orders
-- Function: subtract inventory on sale
CREATE OR REPLACE FUNCTION subtract_inventory_on_sale()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE inventory
    SET quantity = quantity - NEW.quantity
    WHERE product_id = NEW.product_id
      AND location_id = (
          SELECT location_id
          FROM sales_orders
          WHERE order_id = NEW.order_id
      );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger: after a new sale order detail is added
CREATE TRIGGER trg_subtract_inventory_on_sale
AFTER INSERT ON sale_order_details
FOR EACH ROW
EXECUTE FUNCTION subtract_inventory_on_sale();
