
-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `admin_audit_logs`
--

CREATE TABLE `admin_audit_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `admin_id` bigint(20) UNSIGNED NOT NULL,
  `action` varchar(255) NOT NULL,
  `entity_type` varchar(100) NOT NULL,
  `entity_id` bigint(20) UNSIGNED NOT NULL,
  `old_values` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`old_values`)),
  `new_values` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`new_values`)),
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `admin_notes`
--

CREATE TABLE `admin_notes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `admin_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `note` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `admin_roles`
--

CREATE TABLE `admin_roles` (
  `admin_id` bigint(20) UNSIGNED NOT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `blocked_users`
--

CREATE TABLE `blocked_users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `blocker_id` bigint(20) UNSIGNED NOT NULL,
  `blocked_id` bigint(20) UNSIGNED NOT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `boosts`
--

CREATE TABLE `boosts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `started_at` datetime NOT NULL,
  `ends_at` datetime NOT NULL,
  `multiplier` decimal(3,1) DEFAULT 10.0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `children_plans`
--

CREATE TABLE `children_plans` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `children_plans`
--

INSERT INTO `children_plans` (`id`, `uuid`, `name`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, '200407a2-82b7-11f1-a131-c85acfa46f9f', 'Want someday', '2026-07-18 14:43:52', '2026-07-18 14:43:52', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `cities`
--

CREATE TABLE `cities` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `state_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `communication_styles`
--

CREATE TABLE `communication_styles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `communication_styles`
--

INSERT INTO `communication_styles` (`id`, `uuid`, `name`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, '200623fc-82b7-11f1-a131-c85acfa46f9f', 'Big texter', '2026-07-18 14:43:52', '2026-07-18 14:43:52', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `conversations`
--

CREATE TABLE `conversations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `match_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `conversation_participants`
--

CREATE TABLE `conversation_participants` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `conversation_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `joined_at` timestamp NULL DEFAULT NULL,
  `last_read_message_id` bigint(20) UNSIGNED DEFAULT NULL,
  `typing_status` tinyint(1) DEFAULT 0,
  `is_muted` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `countries`
--

CREATE TABLE `countries` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `iso_code` char(2) NOT NULL,
  `name` varchar(100) NOT NULL,
  `phone_code` varchar(20) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `coupons`
--

CREATE TABLE `coupons` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `code` varchar(50) NOT NULL,
  `discount_percentage` decimal(5,2) DEFAULT NULL,
  `discount_amount` decimal(10,2) DEFAULT NULL,
  `max_uses` int(11) DEFAULT 1,
  `current_uses` int(11) DEFAULT 0,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `daily_user_counters`
--

CREATE TABLE `daily_user_counters` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `counter_date` date NOT NULL,
  `likes_sent` int(11) DEFAULT 0,
  `super_likes_sent` int(11) DEFAULT 0,
  `rewinds_used` int(11) DEFAULT 0,
  `profiles_viewed` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `device_sessions`
--

CREATE TABLE `device_sessions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `device_id` varchar(255) NOT NULL,
  `device_name` varchar(255) DEFAULT NULL,
  `os_version` varchar(50) DEFAULT NULL,
  `app_version` varchar(50) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `last_active_at` timestamp NULL DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `device_tokens`
--

CREATE TABLE `device_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `device_type` enum('IOS','ANDROID','WEB') NOT NULL,
  `push_token` varchar(255) NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `diets`
--

CREATE TABLE `diets` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `name` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `diets`
--

