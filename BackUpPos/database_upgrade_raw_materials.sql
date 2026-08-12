-- ============================================================================
-- DATABASE UPGRADE SCRIPT
-- Raw Material / Recipe (BOM) Tracking for E-Menu Items
-- Version: 1.0
-- Date: 2026-08-11
-- ============================================================================

-- BACKUP DATABASE DULU SEBELUM JALANKAN SCRIPT INI!
-- mysqldump -u root -p database_name > backup_before_raw_materials.sql

-- ============================================================================
-- PART 1: NEW TABLES (3 Tables)
-- ============================================================================

-- 1. app_raw_materials - Raw material / ingredient master
CREATE TABLE app_raw_materials (
    material_id   INT AUTO_INCREMENT PRIMARY KEY,
    material_name VARCHAR(100) NOT NULL,
    unit          VARCHAR(20)  NOT NULL,   -- 'gram', 'pcs', 'ml'
    stock_qty     DECIMAL(12,3) NOT NULL DEFAULT 0,
    reorder_level DECIMAL(12,3) NULL,
    is_active     TINYINT(1) NOT NULL DEFAULT 1,
    created_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at    DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SELECT '✅ Table app_raw_materials created successfully' AS status;

-- 2. app_menu_recipes - Menu item -> raw material BOM/recipe
CREATE TABLE app_menu_recipes (
    recipe_id     INT AUTO_INCREMENT PRIMARY KEY,
    item_code     VARCHAR(60) NOT NULL,    -- icitem.ITEMNO
    material_id   INT NOT NULL,            -- app_raw_materials.material_id
    qty_per_unit  DECIMAL(12,3) NOT NULL,  -- e.g. 0.150 kg beef per 1 burger
    created_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_item_material (item_code, material_id),
    INDEX idx_item_code (item_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SELECT '✅ Table app_menu_recipes created successfully' AS status;

-- 3. app_material_usage_log - Consumption history per order line
CREATE TABLE app_material_usage_log (
    usage_id     INT AUTO_INCREMENT PRIMARY KEY,
    order_id     INT NOT NULL,
    item_id      INT NOT NULL,            -- app_order_items.item_id
    material_id  INT NOT NULL,
    qty_used     DECIMAL(12,3) NOT NULL,
    used_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_order (order_id),
    INDEX idx_material (material_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SELECT '✅ Table app_material_usage_log created successfully' AS status;

-- ============================================================================
-- PART 2: UPDATE EXISTING TABLE (1 Table)
-- ============================================================================

-- 4. app_order_items - Track whether recipe stock has been deducted per line
ALTER TABLE app_order_items
    ADD COLUMN materials_deducted CHAR(1) NOT NULL DEFAULT 'N' COMMENT 'Y once recipe stock has been deducted for this line';

SELECT '✅ Table app_order_items updated successfully' AS status;

-- ============================================================================
-- PART 3: PERMISSION COLUMNS FOR THE TWO NEW MAINTENANCE SCREENS
-- ============================================================================
-- Follows the existing userpin2 convention (see latest/maintenance/materialProfile.cfm
-- and brandProfile.cfm): one row per user "level", one column per menu-screen action.
-- H70001 = Raw Material Profile, H70002 = Menu Recipe (BOM) Profile.
-- _3a = create, _3b = show edit/delete column, _3c = print.
-- Defaults to 'T' (visible/usable) for every existing level so the screens are usable
-- immediately after migration; lock down per-level access afterwards via the normal
-- user-permission admin screen if desired.

ALTER TABLE userpin2
    ADD COLUMN H70001_3a CHAR(1) NOT NULL DEFAULT 'T' COMMENT 'Raw Material Profile - create',
    ADD COLUMN H70001_3b CHAR(1) NOT NULL DEFAULT 'T' COMMENT 'Raw Material Profile - edit/delete',
    ADD COLUMN H70001_3c CHAR(1) NOT NULL DEFAULT 'T' COMMENT 'Raw Material Profile - print',
    ADD COLUMN H70002_3a CHAR(1) NOT NULL DEFAULT 'T' COMMENT 'Menu Recipe Profile - create',
    ADD COLUMN H70002_3b CHAR(1) NOT NULL DEFAULT 'T' COMMENT 'Menu Recipe Profile - edit/delete',
    ADD COLUMN H70002_3c CHAR(1) NOT NULL DEFAULT 'T' COMMENT 'Menu Recipe Profile - print';

SELECT '✅ Table userpin2 updated successfully' AS status;

-- ============================================================================
-- PART 4: SIDEBAR MENU ENTRIES (run against the `main` schema, not the branch)
-- ============================================================================
-- Adds the two new screens as tiles under "Item Leveling" (menu_id 10200), next to
-- Brand/Category/Group/Material/Model/Rating/Size Profile — same place the examiner
-- will look, since it's the existing "profile" tile group.
--
-- IMPORTANT: main.menunew2 is a single table SHARED across every branch/client on this
-- server (see CLAUDE.md). Before inserting, verify these two IDs are actually free:
--
--   SELECT * FROM main.menunew2 WHERE menu_id IN ('70101','70102');
--
-- If that returns any rows, STOP and pick different, unused MENU_ID values instead
-- (edit '70101'/'70102' below to match), then also update the two rawMaterialProfile.cfm
-- and menuRecipeProfile.cfm menuID= links if you want them to match exactly (cosmetic only).

-- 5. Bare per-screen visibility flags in userpin2 (run against the branch schema).
--    Distinct from the H70001_3a/H70002_3a action-level columns added in Part 3 above:
--    this pair gates whether the tile even appears in the "Item Leveling" hub page.
ALTER TABLE userpin2
    ADD COLUMN H70101 CHAR(1) NOT NULL DEFAULT 'T' COMMENT 'Raw Material Profile - menu visibility',
    ADD COLUMN H70102 CHAR(1) NOT NULL DEFAULT 'T' COMMENT 'Menu Recipe Profile - menu visibility';

SELECT '✅ Table userpin2 (menu visibility) updated successfully' AS status;

-- 6. Menu catalog rows (run against the `main` schema).
INSERT INTO main.menunew2
    (MENU_ID, MENU_NAME, MENU_URL, MENU_CATEGORY, MENU_STATUS, MENU_LEVEL, MENU_PARENT_LEVEL,
     MENU_NAME2, MENU_PARENT_ID, MENU_ORDER, MENU_HEIGHT, MENU_WIDTH, CREATED_BY, UPDATED_BY,
     CREATED_ON, UPDATED_ON, USERPIN_ID)
VALUES
    ('70101', 'Raw Material Profile', '/maintenance/rawMaterialProfile.cfm?menuID=70101', '', '', 3, 0,
     '', '10200', 8, 0, 0, '', '', NOW(), NOW(), 'h70101'),
    ('70102', 'Menu Recipe Profile', '/maintenance/menuRecipeProfile.cfm?menuID=70102', '', '', 3, 0,
     '', '10200', 9, 0, 0, '', '', NOW(), NOW(), 'h70102');

SELECT '✅ Table main.menunew2 updated successfully' AS status;

-- ============================================================================
-- PART 5: USAGE REPORT SCREEN (materialUsageReport.cfm) — same pattern as Part 4
-- ============================================================================
-- Verify first (run against `main`): SELECT * FROM main.menunew2 WHERE menu_id = '70103';

-- Branch schema:
ALTER TABLE userpin2
    ADD COLUMN H70103 CHAR(1) NOT NULL DEFAULT 'T' COMMENT 'Material Usage Report - menu visibility';

-- main schema:
INSERT INTO main.menunew2
    (MENU_ID, MENU_NAME, MENU_URL, MENU_CATEGORY, MENU_STATUS, MENU_LEVEL, MENU_PARENT_LEVEL,
     MENU_NAME2, MENU_PARENT_ID, MENU_ORDER, MENU_HEIGHT, MENU_WIDTH, CREATED_BY, UPDATED_BY,
     CREATED_ON, UPDATED_ON, USERPIN_ID)
VALUES
    ('70103', 'Raw Material Usage Report', '/maintenance/materialUsageReport.cfm?menuID=70103', '', '', 3, 0,
     '', '10200', 10, 0, 0, '', '', NOW(), NOW(), 'h70103');

-- ============================================================================
-- PART 6: CONSUMPTION SUMMARY SCREEN (materialConsumptionSummary.cfm)
-- ============================================================================
-- Verify first (run against `main`): SELECT * FROM main.menunew2 WHERE menu_id = '70104';

-- Branch schema:
ALTER TABLE userpin2
    ADD COLUMN H70104 CHAR(1) NOT NULL DEFAULT 'T' COMMENT 'Material Consumption Summary - menu visibility';

-- main schema:
INSERT INTO main.menunew2
    (MENU_ID, MENU_NAME, MENU_URL, MENU_CATEGORY, MENU_STATUS, MENU_LEVEL, MENU_PARENT_LEVEL,
     MENU_NAME2, MENU_PARENT_ID, MENU_ORDER, MENU_HEIGHT, MENU_WIDTH, CREATED_BY, UPDATED_BY,
     CREATED_ON, UPDATED_ON, USERPIN_ID)
VALUES
    ('70104', 'Raw Material Consumption Summary', '/maintenance/materialConsumptionSummary.cfm?menuID=70104', '', '', 3, 0,
     '', '10200', 11, 0, 0, '', '', NOW(), NOW(), 'h70104');

-- ============================================================================
-- NOTES
-- ============================================================================
-- - No foreign key constraints, consistent with the rest of the app_* tables;
--   referential integrity (item_code exists in icitem, material_id exists in
--   app_raw_materials) must be validated in application code.
-- - app_menu_recipes is optional per item_code: menu items with no rows here
--   are unrestricted by stock checks (backward compatible with existing menu).
