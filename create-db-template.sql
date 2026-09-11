CREATE TABLE products (
    product_no integer PRIMARY KEY,
    name varchar,
    price numeric
);

CREATE TABLE customers (
    customer_id integer PRIMARY KEY,
    name varchar,
    address varchar
);

CREATE TABLE orders (
    order_id integer PRIMARY KEY,
    ordered_when date
);

CREATE TABLE order_items (
    order_items_id integer PRIMARY KEY,
    order_id integer REFERENCES orders (order_id),
    product_no integer REFERENCES products (product_no),
    quantity integer
);

CREATE TABLE customer_orders (
    customer_orders_id integer PRIMARY KEY,
    customer_id integer REFERENCES customers (customer_id),
    order_id integer REFERENCES orders (order_id)
);

INSERT INTO
    products (product_no, name, price)
VALUES (1, 'Macbook Pro', 1999.00),
    (2, 'iPhone 17', 999.00),
    (3, 'AirPods Pro', 249.00),
    (4, 'iPad Air', 599.00),
    (5, 'Apple Watch', 399.00),
    (6, 'Magic Keyboard', 299.00);

INSERT INTO
    customers (customer_id, name, address)
VALUES (
        101,
        'John Doe',
        '123 Main St'
    ),
    (
        102,
        'Jane Smith',
        '456 Elm St'
    ),
    (
        103,
        'Alice Johnson',
        '789 Oak St'
    ),
    (
        104,
        'Bob Brown',
        '321 Pine St'
    ),
    (
        105,
        'Charlie Davis',
        '654 Maple St'
    ),
    (
        106,
        'Eve Wilson',
        '987 Cedar St'
    );

INSERT INTO
    orders (order_id, ordered_when)
VALUES (1001, CURRENT_DATE),
    (1002, CURRENT_DATE),
    (1003, CURRENT_DATE - 1),
    (1004, CURRENT_DATE - 2),
    (1005, CURRENT_DATE),
    (1006, CURRENT_DATE - 5);

INSERT INTO
    customer_orders (
        customer_orders_id,
        customer_id,
        order_id
    )
VALUES (1, 101, 1001),
    (2, 102, 1002),
    (3, 103, 1003),
    (4, 104, 1004),
    (5, 101, 1005),
    (6, 106, 1006);

INSERT INTO
    order_items (
        order_items_id,
        order_id,
        product_no,
        quantity
    )
VALUES (1, 1001, 1, 1),
    (2, 1001, 3, 2),
    (3, 1002, 2, 1),
    (4, 1002, 3, 1),
    (5, 1003, 4, 1),
    (6, 1003, 5, 1),
    (7, 1004, 1, 1),
    (8, 1004, 6, 1),
    (9, 1005, 2, 1),
    (10, 1005, 5, 1),
    (11, 1006, 3, 1),
    (12, 1006, 6, 1);

# recursive subquery to find all products ordered by a specific customer (customer_id = 101)
SELECT *
FROM products
WHERE
    product_no IN (
        SELECT product_no
        FROM public.order_items
        WHERE
            order_id IN (
                SELECT order_id
                FROM public.customer_orders
                WHERE
                    customer_id IN (
                        SELECT customer_id
                        FROM public.customers
                        WHERE
                            customer_id = 101
                    )
            )
    );

# using joins
SELECT p.*
FROM public.products p
JOIN public.order_items oi
  ON p.product_no = oi.product_no
JOIN public.customer_orders co
  ON oi.order_id = co.order_id
JOIN public.customers c
  ON co.customer_id = c.customer_id
WHERE c.customer_id = 101;

# Vertices, Edges
# Vertices are points or nodes that are connected by edges in a graph.

CREATE PROPERTY GRAPH myshop
  VERTEX TABLES (
    products LABEL product,
    customers LABEL customer,
    orders LABEL "order"
  )
  EDGE TABLES (
    order_items 
      SOURCE orders 
      DESTINATION products 
      LABEL contains,
    customer_orders 
      SOURCE customers 
      DESTINATION orders
      LABEL has_placed
  );

SELECT *
FROM GRAPH_TABLE (
        myshop MATCH (
            c IS customer
            WHERE
                c.customer_id = 101
        ) - [IS has_placed] -> (o IS "order") - [IS contains] -> (p IS product) COLUMNS (p.product_no, p.name, p.price)
    );