INSERT INTO `diets` (`id`, `uuid`, `name`, `created_at`, `updated_at`, `deleted_at`) VALUES
(2, '2001ff3e-82b7-11f1-a131-c85acfa46f9f', 'Vegetarian', '2026-07-18 14:43:52', '2026-07-18 14:43:52', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `drinking_habits`
--

CREATE TABLE `drinking_habits` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `name` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `drinking_habits`
--

INSERT INTO `drinking_habits` (`id`, `uuid`, `name`, `created_at`, `updated_at`, `deleted_at`) VALUES
(2, '1ffbcb0b-82b7-11f1-a131-c85acfa46f9f', 'Regularly', '2026-07-18 14:43:52', '2026-07-18 14:43:52', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `education_levels`
--

CREATE TABLE `education_levels` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `education_levels`
--

INSERT INTO `education_levels` (`id`, `uuid`, `name`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, '1ff77f78-82b7-11f1-a131-c85acfa46f9f', 'High School', '2026-07-18 14:43:52', '2026-07-18 14:43:52', NULL),
(2, '1ff7b417-82b7-11f1-a131-c85acfa46f9f', 'Bachelors', '2026-07-18 14:43:52', '2026-07-18 14:43:52', NULL),
(3, '1ff7ba08-82b7-11f1-a131-c85acfa46f9f', 'Masters', '2026-07-18 14:43:52', '2026-07-18 14:43:52', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `email_verifications`
--

CREATE TABLE `email_verifications` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL,
  `email` varchar(255) NOT NULL,
  `otp_hash` varchar(255) NOT NULL,
  `verify_attempts` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `resend_attempts` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `expires_at` timestamp NULL DEFAULT NULL,
  `is_verified` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `email_verifications`
--

INSERT INTO `email_verifications` (`id`, `uuid`, `email`, `otp_hash`, `verify_attempts`, `resend_attempts`, `expires_at`, `is_verified`, `created_at`, `updated_at`) VALUES
(2, '37985b9a-12bf-4c77-8db9-4be0e9736c08', 'sribashsarkarblp@gmail.com', '68f28697277636f4ee9d3fb9c853aa9e0b817e175393ca359a2e352dd6bb730e', 0, 0, '2026-07-18 14:37:07', 1, '2026-07-18 14:35:54', '2026-07-18 14:37:07'),
(3, '01d8bdaf-e3dd-4179-9fbd-7714db602b6b', 'roy338004@gmail.com', 'a6bdb03c18e279318ef2e83107bd31910a360cb9358e6fe3cf9a954d698eaf04', 0, 0, '2026-07-18 15:22:49', 1, '2026-07-18 15:21:13', '2026-07-18 15:22:49'),
(5, '5cdb058c-46e2-405a-87dc-07dff414ff54', 'sribashsarkar3467@gmail.com', '1a51e54f3a1ec038b8ac39f6391651dbdc9bd52cb5db63a71d6b474a69eb26dc', 0, 0, '2026-07-18 15:49:31', 1, '2026-07-18 15:48:41', '2026-07-18 15:49:31'),
(8, '2e38ea68-745e-4d15-8613-be6dfa5f93e6', 'sribashsarkar826@gmail.com', 'ec6d098058ec3873f9bb9917ccfd43e3ba3ce2ffc7d27c872b5fdf9e19e8ce18', 0, 2, '2026-07-18 17:05:41', 1, '2026-07-18 17:02:19', '2026-07-18 17:05:41');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `fitness_habits`
--

CREATE TABLE `fitness_habits` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `name` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `fitness_habits`
--

INSERT INTO `fitness_habits` (`id`, `uuid`, `name`, `created_at`, `updated_at`, `deleted_at`) VALUES
(3, '1ffdf127-82b7-11f1-a131-c85acfa46f9f', 'Active', '2026-07-18 14:43:52', '2026-07-18 14:43:52', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `genders`
--

CREATE TABLE `genders` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `name` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `genders`
--

INSERT INTO `genders` (`id`, `uuid`, `name`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, '1fea345d-82b7-11f1-a131-c85acfa46f9f', 'Male', '2026-07-18 14:43:52', '2026-07-18 14:43:52', NULL),
(2, '1fea50b5-82b7-11f1-a131-c85acfa46f9f', 'Female', '2026-07-18 14:43:52', '2026-07-18 14:43:52', NULL),
(3, '1fea5195-82b7-11f1-a131-c85acfa46f9f', 'Other', '2026-07-18 14:43:52', '2026-07-18 14:43:52', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `hobbies`
--

CREATE TABLE `hobbies` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `interests`
--

CREATE TABLE `interests` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `category_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `interest_categories`
--

CREATE TABLE `interest_categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `invoices`
--

CREATE TABLE `invoices` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `payment_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `invoice_number` varchar(100) NOT NULL,
  `billing_address` text DEFAULT NULL,
  `pdf_url` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `languages`
--

CREATE TABLE `languages` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `code` char(2) NOT NULL,
  `name` varchar(100) NOT NULL,
  `native_name` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `location_history`
--

CREATE TABLE `location_history` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `latitude` decimal(10,8) NOT NULL,
  `longitude` decimal(11,8) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `login_history`
--

CREATE TABLE `login_history` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `status` enum('SUCCESS','FAILED') NOT NULL,
  `failure_reason` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `love_languages`
--

CREATE TABLE `love_languages` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `matches`
--

CREATE TABLE `matches` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `user1_id` bigint(20) UNSIGNED NOT NULL,
  `user2_id` bigint(20) UNSIGNED NOT NULL,
  `compatibility_score` decimal(5,2) DEFAULT NULL,
  `is_unmatched` tinyint(1) DEFAULT 0,
  `unmatched_by_id` bigint(20) UNSIGNED DEFAULT NULL,
  `unmatched_reason` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL
) ;

--
-- Triggers `matches`
--


-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `conversation_id` bigint(20) UNSIGNED NOT NULL,
  `sender_id` bigint(20) UNSIGNED NOT NULL,
  `content` text DEFAULT NULL,
  `message_type` enum('TEXT','IMAGE','VIDEO','VOICE','SYSTEM','GIF') DEFAULT 'TEXT',
  `reply_to_id` bigint(20) UNSIGNED DEFAULT NULL,
  `status` enum('SENT','DELIVERED','READ','DELETED') DEFAULT 'SENT',
  `is_pinned` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `message_attachments`
--

CREATE TABLE `message_attachments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `message_id` bigint(20) UNSIGNED NOT NULL,
  `file_url` varchar(500) NOT NULL,
  `file_type` varchar(50) NOT NULL,
  `file_size_bytes` bigint(20) NOT NULL,
  `duration_seconds` int(11) DEFAULT NULL COMMENT 'For voice/video',
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `message_reactions`
--

CREATE TABLE `message_reactions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `message_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `reaction_emoji` varchar(10) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2019_08_19_000000_create_failed_jobs_table', 1),
(2, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(3, '2026_07_18_103625_create_email_verifications_table', 1),
(4, '2026_07_18_104000_create_registration_tokens_table', 1);

-- --------------------------------------------------------

--
-- Table structure for table `moderation_queues`
--

CREATE TABLE `moderation_queues` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `entity_type` enum('USER_PROFILE','PHOTO','MESSAGE') NOT NULL,
  `entity_id` bigint(20) UNSIGNED NOT NULL,
  `priority` int(11) DEFAULT 0,
  `status` enum('PENDING','REVIEWED') DEFAULT 'PENDING',
  `flag_reason` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `movie_genres`
--

CREATE TABLE `movie_genres` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `music_genres`
--

CREATE TABLE `music_genres` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `type` varchar(50) NOT NULL COMMENT 'e.g. NEW_MATCH, NEW_MESSAGE',
  `title` varchar(255) NOT NULL,
  `body` text NOT NULL,
  `reference_id` bigint(20) UNSIGNED DEFAULT NULL COMMENT 'ID of related entity',
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `occupations`
--

CREATE TABLE `occupations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `opening_moves`
--

CREATE TABLE `opening_moves` (
  `id` int(11) NOT NULL,
  `name` varchar(500) NOT NULL,
  `display_order` int(11) DEFAULT 0,
  `status` enum('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `opening_moves`
--

INSERT INTO `opening_moves` (`id`, `name`, `display_order`, `status`, `created_at`, `updated_at`) VALUES
(1, 'What\'s a controversial opinion you have?', 1, 'ACTIVE', '2026-07-18 16:05:14', '2026-07-18 16:05:14'),
(2, 'Two truths and a lie...', 2, 'ACTIVE', '2026-07-18 16:05:14', '2026-07-18 16:05:14'),
(3, 'Best travel story?', 3, 'ACTIVE', '2026-07-18 16:05:14', '2026-07-18 16:05:14'),
(4, 'What are you binge watching right now?', 4, 'ACTIVE', '2026-07-18 16:05:14', '2026-07-18 16:05:14');

-- --------------------------------------------------------

--
-- Table structure for table `otps`
--

CREATE TABLE `otps` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `type` enum('EMAIL_VERIFICATION','PHONE_VERIFICATION','PASSWORD_RESET','LOGIN') NOT NULL,
  `identifier` varchar(255) NOT NULL COMMENT 'Email or Phone',
  `code_hash` varchar(255) NOT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `is_used` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `otps`
--

INSERT INTO `otps` (`id`, `uuid`, `user_id`, `type`, `identifier`, `code_hash`, `expires_at`, `is_used`, `created_at`, `updated_at`) VALUES
(1, 'ae41f7d5-82bc-11f1-a131-c85acfa46f9f', 4, 'LOGIN', 'sribashsarkarblp@gmail.com', '57713e6b1f46d4547f7561f5cc245b816f42f86c512e4d54fd4a00b07df4d776', '2026-07-18 15:23:52', 1, '2026-07-18 15:23:38', '2026-07-18 15:23:52'),
(2, 'b6deead5-82bc-11f1-a131-c85acfa46f9f', 4, 'LOGIN', 'sribashsarkarblp@gmail.com', '598986b18db9e99660fef1600b5d88804b80e955361eca5385723a83b9eb4d3a', '2026-07-18 15:40:14', 1, '2026-07-18 15:23:52', '2026-07-18 15:40:14'),
(3, 'c815fbd8-82bc-11f1-a131-c85acfa46f9f', 5, 'LOGIN', 'roy338004@gmail.com', '2ad562e66423f2618eb02316d328342f87f6bf4f26b10d59c6b854c49ddc305c', '2026-07-18 15:25:35', 1, '2026-07-18 15:24:21', '2026-07-18 15:25:35'),
(4, 'f3e5176a-82bc-11f1-a131-c85acfa46f9f', 5, 'LOGIN', 'roy338004@gmail.com', 'ab539719ceff7943fc761054bce2fe205f16913f638d7c760b1fdd885e7aa10b', '2026-07-18 15:27:48', 1, '2026-07-18 15:25:35', '2026-07-18 15:27:48'),
(5, '43664953-82bd-11f1-a131-c85acfa46f9f', 5, 'LOGIN', 'roy338004@gmail.com', '13b3f2fabeceb780eca50d103f7a845f6a02d312c7d6827f4c381514054a9f7b', '2026-07-18 15:31:50', 1, '2026-07-18 15:27:48', '2026-07-18 15:31:50'),
(6, 'd37e346a-82bd-11f1-a131-c85acfa46f9f', 5, 'LOGIN', 'roy338004@gmail.com', '7d3f8a0c1c1f579ead9c2bbcd9f5ab167842559dbe241987dd0131a29cad06dd', '2026-07-18 15:32:20', 1, '2026-07-18 15:31:50', '2026-07-18 15:32:20'),
(7, '0001d008-82bf-11f1-a131-c85acfa46f9f', 4, 'LOGIN', 'sribashsarkarblp@gmail.com', '15a24c91a5b566e7e302650092a374bed5249bc0d22066b1625a1212f4213231', '2026-07-18 15:41:05', 1, '2026-07-18 15:40:14', '2026-07-18 15:41:05'),
(8, '41aa118e-82cb-11f1-a131-c85acfa46f9f', 6, 'LOGIN', 'sribashsarkar826@gmail.com', '25cdd823ac3ec3efc03f07ad3dcec4dd0914bcd80976b60f5c2964c96ece8408', '2026-07-18 17:09:03', 1, '2026-07-18 17:07:58', '2026-07-18 17:09:03');

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `currency` char(3) NOT NULL DEFAULT 'USD',
  `status` enum('PENDING','COMPLETED','FAILED','REFUNDED') NOT NULL,
  `payment_method` varchar(50) NOT NULL COMMENT 'ApplePay, GooglePay, CC',
  `transaction_id` varchar(255) NOT NULL,
  `receipt_data` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pets`
--

CREATE TABLE `pets` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `name` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `political_views`
--

CREATE TABLE `political_views` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `political_views`
--

INSERT INTO `political_views` (`id`, `uuid`, `name`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, '200a99e4-82b7-11f1-a131-c85acfa46f9f', 'Apolitical', '2026-07-18 14:43:52', '2026-07-18 14:43:52', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `profile_prompts`
--

CREATE TABLE `profile_prompts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `prompt_text` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `profile_visitors`
--

CREATE TABLE `profile_visitors` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `visitor_id` bigint(20) UNSIGNED NOT NULL,
  `visited_id` bigint(20) UNSIGNED NOT NULL,
  `visited_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `recommendation_queues`
--

CREATE TABLE `recommendation_queues` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `recommended_user_id` bigint(20) UNSIGNED NOT NULL,
  `score` decimal(10,4) NOT NULL COMMENT 'AI generated score',
  `is_viewed` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `refresh_tokens`
--

CREATE TABLE `refresh_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `session_id` bigint(20) UNSIGNED NOT NULL,
  `token_hash` varchar(255) NOT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `is_revoked` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `registration_tokens`
--

CREATE TABLE `registration_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL,
  `email` varchar(255) NOT NULL,
  `token_hash` varchar(255) NOT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `is_used` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `registration_tokens`
--

INSERT INTO `registration_tokens` (`id`, `uuid`, `email`, `token_hash`, `expires_at`, `is_used`, `created_at`, `updated_at`) VALUES
(1, '53b1f504-7f29-496b-8fd4-119551ff213a', 'sribashsarkarblp@gmail.com', '588dc8664862cc1fd03703ed1cae4a73eee0ef615fd1da463f58e609e1b164f5', '2026-07-18 14:58:32', 1, '2026-07-18 14:37:07', '2026-07-18 14:58:32'),
(2, 'da1edb34-c5f6-4a10-8c29-fdc001d919ca', 'roy338004@gmail.com', 'a900a9902dca1314631ad005d903cbb4603e32848ffd0df2fe48712b6be8537d', '2026-07-18 15:23:28', 1, '2026-07-18 15:22:49', '2026-07-18 15:23:28'),
(3, '7e6d4b97-6cfa-4c9f-a472-73f1486d7486', 'sribashsarkar3467@gmail.com', 'edde398573b2c327884f135d60fdcaf5b2b3341407282014b38cfef7b6d9c4e9', '2026-07-19 15:49:31', 0, '2026-07-18 15:49:31', '2026-07-18 15:49:31'),
(4, '49421364-e819-44a8-9870-fe29243e24a3', 'sribashsarkar826@gmail.com', '31cb8e68f5d7d0b988171d8b90485d522fe118b512af43dd540e10567ebe7273', '2026-07-18 17:07:05', 1, '2026-07-18 17:05:41', '2026-07-18 17:07:05');

-- --------------------------------------------------------

--
-- Table structure for table `relationship_goals`
--

CREATE TABLE `relationship_goals` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `name` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `relationship_goals`
--

INSERT INTO `relationship_goals` (`id`, `uuid`, `name`, `description`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, '1ff5617a-82b7-11f1-a131-c85acfa46f9f', 'Long-term partner', NULL, '2026-07-18 14:43:52', '2026-07-18 14:43:52', NULL),
(2, '1ff5827f-82b7-11f1-a131-c85acfa46f9f', 'New friends', NULL, '2026-07-18 14:43:52', '2026-07-18 14:43:52', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `religions`
--

CREATE TABLE `religions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `religions`
--

INSERT INTO `religions` (`id`, `uuid`, `name`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, '20082870-82b7-11f1-a131-c85acfa46f9f', 'Spiritual', '2026-07-18 14:43:52', '2026-07-18 14:43:52', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `reports`
--

CREATE TABLE `reports` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `reporter_id` bigint(20) UNSIGNED NOT NULL,
  `reported_id` bigint(20) UNSIGNED NOT NULL,
  `reason_category` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `status` enum('PENDING','INVESTIGATING','RESOLVED','DISMISSED') DEFAULT 'PENDING',
  `action_taken` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `rewinds`
--

CREATE TABLE `rewinds` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `swipe_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `role_permissions`
--

CREATE TABLE `role_permissions` (
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `permission_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `security_logs`
--

CREATE TABLE `security_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `event_type` varchar(100) NOT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `details` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`details`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `show_me`
--

CREATE TABLE `show_me` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `display_order` int(11) DEFAULT 0,
  `status` enum('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `show_me`
--

INSERT INTO `show_me` (`id`, `name`, `display_order`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Women', 1, 'ACTIVE', '2026-07-18 16:05:14', '2026-07-18 16:05:14'),
(2, 'Men', 2, 'ACTIVE', '2026-07-18 16:05:14', '2026-07-18 16:05:14'),
(3, 'Everyone', 3, 'ACTIVE', '2026-07-18 16:05:14', '2026-07-18 16:05:14');

-- --------------------------------------------------------

--
-- Table structure for table `sleep_habits`
--

CREATE TABLE `sleep_habits` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `name` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sleep_habits`
--

INSERT INTO `sleep_habits` (`id`, `uuid`, `name`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, '1fffe049-82b7-11f1-a131-c85acfa46f9f', 'Early bird', '2026-07-18 14:43:52', '2026-07-18 14:43:52', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `smoking_habits`
--

CREATE TABLE `smoking_habits` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `name` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `smoking_habits`
--

INSERT INTO `smoking_habits` (`id`, `uuid`, `name`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, '1ff9c034-82b7-11f1-a131-c85acfa46f9f', 'Socially', '2026-07-18 14:43:52', '2026-07-18 14:43:52', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `sports`
--

CREATE TABLE `sports` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `states`
--

CREATE TABLE `states` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `country_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `subscription_plans`
--

CREATE TABLE `subscription_plans` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `name` varchar(100) NOT NULL,
  `tier_level` int(11) NOT NULL COMMENT '1=Plus, 2=Gold, 3=Platinum',
  `billing_cycle` enum('WEEKLY','MONTHLY','QUARTERLY','YEARLY') NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `currency` char(3) DEFAULT 'USD',
  `features` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`features`)),
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `swipes`
--

CREATE TABLE `swipes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `swiper_id` bigint(20) UNSIGNED NOT NULL,
  `swipee_id` bigint(20) UNSIGNED NOT NULL,
  `swipe_type` enum('LIKE','PASS','SUPER_LIKE') NOT NULL,
  `is_rewound` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Triggers `swipes`
--

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `display_name` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `birth_date` date NOT NULL,
  `age` int(11) GENERATED ALWAYS AS (timestampdiff(YEAR,`birth_date`,curdate())) VIRTUAL,
  `gender_identity_id` bigint(20) UNSIGNED DEFAULT NULL,
  `interested_in_id` bigint(20) UNSIGNED DEFAULT NULL,
  `relationship_goal_id` bigint(20) UNSIGNED DEFAULT NULL,
  `status` enum('ACTIVE','BANNED','SUSPENDED','DELETED','PENDING_VERIFICATION') DEFAULT 'PENDING_VERIFICATION',
  `onboarding_completed` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `uuid`, `first_name`, `last_name`, `display_name`, `email`, `phone`, `birth_date`, `gender_identity_id`, `interested_in_id`, `relationship_goal_id`, `status`, `onboarding_completed`, `created_at`, `updated_at`, `deleted_at`) VALUES
(4, '7f5447f2-ceb5-4098-a564-cf96b49efa22', 'John', 'Doe', 'John D.', 'sribashsarkarblp@gmail.com', NULL, '1995-05-15', 1, 2, 1, 'ACTIVE', 1, '2026-07-18 14:58:31', '2026-07-18 14:58:31', NULL),
(5, '61aa0b92-e081-4d53-94e3-beb3be66fa50', 'John', 'Doe', 'John D.', 'roy338004@gmail.com', NULL, '1995-05-15', 1, 2, 1, 'ACTIVE', 1, '2026-07-18 15:23:28', '2026-07-18 15:23:28', NULL),
(6, 'dac64f26-f85a-4841-bd4f-e39efe3c271d', 'John', 'Doe', 'John D.', 'sribashsarkar826@gmail.com', NULL, '1995-08-15', 1, NULL, NULL, 'ACTIVE', 1, '2026-07-18 17:07:05', '2026-07-18 17:07:05', NULL);

--
-- Triggers `users`
--


-- --------------------------------------------------------

--
-- Table structure for table `user_activities`
--

CREATE TABLE `user_activities` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `last_online_at` timestamp NULL DEFAULT NULL,
  `total_profile_views` bigint(20) DEFAULT 0,
  `total_likes_received` bigint(20) DEFAULT 0,
  `total_likes_sent` bigint(20) DEFAULT 0,
  `total_matches` bigint(20) DEFAULT 0,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_activities`
--

INSERT INTO `user_activities` (`id`, `user_id`, `last_online_at`, `total_profile_views`, `total_likes_received`, `total_likes_sent`, `total_matches`, `updated_at`) VALUES
(3, 4, NULL, 0, 0, 0, 0, '2026-07-18 14:58:31'),
(4, 5, NULL, 0, 0, 0, 0, '2026-07-18 15:23:28'),
(5, 6, NULL, 0, 0, 0, 0, '2026-07-18 17:07:05');

-- --------------------------------------------------------

--
-- Table structure for table `user_authentications`
--

CREATE TABLE `user_authentications` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `auth_provider` enum('PASSWORD','GOOGLE','APPLE','FACEBOOK','PHONE') NOT NULL,
  `provider_id` varchar(255) DEFAULT NULL COMMENT 'External ID for OAuth',
  `password_hash` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_hobbies`
--

CREATE TABLE `user_hobbies` (
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `hobby_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_interests`
--

CREATE TABLE `user_interests` (
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `interest_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_languages`
--

CREATE TABLE `user_languages` (
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `language_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_locations`
--

CREATE TABLE `user_locations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `latitude` decimal(10,8) NOT NULL,
  `longitude` decimal(11,8) NOT NULL,
  `geohash` varchar(12) NOT NULL,
  `city_name` varchar(100) DEFAULT NULL,
  `is_travel_mode` tinyint(1) DEFAULT 0,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_match_preferences`
--

CREATE TABLE `user_match_preferences` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `preferred_age_min` int(11) NOT NULL DEFAULT 18,
  `preferred_age_max` int(11) NOT NULL DEFAULT 99,
  `distance_radius_km` int(11) NOT NULL DEFAULT 50,
  `interested_gender_id` bigint(20) UNSIGNED DEFAULT NULL,
  `height_min_cm` int(11) DEFAULT NULL,
  `height_max_cm` int(11) DEFAULT NULL,
  `education_id` bigint(20) UNSIGNED DEFAULT NULL,
  `religion_id` bigint(20) UNSIGNED DEFAULT NULL,
  `smoking_id` bigint(20) UNSIGNED DEFAULT NULL,
  `drinking_id` bigint(20) UNSIGNED DEFAULT NULL,
  `relationship_goal_id` bigint(20) UNSIGNED DEFAULT NULL,
  `online_only` tinyint(1) DEFAULT 0,
  `verified_users_only` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL
) ;

--
-- Dumping data for table `user_match_preferences`
--

INSERT INTO `user_match_preferences` (`id`, `uuid`, `user_id`, `preferred_age_min`, `preferred_age_max`, `distance_radius_km`, `interested_gender_id`, `height_min_cm`, `height_max_cm`, `education_id`, `religion_id`, `smoking_id`, `drinking_id`, `relationship_goal_id`, `online_only`, `verified_users_only`, `created_at`, `updated_at`) VALUES
(3, '2c6ad98b-82b9-11f1-a131-c85acfa46f9f', 4, 18, 99, 50, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-07-18 14:58:31', '2026-07-18 14:58:31'),
(4, 'a885f621-82bc-11f1-a131-c85acfa46f9f', 5, 18, 99, 50, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-07-18 15:23:28', '2026-07-18 15:23:28'),
(5, '2208a05e-82cb-11f1-a131-c85acfa46f9f', 6, 18, 99, 50, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '2026-07-18 17:07:05', '2026-07-18 17:07:05');

-- --------------------------------------------------------

--
-- Table structure for table `user_movie_genres`
--

CREATE TABLE `user_movie_genres` (
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `movie_genre_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_music_genres`
--

CREATE TABLE `user_music_genres` (
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `music_genre_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_notification_preferences`
--

CREATE TABLE `user_notification_preferences` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `new_matches_push` tinyint(1) DEFAULT 1,
  `new_messages_push` tinyint(1) DEFAULT 1,
  `super_likes_push` tinyint(1) DEFAULT 1,
  `marketing_emails` tinyint(1) DEFAULT 0,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_notification_preferences`
--

INSERT INTO `user_notification_preferences` (`id`, `user_id`, `new_matches_push`, `new_messages_push`, `super_likes_push`, `marketing_emails`, `updated_at`) VALUES
(3, 4, 1, 1, 1, 0, '2026-07-18 14:58:31'),
(4, 5, 1, 1, 1, 0, '2026-07-18 15:23:28'),
(5, 6, 1, 1, 1, 0, '2026-07-18 17:07:05');

-- --------------------------------------------------------

--
-- Table structure for table `user_photos`
--

CREATE TABLE `user_photos` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `photo_url` varchar(500) NOT NULL,
  `thumbnail_url` varchar(500) DEFAULT NULL,
  `blurhash` varchar(100) DEFAULT NULL,
  `display_order` int(11) NOT NULL DEFAULT 0,
  `is_main` tinyint(1) DEFAULT 0,
  `is_verified_photo` tinyint(1) DEFAULT 0,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Store width, height, face_coordinates' CHECK (json_valid(`metadata`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_photos`
--

INSERT INTO `user_photos` (`id`, `uuid`, `user_id`, `photo_url`, `thumbnail_url`, `blurhash`, `display_order`, `is_main`, `is_verified_photo`, `metadata`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, '3bdef2c7-6650-48ef-beef-1cedfa698b23', 4, 'api/uploads/users/4/temp_6a5b9493b0a97_1784386707.png', NULL, NULL, 0, 1, 0, NULL, '2026-07-18 14:58:32', '2026-07-18 14:58:32', NULL),
(2, '90db6506-5d23-4d70-8798-fec8a6bdd1bf', 5, 'api/uploads/users/5/temp_6a5b9a66967e7_1784388198.png', NULL, NULL, 0, 1, 0, NULL, '2026-07-18 15:23:28', '2026-07-18 15:23:28', NULL),
(3, '7ae7234b-9dbf-4956-9f71-a290356681e8', 6, 'api/uploads/users/6/temp_6a5bb2a69d39f_1784394406_0.jpg', NULL, NULL, 0, 1, 0, NULL, '2026-07-18 17:07:05', '2026-07-18 17:07:05', NULL),
(4, '7e40f136-7667-4d19-b305-cff9475a1d62', 6, 'api/uploads/users/6/temp_6a5bb2a69e49f_1784394406_1.png', NULL, NULL, 1, 0, 0, NULL, '2026-07-18 17:07:05', '2026-07-18 17:07:05', NULL),
(5, '58871712-d92e-41d9-8fd0-760660776123', 6, 'api/uploads/users/6/temp_6a5bb2a69e74f_1784394406_2.png', NULL, NULL, 2, 0, 0, NULL, '2026-07-18 17:07:05', '2026-07-18 17:07:05', NULL),
(6, '19b54ede-f14a-4a0c-bfe3-1a1fe3d76ccb', 6, 'api/uploads/users/6/temp_6a5bb2a69e941_1784394406_3.png', NULL, NULL, 3, 0, 0, NULL, '2026-07-18 17:07:05', '2026-07-18 17:07:05', NULL),
(7, 'f4a16e76-3a71-44cd-b93d-cbb09c9a5438', 6, 'api/uploads/users/6/temp_6a5bb2a69ec79_1784394406_4.png', NULL, NULL, 4, 0, 0, NULL, '2026-07-18 17:07:05', '2026-07-18 17:07:05', NULL),
(8, '3116e487-9f33-43d0-b974-88d03a662618', 6, 'api/uploads/users/6/temp_6a5bb2a69ee8e_1784394406_5.png', NULL, NULL, 5, 0, 0, NULL, '2026-07-18 17:07:05', '2026-07-18 17:07:05', NULL),
(9, '25aeb236-bbf9-4d07-ae23-a32be422226f', 6, 'api/uploads/users/6/temp_6a5bb2a69f087_1784394406_6.png', NULL, NULL, 6, 0, 0, NULL, '2026-07-18 17:07:05', '2026-07-18 17:07:05', NULL),
(10, 'e4b8e250-5b2e-4b8e-9fbf-3d8415fefa3d', 6, 'api/uploads/users/6/temp_6a5bb2a69f2ab_1784394406_7.png', NULL, NULL, 7, 0, 0, NULL, '2026-07-18 17:07:05', '2026-07-18 17:07:05', NULL),
(11, '45f68d0c-2653-4860-b455-b8016c93d3b2', 6, 'api/uploads/users/6/temp_6a5bb2a69f5f0_1784394406_8.png', NULL, NULL, 8, 0, 0, NULL, '2026-07-18 17:07:05', '2026-07-18 17:07:05', NULL),
(12, '46c85bf3-5312-4dc1-b65d-f348112d9f65', 6, 'api/uploads/users/6/temp_6a5bb2a69f819_1784394406_9.png', NULL, NULL, 9, 0, 0, NULL, '2026-07-18 17:07:05', '2026-07-18 17:07:05', NULL),
(13, '89a46c80-a3a7-4240-aae2-6f596d1f7c87', 6, 'api/uploads/users/6/temp_6a5bb2a69f9fc_1784394406_10.png', NULL, NULL, 10, 0, 0, NULL, '2026-07-18 17:07:05', '2026-07-18 17:07:05', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_preference_children`
--

CREATE TABLE `user_preference_children` (
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `children_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_preference_languages`
--

CREATE TABLE `user_preference_languages` (
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `language_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_preference_pets`
--

CREATE TABLE `user_preference_pets` (
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `pets_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_preference_politics`
--

CREATE TABLE `user_preference_politics` (
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `political_view_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_profiles`
--

CREATE TABLE `user_profiles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `bio` text DEFAULT NULL,
  `height_cm` int(11) DEFAULT NULL,
  `weight_kg` decimal(5,2) DEFAULT NULL,
  `hometown` varchar(255) DEFAULT NULL,
  `current_city_id` bigint(20) UNSIGNED DEFAULT NULL,
  `country_id` bigint(20) UNSIGNED DEFAULT NULL,
  `base_latitude` decimal(10,8) DEFAULT NULL,
  `base_longitude` decimal(11,8) DEFAULT NULL,
  `education_id` bigint(20) UNSIGNED DEFAULT NULL,
  `occupation_id` bigint(20) UNSIGNED DEFAULT NULL,
  `company` varchar(255) DEFAULT NULL,
  `religion_id` bigint(20) UNSIGNED DEFAULT NULL,
  `political_view_id` bigint(20) UNSIGNED DEFAULT NULL,
  `smoking_id` bigint(20) UNSIGNED DEFAULT NULL,
  `drinking_id` bigint(20) UNSIGNED DEFAULT NULL,
  `fitness_id` bigint(20) UNSIGNED DEFAULT NULL,
  `sleep_id` bigint(20) UNSIGNED DEFAULT NULL,
  `diet_id` bigint(20) UNSIGNED DEFAULT NULL,
  `pets_id` bigint(20) UNSIGNED DEFAULT NULL,
  `children_id` bigint(20) UNSIGNED DEFAULT NULL,
  `love_language_id` bigint(20) UNSIGNED DEFAULT NULL,
  `communication_style_id` bigint(20) UNSIGNED DEFAULT NULL,
  `personality_type` varchar(10) DEFAULT NULL COMMENT 'e.g. INTJ, ENFP',
  `zodiac` varchar(50) DEFAULT NULL,
  `spotify_anthem_url` varchar(255) DEFAULT NULL,
  `instagram_username` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `compatibility_score_base` int(11) DEFAULT 50 COMMENT 'Base index for ML model scoring',
  `is_verified` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_profiles`
--

INSERT INTO `user_profiles` (`id`, `uuid`, `user_id`, `bio`, `height_cm`, `weight_kg`, `hometown`, `current_city_id`, `country_id`, `base_latitude`, `base_longitude`, `education_id`, `occupation_id`, `company`, `religion_id`, `political_view_id`, `smoking_id`, `drinking_id`, `fitness_id`, `sleep_id`, `diet_id`, `pets_id`, `children_id`, `love_language_id`, `communication_style_id`, `personality_type`, `zodiac`, `spotify_anthem_url`, `instagram_username`, `website`, `compatibility_score_base`, `is_verified`, `created_at`, `updated_at`) VALUES
(5, '2c695a7a-82b9-11f1-a131-c85acfa46f9f', 4, 'Hello, I am a software engineer.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, NULL, NULL, 1, 1, 1, 2, 3, 1, 2, NULL, 1, NULL, 1, NULL, NULL, NULL, NULL, NULL, 50, 0, '2026-07-18 14:58:31', '2026-07-18 14:58:31'),
(6, 'a8851178-82bc-11f1-a131-c85acfa46f9f', 5, 'Hello, I am a software engineer.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, NULL, NULL, 1, 1, 1, 2, 3, 1, 2, NULL, 1, NULL, 1, NULL, NULL, NULL, NULL, NULL, 50, 0, '2026-07-18 15:23:28', '2026-07-18 15:23:28'),
(7, '2207d5a9-82cb-11f1-a131-c85acfa46f9f', 6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 50, 0, '2026-07-18 17:07:05', '2026-07-18 17:07:05');

-- --------------------------------------------------------

--
-- Table structure for table `user_profile_prompts`
--

CREATE TABLE `user_profile_prompts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `prompt_id` bigint(20) UNSIGNED NOT NULL,
  `answer_text` text NOT NULL,
  `display_order` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_sports`
--

CREATE TABLE `user_sports` (
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `sport_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_subscriptions`
--

CREATE TABLE `user_subscriptions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `plan_id` bigint(20) UNSIGNED NOT NULL,
  `status` enum('ACTIVE','CANCELED','EXPIRED','PAST_DUE') NOT NULL,
  `platform` enum('APPLE','GOOGLE','STRIPE') NOT NULL,
  `platform_subscription_id` varchar(255) NOT NULL,
  `starts_at` datetime NOT NULL,
  `ends_at` datetime NOT NULL,
  `auto_renew` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_videos`
--

CREATE TABLE `user_videos` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `video_url` varchar(500) NOT NULL,
  `thumbnail_url` varchar(500) DEFAULT NULL,
  `duration_seconds` int(11) DEFAULT NULL,
  `display_order` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_visibility_settings`
--

CREATE TABLE `user_visibility_settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `hide_age` tinyint(1) DEFAULT 0,
  `hide_distance` tinyint(1) DEFAULT 0,
  `hide_online_status` tinyint(1) DEFAULT 0,
  `hide_last_seen` tinyint(1) DEFAULT 0,
  `incognito_mode` tinyint(1) DEFAULT 0,
  `show_only_to_liked` tinyint(1) DEFAULT 0,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_visibility_settings`
--

INSERT INTO `user_visibility_settings` (`id`, `user_id`, `hide_age`, `hide_distance`, `hide_online_status`, `hide_last_seen`, `incognito_mode`, `show_only_to_liked`, `updated_at`) VALUES
(3, 4, 0, 0, 0, 0, 0, 0, '2026-07-18 14:58:31'),
(4, 5, 0, 0, 0, 0, 0, 0, '2026-07-18 15:23:28'),
(5, 6, 0, 0, 0, 0, 0, 0, '2026-07-18 17:07:05');

-- --------------------------------------------------------

--
-- Table structure for table `verification_requests`
--

CREATE TABLE `verification_requests` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `selfie_photo_url` varchar(255) NOT NULL,
  `status` enum('PENDING','APPROVED','REJECTED') DEFAULT 'PENDING',
  `reviewed_by` bigint(20) UNSIGNED DEFAULT NULL,
  `rejection_reason` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_swipe_cards`
-- (See below for the actual view)
--
CREATE TABLE `vw_swipe_cards` (
`user_id` bigint(20) unsigned
,`uuid` char(36)
,`first_name` varchar(100)
,`display_name` varchar(100)
,`age` int(11)
,`is_verified` tinyint(1)
,`bio` text
,`height_cm` int(11)
,`company` varchar(255)
,`base_latitude` decimal(10,8)
,`base_longitude` decimal(11,8)
,`compatibility_score_base` int(11)
,`spotify_anthem_url` varchar(255)
,`instagram_username` varchar(255)
,`relationship_goal` varchar(100)
,`education_level` varchar(100)
,`occupation` varchar(100)
,`religion` varchar(100)
,`political_view` varchar(100)
,`main_photo_url` varchar(500)
,`photo_count` bigint(21)
,`last_online_at` timestamp
,`is_online` int(1)
);

-- --------------------------------------------------------

--
-- Table structure for table `wallets`
--

CREATE TABLE `wallets` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `coins_balance` int(11) DEFAULT 0,
  `super_likes_balance` int(11) DEFAULT 0,
  `boosts_balance` int(11) DEFAULT 0,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `wallets`
--

INSERT INTO `wallets` (`id`, `user_id`, `coins_balance`, `super_likes_balance`, `boosts_balance`, `updated_at`) VALUES
(3, 4, 0, 0, 0, '2026-07-18 14:58:31'),
(4, 5, 0, 0, 0, '2026-07-18 15:23:28'),
(5, 6, 0, 0, 0, '2026-07-18 17:07:05');

-- --------------------------------------------------------

--
-- Table structure for table `wallet_transactions`
--

CREATE TABLE `wallet_transactions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) NOT NULL ,
  `wallet_id` bigint(20) UNSIGNED NOT NULL,
  `transaction_type` enum('EARN','PURCHASE','SPEND','REFUND') NOT NULL,
  `item_type` enum('COINS','SUPER_LIKES','BOOSTS','SUBSCRIPTION') NOT NULL,
  `amount` int(11) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `zodiac_signs`
--

CREATE TABLE `zodiac_signs` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `display_order` int(11) DEFAULT 0,
  `status` enum('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `zodiac_signs`
--

INSERT INTO `zodiac_signs` (`id`, `name`, `display_order`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Aries', 1, 'ACTIVE', '2026-07-18 16:05:14', '2026-07-18 16:05:14'),
(2, 'Taurus', 2, 'ACTIVE', '2026-07-18 16:05:14', '2026-07-18 16:05:14'),
(3, 'Gemini', 3, 'ACTIVE', '2026-07-18 16:05:14', '2026-07-18 16:05:14'),
(4, 'Cancer', 4, 'ACTIVE', '2026-07-18 16:05:14', '2026-07-18 16:05:14'),
(5, 'Leo', 5, 'ACTIVE', '2026-07-18 16:05:14', '2026-07-18 16:05:14'),
(6, 'Virgo', 6, 'ACTIVE', '2026-07-18 16:05:14', '2026-07-18 16:05:14'),
(7, 'Libra', 7, 'ACTIVE', '2026-07-18 16:05:14', '2026-07-18 16:05:14'),
(8, 'Scorpio', 8, 'ACTIVE', '2026-07-18 16:05:14', '2026-07-18 16:05:14'),
(9, 'Sagittarius', 9, 'ACTIVE', '2026-07-18 16:05:14', '2026-07-18 16:05:14'),
(10, 'Capricorn', 10, 'ACTIVE', '2026-07-18 16:05:14', '2026-07-18 16:05:14'),
(11, 'Aquarius', 11, 'ACTIVE', '2026-07-18 16:05:14', '2026-07-18 16:05:14'),
(12, 'Pisces', 12, 'ACTIVE', '2026-07-18 16:05:14', '2026-07-18 16:05:14');

-- --------------------------------------------------------

--
-- Structure for view `vw_swipe_cards`
--
DROP TABLE IF EXISTS `vw_swipe_cards`;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `admin_audit_logs`
--
ALTER TABLE `admin_audit_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `idx_audit_entity` (`entity_type`,`entity_id`);

--
-- Indexes for table `admin_notes`
--
ALTER TABLE `admin_notes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `admin_roles`
--
ALTER TABLE `admin_roles`
  ADD PRIMARY KEY (`admin_id`,`role_id`),
  ADD KEY `role_id` (`role_id`);

--
-- Indexes for table `blocked_users`
--
ALTER TABLE `blocked_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `uk_block` (`blocker_id`,`blocked_id`),
  ADD KEY `blocked_id` (`blocked_id`);

--
-- Indexes for table `boosts`
--
ALTER TABLE `boosts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD KEY `idx_active_boosts` (`user_id`,`ends_at`);

--
-- Indexes for table `children_plans`
--
ALTER TABLE `children_plans`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `cities`
--
ALTER TABLE `cities`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD KEY `idx_cities_state` (`state_id`),
  ADD KEY `idx_cities_coords` (`latitude`,`longitude`);

--
-- Indexes for table `communication_styles`
--
ALTER TABLE `communication_styles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `conversations`
--
ALTER TABLE `conversations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD KEY `match_id` (`match_id`);

--
-- Indexes for table `conversation_participants`
--
ALTER TABLE `conversation_participants`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_conv_participant` (`conversation_id`,`user_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `countries`
--
ALTER TABLE `countries`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `iso_code` (`iso_code`),
  ADD KEY `idx_countries_iso_code` (`iso_code`);

--
-- Indexes for table `coupons`
--
ALTER TABLE `coupons`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Indexes for table `daily_user_counters`
--
ALTER TABLE `daily_user_counters`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_user_date` (`user_id`,`counter_date`);

--
-- Indexes for table `device_sessions`
--
ALTER TABLE `device_sessions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD KEY `idx_sessions_user_device` (`user_id`,`device_id`);

--
-- Indexes for table `device_tokens`
--
ALTER TABLE `device_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `push_token` (`push_token`),
  ADD KEY `idx_tokens_user` (`user_id`,`is_active`);

--
-- Indexes for table `diets`
--
ALTER TABLE `diets`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `drinking_habits`
--
ALTER TABLE `drinking_habits`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `education_levels`
--
ALTER TABLE `education_levels`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `email_verifications`
--
ALTER TABLE `email_verifications`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email_verifications_uuid_unique` (`uuid`),
  ADD KEY `email_verifications_email_is_verified_expires_at_index` (`email`,`is_verified`,`expires_at`),
  ADD KEY `email_verifications_email_index` (`email`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `fitness_habits`
--
ALTER TABLE `fitness_habits`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `genders`
--
ALTER TABLE `genders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `hobbies`
--
ALTER TABLE `hobbies`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `interests`
--
ALTER TABLE `interests`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `interest_categories`
--
ALTER TABLE `interest_categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `invoices`
--
ALTER TABLE `invoices`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `invoice_number` (`invoice_number`),
  ADD KEY `payment_id` (`payment_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `languages`
--
ALTER TABLE `languages`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `code` (`code`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `location_history`
--
ALTER TABLE `location_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_history_user` (`user_id`,`created_at`);

--
-- Indexes for table `login_history`
--
ALTER TABLE `login_history`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD KEY `idx_login_user` (`user_id`,`created_at`);

--
-- Indexes for table `love_languages`
--
ALTER TABLE `love_languages`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `matches`
--
ALTER TABLE `matches`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `uk_match` (`user1_id`,`user2_id`),
  ADD KEY `user2_id` (`user2_id`),
  ADD KEY `unmatched_by_id` (`unmatched_by_id`),
  ADD KEY `idx_matches_status` (`is_unmatched`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD KEY `sender_id` (`sender_id`),
  ADD KEY `reply_to_id` (`reply_to_id`),
  ADD KEY `idx_messages_conversation` (`conversation_id`,`created_at`);

--
-- Indexes for table `message_attachments`
--
ALTER TABLE `message_attachments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD KEY `message_id` (`message_id`);

--
-- Indexes for table `message_reactions`
--
ALTER TABLE `message_reactions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_message_reaction` (`message_id`,`user_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `moderation_queues`
--
ALTER TABLE `moderation_queues`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_queue_pending` (`status`,`priority`,`created_at`);

--
-- Indexes for table `movie_genres`
--
ALTER TABLE `movie_genres`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `music_genres`
--
ALTER TABLE `music_genres`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD KEY `idx_notifications_user` (`user_id`,`is_read`,`created_at`);

--
-- Indexes for table `occupations`
--
ALTER TABLE `occupations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `opening_moves`
--
ALTER TABLE `opening_moves`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `otps`
--
ALTER TABLE `otps`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `idx_otps_identifier` (`identifier`,`type`,`is_used`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `transaction_id` (`transaction_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `pets`
--
ALTER TABLE `pets`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `political_views`
--
ALTER TABLE `political_views`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `profile_prompts`
--
ALTER TABLE `profile_prompts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `prompt_text` (`prompt_text`);

--
-- Indexes for table `profile_visitors`
--
ALTER TABLE `profile_visitors`
  ADD PRIMARY KEY (`id`),
  ADD KEY `visitor_id` (`visitor_id`),
  ADD KEY `idx_visitors` (`visited_id`,`visited_at`);

--
-- Indexes for table `recommendation_queues`
--
ALTER TABLE `recommendation_queues`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_recommendation` (`user_id`,`recommended_user_id`),
  ADD KEY `recommended_user_id` (`recommended_user_id`),
  ADD KEY `idx_queue_order` (`user_id`,`is_viewed`,`score`);

--
-- Indexes for table `refresh_tokens`
--
ALTER TABLE `refresh_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `token_hash` (`token_hash`),
  ADD KEY `session_id` (`session_id`),
  ADD KEY `idx_tokens_user` (`user_id`);

--
-- Indexes for table `registration_tokens`
--
ALTER TABLE `registration_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `registration_tokens_uuid_unique` (`uuid`),
  ADD UNIQUE KEY `registration_tokens_email_unique` (`email`),
  ADD UNIQUE KEY `registration_tokens_token_hash_unique` (`token_hash`),
  ADD KEY `registration_tokens_email_token_hash_is_used_index` (`email`,`token_hash`,`is_used`);

--
-- Indexes for table `relationship_goals`
--
ALTER TABLE `relationship_goals`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `religions`
--
ALTER TABLE `religions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `reports`
--
ALTER TABLE `reports`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD KEY `reporter_id` (`reporter_id`),
  ADD KEY `reported_id` (`reported_id`),
  ADD KEY `idx_reports_status` (`status`);

--
-- Indexes for table `rewinds`
--
ALTER TABLE `rewinds`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `swipe_id` (`swipe_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD PRIMARY KEY (`role_id`,`permission_id`),
  ADD KEY `permission_id` (`permission_id`);

--
-- Indexes for table `security_logs`
--
ALTER TABLE `security_logs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `idx_security_event` (`event_type`,`created_at`);

--
-- Indexes for table `show_me`
--
ALTER TABLE `show_me`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sleep_habits`
--
ALTER TABLE `sleep_habits`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `smoking_habits`
--
ALTER TABLE `smoking_habits`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `sports`
--
ALTER TABLE `sports`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `states`
--
ALTER TABLE `states`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD KEY `idx_states_country` (`country_id`);

--
-- Indexes for table `subscription_plans`
--
ALTER TABLE `subscription_plans`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`);

--
-- Indexes for table `swipes`
--
ALTER TABLE `swipes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `uk_swipe` (`swiper_id`,`swipee_id`),
  ADD KEY `idx_swipe_type` (`swipe_type`,`created_at`),
  ADD KEY `idx_swipee_likes` (`swipee_id`,`swipe_type`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `phone` (`phone`),
  ADD KEY `gender_identity_id` (`gender_identity_id`),
  ADD KEY `interested_in_id` (`interested_in_id`),
  ADD KEY `relationship_goal_id` (`relationship_goal_id`),
  ADD KEY `idx_users_email` (`email`),
  ADD KEY `idx_users_phone` (`phone`),
  ADD KEY `idx_users_status` (`status`);

--
-- Indexes for table `user_activities`
--
ALTER TABLE `user_activities`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD KEY `idx_last_online` (`last_online_at`);

--
-- Indexes for table `user_authentications`
--
ALTER TABLE `user_authentications`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `uk_user_provider` (`user_id`,`auth_provider`),
  ADD KEY `idx_provider_id` (`auth_provider`,`provider_id`);

--
-- Indexes for table `user_hobbies`
--
ALTER TABLE `user_hobbies`
  ADD PRIMARY KEY (`user_id`,`hobby_id`),
  ADD KEY `hobby_id` (`hobby_id`);

--
-- Indexes for table `user_interests`
--
ALTER TABLE `user_interests`
  ADD PRIMARY KEY (`user_id`,`interest_id`),
  ADD KEY `interest_id` (`interest_id`);

--
-- Indexes for table `user_languages`
--
ALTER TABLE `user_languages`
  ADD PRIMARY KEY (`user_id`,`language_id`),
  ADD KEY `language_id` (`language_id`);

--
-- Indexes for table `user_locations`
--
ALTER TABLE `user_locations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD KEY `idx_geohash` (`geohash`),
  ADD KEY `idx_coordinates` (`latitude`,`longitude`);

--
-- Indexes for table `user_match_preferences`
--
ALTER TABLE `user_match_preferences`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD KEY `interested_gender_id` (`interested_gender_id`),
  ADD KEY `education_id` (`education_id`),
  ADD KEY `religion_id` (`religion_id`),
  ADD KEY `smoking_id` (`smoking_id`),
  ADD KEY `drinking_id` (`drinking_id`),
  ADD KEY `relationship_goal_id` (`relationship_goal_id`);

--
-- Indexes for table `user_movie_genres`
--
ALTER TABLE `user_movie_genres`
  ADD PRIMARY KEY (`user_id`,`movie_genre_id`),
  ADD KEY `movie_genre_id` (`movie_genre_id`);

--
-- Indexes for table `user_music_genres`
--
ALTER TABLE `user_music_genres`
  ADD PRIMARY KEY (`user_id`,`music_genre_id`),
  ADD KEY `music_genre_id` (`music_genre_id`);

--
-- Indexes for table `user_notification_preferences`
--
ALTER TABLE `user_notification_preferences`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Indexes for table `user_photos`
--
ALTER TABLE `user_photos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD KEY `idx_user_photos` (`user_id`,`display_order`);

--
-- Indexes for table `user_preference_children`
--
ALTER TABLE `user_preference_children`
  ADD PRIMARY KEY (`user_id`,`children_id`),
  ADD KEY `children_id` (`children_id`);

--
-- Indexes for table `user_preference_languages`
--
ALTER TABLE `user_preference_languages`
  ADD PRIMARY KEY (`user_id`,`language_id`),
  ADD KEY `language_id` (`language_id`);

--
-- Indexes for table `user_preference_pets`
--
ALTER TABLE `user_preference_pets`
  ADD PRIMARY KEY (`user_id`,`pets_id`),
  ADD KEY `pets_id` (`pets_id`);

--
-- Indexes for table `user_preference_politics`
--
ALTER TABLE `user_preference_politics`
  ADD PRIMARY KEY (`user_id`,`political_view_id`),
  ADD KEY `political_view_id` (`political_view_id`);

--
-- Indexes for table `user_profiles`
--
ALTER TABLE `user_profiles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD KEY `current_city_id` (`current_city_id`),
  ADD KEY `education_id` (`education_id`),
  ADD KEY `occupation_id` (`occupation_id`),
  ADD KEY `religion_id` (`religion_id`),
  ADD KEY `political_view_id` (`political_view_id`),
  ADD KEY `smoking_id` (`smoking_id`),
  ADD KEY `drinking_id` (`drinking_id`),
  ADD KEY `fitness_id` (`fitness_id`),
  ADD KEY `sleep_id` (`sleep_id`),
  ADD KEY `diet_id` (`diet_id`),
  ADD KEY `pets_id` (`pets_id`),
  ADD KEY `children_id` (`children_id`),
  ADD KEY `love_language_id` (`love_language_id`),
  ADD KEY `communication_style_id` (`communication_style_id`),
  ADD KEY `idx_profile_location` (`country_id`,`current_city_id`);

--
-- Indexes for table `user_profile_prompts`
--
ALTER TABLE `user_profile_prompts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `uk_user_prompt` (`user_id`,`prompt_id`),
  ADD KEY `prompt_id` (`prompt_id`);

--
-- Indexes for table `user_sports`
--
ALTER TABLE `user_sports`
  ADD PRIMARY KEY (`user_id`,`sport_id`),
  ADD KEY `sport_id` (`sport_id`);

--
-- Indexes for table `user_subscriptions`
--
ALTER TABLE `user_subscriptions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `platform_subscription_id` (`platform_subscription_id`),
  ADD KEY `plan_id` (`plan_id`),
  ADD KEY `idx_subs_active` (`user_id`,`status`,`ends_at`);

--
-- Indexes for table `user_videos`
--
ALTER TABLE `user_videos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `user_visibility_settings`
--
ALTER TABLE `user_visibility_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Indexes for table `verification_requests`
--
ALTER TABLE `verification_requests`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `idx_verification_status` (`status`);

--
-- Indexes for table `wallets`
--
ALTER TABLE `wallets`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Indexes for table `wallet_transactions`
--
ALTER TABLE `wallet_transactions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD KEY `wallet_id` (`wallet_id`);

--
-- Indexes for table `zodiac_signs`
--
ALTER TABLE `zodiac_signs`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `admin_audit_logs`
--
ALTER TABLE `admin_audit_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `admin_notes`
--
ALTER TABLE `admin_notes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `blocked_users`
--
ALTER TABLE `blocked_users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `boosts`
--
ALTER TABLE `boosts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `children_plans`
--
ALTER TABLE `children_plans`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `cities`
--
ALTER TABLE `cities`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `communication_styles`
--
ALTER TABLE `communication_styles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `conversations`
--
ALTER TABLE `conversations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `conversation_participants`
--
ALTER TABLE `conversation_participants`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `countries`
--
ALTER TABLE `countries`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `coupons`
--
ALTER TABLE `coupons`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `daily_user_counters`
--
ALTER TABLE `daily_user_counters`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `device_sessions`
--
ALTER TABLE `device_sessions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `device_tokens`
--
ALTER TABLE `device_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `diets`
--
ALTER TABLE `diets`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `drinking_habits`
--
ALTER TABLE `drinking_habits`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `education_levels`
--
ALTER TABLE `education_levels`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `email_verifications`
--
ALTER TABLE `email_verifications`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `fitness_habits`
--
ALTER TABLE `fitness_habits`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `genders`
--
ALTER TABLE `genders`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `hobbies`
--
ALTER TABLE `hobbies`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `interests`
--
ALTER TABLE `interests`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `interest_categories`
--
ALTER TABLE `interest_categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `invoices`
--
ALTER TABLE `invoices`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `languages`
--
ALTER TABLE `languages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `location_history`
--
ALTER TABLE `location_history`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `login_history`
--
ALTER TABLE `login_history`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `love_languages`
--
ALTER TABLE `love_languages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `matches`
--
ALTER TABLE `matches`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `message_attachments`
--
ALTER TABLE `message_attachments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `message_reactions`
--
ALTER TABLE `message_reactions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `moderation_queues`
--
ALTER TABLE `moderation_queues`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `movie_genres`
--
ALTER TABLE `movie_genres`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `music_genres`
--
ALTER TABLE `music_genres`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `occupations`
--
ALTER TABLE `occupations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `opening_moves`
--
ALTER TABLE `opening_moves`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `otps`
--
ALTER TABLE `otps`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pets`
--
ALTER TABLE `pets`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `political_views`
--
ALTER TABLE `political_views`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `profile_prompts`
--
ALTER TABLE `profile_prompts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `profile_visitors`
--
ALTER TABLE `profile_visitors`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `recommendation_queues`
--
ALTER TABLE `recommendation_queues`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `refresh_tokens`
--
ALTER TABLE `refresh_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `registration_tokens`
--
ALTER TABLE `registration_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `relationship_goals`
--
ALTER TABLE `relationship_goals`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `religions`
--
ALTER TABLE `religions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `reports`
--
ALTER TABLE `reports`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `rewinds`
--
ALTER TABLE `rewinds`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `security_logs`
--
ALTER TABLE `security_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `show_me`
--
ALTER TABLE `show_me`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `sleep_habits`
--
ALTER TABLE `sleep_habits`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `smoking_habits`
--
ALTER TABLE `smoking_habits`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `sports`
--
ALTER TABLE `sports`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `states`
--
ALTER TABLE `states`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `subscription_plans`
--
ALTER TABLE `subscription_plans`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `swipes`
--
ALTER TABLE `swipes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `user_activities`
--
ALTER TABLE `user_activities`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `user_authentications`
--
ALTER TABLE `user_authentications`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_locations`
--
ALTER TABLE `user_locations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_match_preferences`
--
ALTER TABLE `user_match_preferences`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_notification_preferences`
--
ALTER TABLE `user_notification_preferences`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `user_photos`
--
ALTER TABLE `user_photos`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `user_profiles`
--
ALTER TABLE `user_profiles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `user_profile_prompts`
--
ALTER TABLE `user_profile_prompts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_subscriptions`
--
ALTER TABLE `user_subscriptions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_videos`
--
ALTER TABLE `user_videos`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_visibility_settings`
--
ALTER TABLE `user_visibility_settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `verification_requests`
--
ALTER TABLE `verification_requests`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `wallets`
--
ALTER TABLE `wallets`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `wallet_transactions`
--
ALTER TABLE `wallet_transactions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `zodiac_signs`
--
ALTER TABLE `zodiac_signs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admin_audit_logs`
--
ALTER TABLE `admin_audit_logs`
  ADD CONSTRAINT `admin_audit_logs_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `admins` (`id`);

--
-- Constraints for table `admin_notes`
--
ALTER TABLE `admin_notes`
  ADD CONSTRAINT `admin_notes_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `admins` (`id`),
  ADD CONSTRAINT `admin_notes_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `admin_roles`
--
ALTER TABLE `admin_roles`
  ADD CONSTRAINT `admin_roles_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `admins` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `admin_roles_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `blocked_users`
--
ALTER TABLE `blocked_users`
  ADD CONSTRAINT `blocked_users_ibfk_1` FOREIGN KEY (`blocker_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `blocked_users_ibfk_2` FOREIGN KEY (`blocked_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `boosts`
--
ALTER TABLE `boosts`
  ADD CONSTRAINT `boosts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cities`
--
ALTER TABLE `cities`
  ADD CONSTRAINT `cities_ibfk_1` FOREIGN KEY (`state_id`) REFERENCES `states` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `conversations`
--

--
-- Constraints for table `conversation_participants`
--
ALTER TABLE `conversation_participants`
  ADD CONSTRAINT `conversation_participants_ibfk_1` FOREIGN KEY (`conversation_id`) REFERENCES `conversations` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `conversation_participants_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `daily_user_counters`
--
ALTER TABLE `daily_user_counters`
  ADD CONSTRAINT `daily_user_counters_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `device_sessions`
--
ALTER TABLE `device_sessions`
  ADD CONSTRAINT `device_sessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `device_tokens`
--
ALTER TABLE `device_tokens`
  ADD CONSTRAINT `device_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `interests`
--
ALTER TABLE `interests`
  ADD CONSTRAINT `interests_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `interest_categories` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `invoices`
--
ALTER TABLE `invoices`
  ADD CONSTRAINT `invoices_ibfk_1` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`id`),
  ADD CONSTRAINT `invoices_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `location_history`
--
ALTER TABLE `location_history`
  ADD CONSTRAINT `location_history_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `login_history`
--
ALTER TABLE `login_history`
  ADD CONSTRAINT `login_history_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `matches`
--
ALTER TABLE `matches`
  ADD CONSTRAINT `matches_ibfk_1` FOREIGN KEY (`user1_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `matches_ibfk_2` FOREIGN KEY (`user2_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `matches_ibfk_3` FOREIGN KEY (`unmatched_by_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`conversation_id`) REFERENCES `conversations` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `messages_ibfk_3` FOREIGN KEY (`reply_to_id`) REFERENCES `messages` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `message_attachments`
--
ALTER TABLE `message_attachments`
  ADD CONSTRAINT `message_attachments_ibfk_1` FOREIGN KEY (`message_id`) REFERENCES `messages` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `message_reactions`
--
ALTER TABLE `message_reactions`
  ADD CONSTRAINT `message_reactions_ibfk_1` FOREIGN KEY (`message_id`) REFERENCES `messages` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `message_reactions_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `otps`
--
ALTER TABLE `otps`
  ADD CONSTRAINT `otps_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `profile_visitors`
--
ALTER TABLE `profile_visitors`
  ADD CONSTRAINT `profile_visitors_ibfk_1` FOREIGN KEY (`visitor_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `profile_visitors_ibfk_2` FOREIGN KEY (`visited_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `recommendation_queues`
--
ALTER TABLE `recommendation_queues`
  ADD CONSTRAINT `recommendation_queues_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `recommendation_queues_ibfk_2` FOREIGN KEY (`recommended_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `refresh_tokens`
--
ALTER TABLE `refresh_tokens`
  ADD CONSTRAINT `refresh_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `refresh_tokens_ibfk_2` FOREIGN KEY (`session_id`) REFERENCES `device_sessions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `reports`
--
ALTER TABLE `reports`
  ADD CONSTRAINT `reports_ibfk_1` FOREIGN KEY (`reporter_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reports_ibfk_2` FOREIGN KEY (`reported_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `rewinds`
--
ALTER TABLE `rewinds`
  ADD CONSTRAINT `rewinds_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `rewinds_ibfk_2` FOREIGN KEY (`swipe_id`) REFERENCES `swipes` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD CONSTRAINT `role_permissions_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_permissions_ibfk_2` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `security_logs`
--
ALTER TABLE `security_logs`
  ADD CONSTRAINT `security_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `states`
--
ALTER TABLE `states`
  ADD CONSTRAINT `states_ibfk_1` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `swipes`
--
ALTER TABLE `swipes`
  ADD CONSTRAINT `swipes_ibfk_1` FOREIGN KEY (`swiper_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `swipes_ibfk_2` FOREIGN KEY (`swipee_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`gender_identity_id`) REFERENCES `genders` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `users_ibfk_2` FOREIGN KEY (`interested_in_id`) REFERENCES `genders` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `users_ibfk_3` FOREIGN KEY (`relationship_goal_id`) REFERENCES `relationship_goals` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `user_activities`
--
ALTER TABLE `user_activities`
  ADD CONSTRAINT `user_activities_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_authentications`
--
ALTER TABLE `user_authentications`
  ADD CONSTRAINT `user_authentications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_hobbies`
--
ALTER TABLE `user_hobbies`
  ADD CONSTRAINT `user_hobbies_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_hobbies_ibfk_2` FOREIGN KEY (`hobby_id`) REFERENCES `hobbies` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_interests`
--
ALTER TABLE `user_interests`
  ADD CONSTRAINT `user_interests_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_interests_ibfk_2` FOREIGN KEY (`interest_id`) REFERENCES `interests` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_languages`
--
ALTER TABLE `user_languages`
  ADD CONSTRAINT `user_languages_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_languages_ibfk_2` FOREIGN KEY (`language_id`) REFERENCES `languages` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_locations`
--
ALTER TABLE `user_locations`
  ADD CONSTRAINT `user_locations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_match_preferences`
--
ALTER TABLE `user_match_preferences`
  ADD CONSTRAINT `user_match_preferences_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_match_preferences_ibfk_2` FOREIGN KEY (`interested_gender_id`) REFERENCES `genders` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `user_match_preferences_ibfk_3` FOREIGN KEY (`education_id`) REFERENCES `education_levels` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `user_match_preferences_ibfk_4` FOREIGN KEY (`religion_id`) REFERENCES `religions` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `user_match_preferences_ibfk_5` FOREIGN KEY (`smoking_id`) REFERENCES `smoking_habits` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `user_match_preferences_ibfk_6` FOREIGN KEY (`drinking_id`) REFERENCES `drinking_habits` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `user_match_preferences_ibfk_7` FOREIGN KEY (`relationship_goal_id`) REFERENCES `relationship_goals` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `user_movie_genres`
--
ALTER TABLE `user_movie_genres`
  ADD CONSTRAINT `user_movie_genres_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_movie_genres_ibfk_2` FOREIGN KEY (`movie_genre_id`) REFERENCES `movie_genres` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_music_genres`
--
ALTER TABLE `user_music_genres`
  ADD CONSTRAINT `user_music_genres_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_music_genres_ibfk_2` FOREIGN KEY (`music_genre_id`) REFERENCES `music_genres` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_notification_preferences`
--
ALTER TABLE `user_notification_preferences`
  ADD CONSTRAINT `user_notification_preferences_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_photos`
--
ALTER TABLE `user_photos`
  ADD CONSTRAINT `user_photos_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_preference_children`
--
ALTER TABLE `user_preference_children`
  ADD CONSTRAINT `user_preference_children_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_preference_children_ibfk_2` FOREIGN KEY (`children_id`) REFERENCES `children_plans` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_preference_languages`
--
ALTER TABLE `user_preference_languages`
  ADD CONSTRAINT `user_preference_languages_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_preference_languages_ibfk_2` FOREIGN KEY (`language_id`) REFERENCES `languages` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_preference_pets`
--
ALTER TABLE `user_preference_pets`
  ADD CONSTRAINT `user_preference_pets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_preference_pets_ibfk_2` FOREIGN KEY (`pets_id`) REFERENCES `pets` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_preference_politics`
--
ALTER TABLE `user_preference_politics`
  ADD CONSTRAINT `user_preference_politics_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_preference_politics_ibfk_2` FOREIGN KEY (`political_view_id`) REFERENCES `political_views` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_profiles`
--
ALTER TABLE `user_profiles`
  ADD CONSTRAINT `user_profiles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_profiles_ibfk_10` FOREIGN KEY (`fitness_id`) REFERENCES `fitness_habits` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `user_profiles_ibfk_11` FOREIGN KEY (`sleep_id`) REFERENCES `sleep_habits` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `user_profiles_ibfk_12` FOREIGN KEY (`diet_id`) REFERENCES `diets` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `user_profiles_ibfk_13` FOREIGN KEY (`pets_id`) REFERENCES `pets` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `user_profiles_ibfk_14` FOREIGN KEY (`children_id`) REFERENCES `children_plans` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `user_profiles_ibfk_15` FOREIGN KEY (`love_language_id`) REFERENCES `love_languages` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `user_profiles_ibfk_16` FOREIGN KEY (`communication_style_id`) REFERENCES `communication_styles` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `user_profiles_ibfk_2` FOREIGN KEY (`current_city_id`) REFERENCES `cities` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `user_profiles_ibfk_3` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `user_profiles_ibfk_4` FOREIGN KEY (`education_id`) REFERENCES `education_levels` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `user_profiles_ibfk_5` FOREIGN KEY (`occupation_id`) REFERENCES `occupations` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `user_profiles_ibfk_6` FOREIGN KEY (`religion_id`) REFERENCES `religions` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `user_profiles_ibfk_7` FOREIGN KEY (`political_view_id`) REFERENCES `political_views` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `user_profiles_ibfk_8` FOREIGN KEY (`smoking_id`) REFERENCES `smoking_habits` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `user_profiles_ibfk_9` FOREIGN KEY (`drinking_id`) REFERENCES `drinking_habits` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `user_profile_prompts`
--
ALTER TABLE `user_profile_prompts`
  ADD CONSTRAINT `user_profile_prompts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_profile_prompts_ibfk_2` FOREIGN KEY (`prompt_id`) REFERENCES `profile_prompts` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_sports`
--
ALTER TABLE `user_sports`
  ADD CONSTRAINT `user_sports_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_sports_ibfk_2` FOREIGN KEY (`sport_id`) REFERENCES `sports` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_subscriptions`
--
ALTER TABLE `user_subscriptions`
  ADD CONSTRAINT `user_subscriptions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_subscriptions_ibfk_2` FOREIGN KEY (`plan_id`) REFERENCES `subscription_plans` (`id`);

--
-- Constraints for table `user_videos`
--
ALTER TABLE `user_videos`
  ADD CONSTRAINT `user_videos_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_visibility_settings`
--
ALTER TABLE `user_visibility_settings`
  ADD CONSTRAINT `user_visibility_settings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `verification_requests`
--
ALTER TABLE `verification_requests`
  ADD CONSTRAINT `verification_requests_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `wallets`
--
ALTER TABLE `wallets`
  ADD CONSTRAINT `wallets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `wallet_transactions`
--
ALTER TABLE `wallet_transactions`
  ADD CONSTRAINT `wallet_transactions_ibfk_1` FOREIGN KEY (`wallet_id`) REFERENCES `wallets` (`id`) ON DELETE CASCADE;
COMMIT;

