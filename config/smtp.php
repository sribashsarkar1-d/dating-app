<?php

require_once __DIR__ . '/../vendor/autoload.php';

if (file_exists(__DIR__ . '/../.env')) {
    $dotenv = Dotenv\Dotenv::createImmutable(__DIR__ . '/../');
    $dotenv->load();
}

return [
    'host' => $_ENV['SMTP_HOST'] ?? 'smtp.gmail.com',
    'port' => $_ENV['SMTP_PORT'] ?? 587,
    'encryption' => 'tls',
    'username' => $_ENV['SMTP_USERNAME'] ?? '',
    'password' => $_ENV['SMTP_PASSWORD'] ?? '',
    'from_name' => $_ENV['SMTP_FROM_NAME'] ?? 'Dating App',
    'from_email' => $_ENV['SMTP_FROM_EMAIL'] ?? '',
    'brevo_api_key' => $_ENV['BREVO_API_KEY'] ?? ''
];
