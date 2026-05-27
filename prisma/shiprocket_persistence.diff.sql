-- AlterTable
ALTER TABLE `shipment` ADD COLUMN `lastTrackedAt` DATETIME(3) NULL,
    ADD COLUMN `pickupId` VARCHAR(191) NULL;

-- CreateTable
CREATE TABLE `WebhookLog` (
    `id` VARCHAR(191) NOT NULL,
    `provider` VARCHAR(191) NOT NULL DEFAULT 'SHIPROCKET',
    `eventType` VARCHAR(191) NOT NULL DEFAULT 'STATUS_UPDATE',
    `orderId` VARCHAR(191) NULL,
    `awb` VARCHAR(191) NULL,
    `shipmentId` VARCHAR(191) NULL,
    `headers` JSON NULL,
    `payload` JSON NOT NULL,
    `receivedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `processed` BOOLEAN NOT NULL DEFAULT false,
    `processedAt` DATETIME(3) NULL,
    `processingError` VARCHAR(191) NULL,
    `attempts` INTEGER NOT NULL DEFAULT 0,
    `lastAttemptAt` DATETIME(3) NULL,
    `nextRetryAt` DATETIME(3) NULL,

    INDEX `WebhookLog_provider_idx`(`provider`),
    INDEX `WebhookLog_orderId_idx`(`orderId`),
    INDEX `WebhookLog_awb_idx`(`awb`),
    INDEX `WebhookLog_processed_idx`(`processed`),
    INDEX `WebhookLog_receivedAt_idx`(`receivedAt`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `ShipmentTrackingEvent` (
    `id` VARCHAR(191) NOT NULL,
    `provider` VARCHAR(191) NOT NULL DEFAULT 'SHIPROCKET',
    `source` VARCHAR(191) NOT NULL DEFAULT 'WEBHOOK',
    `orderId` VARCHAR(191) NULL,
    `awb` VARCHAR(191) NULL,
    `shipmentId` VARCHAR(191) NULL,
    `status` VARCHAR(191) NOT NULL,
    `eventTime` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `raw` JSON NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `ShipmentTrackingEvent_orderId_idx`(`orderId`),
    INDEX `ShipmentTrackingEvent_awb_idx`(`awb`),
    INDEX `ShipmentTrackingEvent_shipmentId_idx`(`shipmentId`),
    INDEX `ShipmentTrackingEvent_eventTime_idx`(`eventTime`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `FailedShipment` (
    `id` VARCHAR(191) NOT NULL,
    `provider` VARCHAR(191) NOT NULL DEFAULT 'SHIPROCKET',
    `orderId` VARCHAR(191) NOT NULL,
    `stage` VARCHAR(191) NOT NULL,
    `payload` JSON NULL,
    `errorMessage` VARCHAR(191) NOT NULL,
    `errorDetails` JSON NULL,
    `attempts` INTEGER NOT NULL DEFAULT 0,
    `lastAttemptAt` DATETIME(3) NULL,
    `resolved` BOOLEAN NOT NULL DEFAULT false,
    `resolvedAt` DATETIME(3) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `FailedShipment_orderId_idx`(`orderId`),
    INDEX `FailedShipment_stage_idx`(`stage`),
    INDEX `FailedShipment_resolved_idx`(`resolved`),
    INDEX `FailedShipment_createdAt_idx`(`createdAt`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

