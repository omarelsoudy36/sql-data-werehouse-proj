/*
========================================================================
Create Database and Schemas Securely
========================================================================
Script Purpose:
   This script configures the storage environment for the Medallion Architecture.
   It ensures that the database 'DataWarehouse' exists without losing any 
   current configurations, and creates three main logical layers (schemas)
   within the database if they are not already present: 'bronze', 'silver', and 'gold'.

Safety Feature:
   Unlike destructive scripts, this execution is completely SAFE. It checks 
   for the existence of the database and schemas first. It will NOT drop or 
   delete any existing data or objects.
*/
/*
========================================================================
إنشاء قاعدة البيانات والأسكيما بشكل آمن
========================================================================
الغرض من السكريبت:
   هذا السكريبت يقوم بتجهيز البيئة البرمجية لتقسيم البيانات (Medallion Architecture).
   يتأكد أولاً من وجود قاعدة البيانات 'DataWarehouse' دون مسحها، ثم يقوم بإنشاء
   ثلاث طبقات تنظيمية (Schemas) داخلها وهي: 'bronze' و 'silver' و 'gold'.

ميزة الأمان في هذا الكود:
   على عكس الأكواد التي تحذف البيانات (Drop)، هذا السكريبت آمن تماماً 100%.
   يقوم بالفحص أولاً، وإذا وجد قاعدة البيانات أو الأسكيما موجودة مسبقاً، يتخطاها
   ويكمل عمله دون أن يحذف أي شيء ودون أن يظهر أي رسائل خطأ حمراء.
*/
USE master;
GO

-- Check and create the 'DataWarehouse' database safely
IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    CREATE DATABASE DataWarehouse;
END
GO

-- Switch the context to the target database
USE DataWarehouse;
GO

-- Check and create the Bronze Schema (Raw Data Layer)
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'bronze')
BEGIN
    EXEC('CREATE SCHEMA bronze');
END
GO

-- Check and create the Silver Schema (Cleaned & Validated Layer)
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'silver')
BEGIN
    EXEC('CREATE SCHEMA silver');
END
GO

-- Check and create the Gold Schema (Business & Analytical Layer)
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'gold')
BEGIN
    EXEC('CREATE SCHEMA gold');
END
GO
