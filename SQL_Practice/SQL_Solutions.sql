-- 正後的任務1
-- 任務1：每日營收趨勢（基礎）
-- 請寫一個查詢，計算2024年12月每一天的：
-- 1.訂單數
-- 2.總營收
-- 3.平均客單價
-- 4.較前一天的營收成長率

提示：成長率可以用 LAG() 窗口函數
WITH daily_stats AS (
    SELECT
        order_date,
        SUM(amount) AS 總營收,
        COUNT(order_id) AS 總訂單數,
        SUM(amount) / NULLIF(COUNT(order_id), 0) AS 平均客單價
    FROM orders
    WHERE order_date >= '2024-12-01' 
      AND order_date < '2025-01-01'
    GROUP BY order_date
)
SELECT 
    order_date,
    總營收,
    總訂單數,
    平均客單價,
    -- 較前一天的營收成長率
    ROUND(
        (總營收 - LAG(總營收) OVER (ORDER BY order_date)) 
        / NULLIF(LAG(總營收) OVER (ORDER BY order_date), 0) 
        * 100, 
        2
    ) AS 成長率百分比
FROM daily_stats
ORDER BY order_date;
-- 正後的任務1完


-- 任務2：產品類別分析（中階）
-- 計算2024年12月每個產品類別的：
-- 1.總營收
-- 2.營收佔比（佔全公司百分比）
-- 3.訂單數
-- 4.平均訂單金額
-- 5.按營收排序

WITH products_stats AS (
    SELECT 
        p.category AS 產品類別,
        COUNT(o.order_id) AS 訂單數,
        SUM(o.amount) AS 類別營收,
        AVG(o.amount) AS 平均訂單金額,
        -- 計算總營收（窗口函數）
        SUM(SUM(o.amount)) OVER() AS 總營收,
        -- 營收佔比
        ROUND(
            SUM(o.amount) * 100.0 / NULLIF(SUM(SUM(o.amount)) OVER(), 0), 
            2
        ) AS 營收佔比百分比
    FROM orders o
    JOIN products p ON o.product_category = p.category
    WHERE o.order_date >= '2024-12-01' 
      AND o.order_date < '2025-01-01'
    GROUP BY p.category
)
SELECT 
    產品類別,
    訂單數,
    類別營收,
    平均訂單金額,
    營收佔比百分比
FROM products_stats
ORDER BY 類別營收 DESC;


-- 任務3：新舊客戶對比（進階）
-- 比較新客戶 vs 舊客戶在12月的表現：
-- 各自的總營收
-- 各自的訂單數
-- 各自的平均客單價
-- 新客戶佔總營收的百分比

WITH customer_compare AS (
    SELECT 
        is_new_customer,
        SUM(amount) AS 總營收,
        COUNT(order_id) AS 總訂單數,
        AVG(amount) AS 平均客單價,
        -- 各自的總營收（窗口函數）
        SUM(SUM(amount)) OVER() AS 總計營收,
        -- 新客戶佔總營收的百分比
        ROUND(
            SUM(amount) * 100.0 / NULLIF(SUM(SUM(amount)) OVER(), 0), 
            2
        ) AS 營收佔比百分比
    FROM orders
    WHERE order_date >= '2024-12-01' 
      AND order_date < '2025-01-01'
    GROUP BY is_new_customer
)

SELECT 
    CASE WHEN is_new_customer = 1 THEN '新客戶' ELSE '舊客戶' END AS 客戶類型,
    總營收,
    總訂單數,
    平均客單價,
    營收佔比百分比
FROM customer_compare
ORDER BY 營收佔比百分比 DESC;


    
    
    



