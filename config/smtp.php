<?php

require_once __DIR__ . '/../vendor/autoload.php';

if (file_exists(__DIR__ . '/../.env')) {
    $dotenv = Dotenv\Dotenv::createUnsafeImmutable(__DIR__ . '/../');
    $dotenv->load();
}

return [
    'host' => $_ENV['SMTP_HOST'] ?? $_SERVER['SMTP_HOST'] ?? getenv('SMTP_HOST') ?: 'smtp.gmail.com',
    'port' => $_ENV['SMTP_PORT'] ?? $_SERVER['SMTP_PORT'] ?? getenv('SMTP_PORT') ?: 587,
    'encryption' => 'tls',
    'username' => $_ENV['SMTP_USERNAME'] ?? $_SERVER['SMTP_USERNAME'] ?? getenv('SMTP_USERNAME') ?: 'sribashsarkarblp@gmail.com',
    'password' => $_ENV['SMTP_PASSWORD'] ?? $_SERVER['SMTP_PASSWORD'] ?? getenv('SMTP_PASSWORD') ?: 'hjdxusaxmpwcwsgk',
    'from_name' => $_ENV['SMTP_FROM_NAME'] ?? $_SERVER['SMTP_FROM_NAME'] ?? getenv('SMTP_FROM_NAME') ?: 'Dating App',
    'from_email' => $_ENV['SMTP_FROM_EMAIL'] ?? $_SERVER['SMTP_FROM_EMAIL'] ?? getenv('SMTP_FROM_EMAIL') ?: 'sribashsarkarblp@gmail.com',
    'brevo_api_key' => $_ENV['BREVO_API_KEY'] ?? $_SERVER['BREVO_API_KEY'] ?? getenv('BREVO_API_KEY') ?: ''
];
