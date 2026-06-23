/*
====================================================================================================
العملية: إجراء تحميل بيانات طبقة البرونز (Bronze ETL Load Process).
الوصف والفائدة:
1. أتمتة عملية استيراد البيانات الخام من الملفات النصية (CSV) إلى جداول قاعدة البيانات مباشرة.
2. تصفير الجداول (Truncate) قبل كل عملية شحن لضمان عدم تكرار البيانات والحفاظ على أحدث نسخة.
3. حساب الوقت المستغرق في عملية التحميل بالثواني لمراقبة أداء خطوط نقل البيانات وتقييم كفاءتها.
4. معالجة الأخطاء (Error Handling) عبر تجميع تفاصيل المشاكل وطباعتها لتسهيل الصيانة والمتابعة.
5. توفير آلية تشغيل موحدة (Single Execution Point) لجميع جداول الأنظمة المصدرية بضغطة زر واحدة.

Operation: Bronze Layer ETL Data Loading Process.
Description & Benefits:
1. Automating raw data ingestion from external CSV files directly into warehouse staging tables.
2. Truncating target tables prior to loading to prevent data duplication and maintain freshness.
3. Calculating total execution time in seconds to monitor pipeline performance and efficiency.
4. Embedding robust error handling to capture, log, and debug runtime failures seamlessly.
5. Providing a single execution point to orchestrate full staging loads for all source systems.
====================================================================================================
*/
USE DataWarehouse;
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN

    DECLARE @FRIST_start_time DATETIME, @LAST_END_time DATETIME;
    
    BEGIN TRY
        SET @FRIST_start_time = GETDATE();
        PRINT '===================================================';
        PRINT 'LOADING BRONZE LAYER';
        PRINT '===================================================';

        PRINT '----------------------------------------------------';
        PRINT 'LOADING CRM TABLES';
        PRINT '----------------------------------------------------';
        
        -- الكود ده هيصفر الجدول علشان لو عملت رن البينات هتتحط فوق البينات
        PRINT '>> Truncating and Loading: bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;   
        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\andalosya\Desktop\sql-data-warehouse-project-main\datasets\source_crm/cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        PRINT '>> Truncating and Loading: bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;   
        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\andalosya\Desktop\sql-data-warehouse-project-main\datasets\source_crm/prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        PRINT '>> Truncating and Loading: bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;   
        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\andalosya\Desktop\sql-data-warehouse-project-main\datasets\source_crm/sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        PRINT '----------------------------------------------------';
        PRINT 'LOADING ERP TABLES';
        PRINT '----------------------------------------------------';
        
        PRINT '>> Truncating and Loading: bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;   
        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Users\andalosya\Desktop\sql-data-warehouse-project-main\datasets\source_erp/cust_az12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        PRINT '>> Truncating and Loading: bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;   
        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\Users\andalosya\Desktop\sql-data-warehouse-project-main\datasets\source_erp/LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        PRINT '>> Truncating and Loading: bronze.erp_px_cat_giv2';
        TRUNCATE TABLE bronze.erp_px_cat_giv2;   
        BULK INSERT bronze.erp_px_cat_giv2
        FROM 'C:\Users\andalosya\Desktop\sql-data-warehouse-project-main\datasets\source_erp/PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @LAST_END_time = GETDATE();
        PRINT '===================================================';
        PRINT 'LOADING BRONZE LAYER IS COMPLETE';
        PRINT 'TOTAL LOADING TIME: ' + CAST(DATEDIFF(SECOND, @FRIST_start_time, @LAST_END_time) AS NVARCHAR) + ' SECONDS';
        PRINT '===================================================';

    END TRY
    BEGIN CATCH
        PRINT '======================================='
        PRINT 'ERROR DURING LOADING BRONZE LAYER'
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '======================================='
    END CATCH
END
