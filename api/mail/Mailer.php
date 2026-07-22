<?php
namespace Api\Mail;

class Mailer {
    private $config;

    public function __construct() {
        $this->config = require __DIR__ . '/../../config/smtp.php';
    }

    public function sendOTP($toEmail, $otp) {
        $time = date('H:i:s');
        $subject = "Your Registration OTP - Dating App ({$time})";
        $htmlContent = "Hello,<br><br>Your OTP for registration is: <b>{$otp}</b><br>It will expire in 5 minutes.<br><br>Thanks,<br>Dating App Team";
        
        return $this->sendViaBrevo($toEmail, $subject, $htmlContent);
    }

    public function sendMail($toEmail, $subject, $body) {
        return $this->sendViaBrevo($toEmail, $subject, $body);
    }

    private function sendViaBrevo($toEmail, $subject, $htmlContent) {
        // We will use Brevo (formerly Sendinblue) HTTP API to send emails
        // This avoids all SMTP port blocking and disabled mail() function issues on free hosting.
        
        $apiKey = $this->config['brevo_api_key'] ?? '';
        
        if (empty($apiKey)) {
            error_log("Brevo API key is missing in config/smtp.php");
            return false;
        }

        $url = 'https://api.brevo.com/v3/smtp/email';
        
        $data = [
            'sender' => [
                'name' => $this->config['from_name'],
                'email' => $this->config['from_email']
            ],
            'to' => [
                ['email' => $toEmail]
            ],
            'subject' => $subject,
            'htmlContent' => $htmlContent
        ];

        $ch = curl_init($url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            'accept: application/json',
            'api-key: ' . $apiKey,
            'content-type: application/json'
        ]);
        
        // Disabled SSL verification as free hosts often have outdated SSL CA certificates which breaks curl
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false); 

        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $error = curl_error($ch);
        curl_close($ch);

        if ($httpCode >= 200 && $httpCode < 300) {
            return true;
        } else {
            error_log("Brevo API Error: " . $response . " CURL ERROR: " . $error);
            return false;
        }
    }
}
