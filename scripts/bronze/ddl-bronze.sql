/*
====================================================================================================
العملية: إنشاء الجداول الخام (Raw Tables) داخل طبقة البرونز (Bronze Schema) لمستودع البيانات.
الوصف والفائدة:
1. بناء البنية التحتية الأساسية لاستقبال البيانات القادمة من الأنظمة المصدرية المختلفة (CRM & ERP).
2. الاحتفاظ بنسخة مطابقة للبيانات الأصلية دون إجراء أي تعديلات أو فلاتر للحفاظ على سلامة التاريخ الإحصائي.
3. توفير نقطة انطلاق موحدة ومؤمنة لعمليات التنظيف والتحويل اللاحقة في طبقة الفضة (Silver Layer).
4. تحسين أداء عمليات التحميل (Data Loading) بفصل مرحلة الاستخراج والرفع عن مرحلة المعالجة المعقدة.
5. تسهيل عملية تتبع الأخطاء (Lineage & Debugging) وإعادة بناء البيانات في حال حدوث أي خلل مستقبلي.

Operation: Creating Raw Tables within the Bronze Schema for the Data Warehouse.
Description & Benefits:
1. Establishing the core infrastructure to ingest raw data from diverse source systems (CRM & ERP).
2. Preserving an exact replica of source data without transformations to maintain historical integrity.
3. Providing a unified landing zone for subsequent data cleaning and transformation in the Silver Layer.
4. Optimizing data loading performance by decoupling data extraction from complex analytical processing.
5. Facilitating easier lineage tracking, debugging, and data reprocessing in case of future pipeline failures.
====================================================================================================
*/

-- كود إنشاء جدول بيانات العملاء الخام (Customer Info) داخل أسكيما البرونز
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
BEGIN
    DROP TABLE bronze.crm_cust_info;
END

CREATE TABLE bronze.crm_cust_info (
    cst_id             INT,
    cst_key            NVARCHAR(50),
    cst_firstname      NVARCHAR(50),
    cst_lastname       NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gndr           NVARCHAR(50),
    cst_create_date    DATE
);

IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
BEGIN
    DROP TABLE bronze.crm_prd_info;
END

-- كود إنشاء جدول بيانات المنتجات الخام داخل أسكيما البرونز
CREATE TABLE bronze.crm_prd_info (
    prd_id        INT,
    prd_key       NVARCHAR(50),
    prd_nm        NVARCHAR(50),
    prd_cost      INT,            -- تم اختياره كـ INT بناءً على شرح المحاضر للتكلفة، ويمكن تغييره لـ DECIMAL لو بها كسور
    prd_line      NVARCHAR(50),
    prd_start_dt  DATE,
    prd_end_dt    DATE
);

IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
BEGIN
    DROP TABLE bronze.crm_sales_details;
END

-- كود إنشاء جدول بيانات المبيعات الخام داخل أسكيما البرونز
CREATE TABLE bronze.crm_sales_details (
    sls_ord_num     NVARCHAR(50),   -- رقم الفاتورة/الطلب (تم اختيار نصي لاحتمالية وجود حروف)
    sls_prd_key     NVARCHAR(50),   -- مفتاح المنتج للربط مع جدول المنتجات
    sls_cust_id     INT,            -- رقم العميل للربط مع جدول العملاء
    sls_order_dt    INT,            -- تاريخ الطلب
    sls_ship_dt     INT,            -- تاريخ الشحن
    sls_due_dt      INT,            -- تاريخ الاستحقاق
    sls_sales       INT,            -- إجمالي قيمة المبيعات (أو DECIMAL لو بها كسور)
    sls_quantity    INT,            -- الكمية المباعة
    sls_price       INT             -- سعر الوحدة (أو DECIMAL لو بها كسور)
);

IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
BEGIN
    DROP TABLE bronze.erp_loc_a101;
END

CREATE TABLE bronze.erp_loc_a101 (
    CID   NVARCHAR(50),
    CNTRY NVARCHAR(50)
);

IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
BEGIN
    DROP TABLE bronze.erp_cust_az12;
END

CREATE TABLE bronze.erp_cust_az12 (
    CID   NVARCHAR(50),   -- رقم معرّف العميل في نظام الـ ERP
    BDATE DATE,           -- تاريخ الميلاد (Birth Date)
    GEN   NVARCHAR(50)    -- الجنس (Gender)
);

IF OBJECT_ID('bronze.erp_px_cat_giv2', 'U') IS NOT NULL
BEGIN
    DROP TABLE bronze.erp_px_cat_giv2;
END

CREATE TABLE bronze.erp_px_cat_giv2 (
    ID          NVARCHAR(50),   -- معرّف الموقع أو الفئة
    CAT         NVARCHAR(50),   -- الفئة الرئيسية (Category)
    SUBCAT      NVARCHAR(50),   -- الفئة الفرعية (Subcategory)
    MAINTENANCE NVARCHAR(50)    -- حالة الصيانة أو التشغيل
);
