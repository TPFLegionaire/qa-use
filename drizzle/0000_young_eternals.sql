CREATE TABLE `suite` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`name` text NOT NULL,
	`created_at` integer NOT NULL,
	`cron_cadence` text,
	`last_cron_run_at` integer,
	`notifications_email_address` text
);
--> statement-breakpoint
CREATE TABLE `suite_run` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`created_at` integer NOT NULL,
	`started_at` integer,
	`finished_at` integer,
	`suite_id` integer NOT NULL,
	`status` text NOT NULL,
	FOREIGN KEY (`suite_id`) REFERENCES `suite`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE TABLE `test` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`created_at` integer NOT NULL,
	`label` text NOT NULL,
	`evaluation` text NOT NULL,
	`suite_id` integer NOT NULL,
	FOREIGN KEY (`suite_id`) REFERENCES `suite`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE TABLE `test_run` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`created_at` integer NOT NULL,
	`started_at` integer,
	`finished_at` integer,
	`test_id` integer NOT NULL,
	`suite_run_id` integer,
	`status` text NOT NULL,
	`error` text,
	`browser_use_id` text,
	`live_url` text,
	`public_share_url` text,
	FOREIGN KEY (`test_id`) REFERENCES `test`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`suite_run_id`) REFERENCES `suite_run`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE TABLE `test_run_step` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`test_run_id` integer NOT NULL,
	`step_id` integer NOT NULL,
	`status` text NOT NULL,
	FOREIGN KEY (`test_run_id`) REFERENCES `test_run`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`step_id`) REFERENCES `test_step`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE UNIQUE INDEX `test_run_step_unique` ON `test_run_step` (`test_run_id`,`step_id`);--> statement-breakpoint
CREATE TABLE `test_step` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`created_at` integer NOT NULL,
	`test_id` integer NOT NULL,
	`order` integer NOT NULL,
	`description` text NOT NULL,
	FOREIGN KEY (`test_id`) REFERENCES `test`(`id`) ON UPDATE no action ON DELETE cascade
);
