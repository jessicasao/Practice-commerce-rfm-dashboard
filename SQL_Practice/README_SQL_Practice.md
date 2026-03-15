# SQL 練習題：電商 RFM 客戶價值分析

這是與 Power BI 儀表板搭配的 SQL 練習題，從資料提取到分析，完整呈現數據分析流程。

## 📊 資料表結構

```sql
orders 訂單表
- order_id (訂單ID)
- customer_id (客戶ID)
- order_date (訂單日期)
- amount (訂單金額)
- product_category ( '電子', '服裝', '食品', '家居' )
- is_new_customer ( 1=新客戶, 0=舊客戶 )

products 產品表
- product_id
- product_name
- category
- price
