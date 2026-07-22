<?php
namespace Api\Mail;

require_once __DIR__ . '/../../vendor/autoload.php';

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

class Mailer {
    private $config;
    private $mail;

    public function __construct() {
        $this->config = require __DIR__ . '/../../config/smtp.php';
        
        // Only initialize PHPMailer if we are NOT using Brevo API
        if (empty($this->config['brevo_api_key'])) {
            $this->mail = new PHPMailer(true);
            $this->mail->isSMTP();
            $this->mail->Host       = $this->config['host'];
            $this->mail->SMTPAuth   = true;
            $this->mail->Username   = $this->config['username'];
            $this->mail->Password   = $this->config['password'];
            $this->mail->SMTPSecure = $this->config['encryption'];
            $this->mail->Port       = $this->config['port'];
            $this->mail->setFrom($this->config['from_email'], $this->config['from_name']);
            $this->mail->isHTML(true);
        }
    }

    public function sendOTP($toEmail, $otp) {
        $time = date('H:i:s');
        $subject = "Your Registration OTP - Dating App ({$time})";
        $htmlContent = "Hello,<br><br>Your OTP for registration is: <b>{$otp}</b><br>It will expire in 5 minutes.<br><br>Thanks,<br>Dating App Team";
        
        if (!empty($this->config['brevo_api_key'])) {
            return $this->sendViaBrevo($toEmail, $subject, $htmlContent);
        } else {
            return $this->sendViaPHPMailer($toEmail, $subject, $htmlContent);
        }
    }

    public function sendMail($toEmail, $subject, $body) {
        if (!empty($this->config['brevo_api_key'])) {
            return $this->sendViaBrevo($toEmail, $subject, $body);
        } else {
            return $this->sendViaPHPMailer($toEmail, $subject, $body);
        }
    }
    
    private function sendViaPHPMailer($toEmail, $subject, $htmlContent) {
        try {
            $this->mail->clearAddresses();
            $this->mail->addAddress($toEmail);
            $this->mail->Subject = $subject;
            $this->mail->Body    = $htmlContent;
            $this->mail->AltBody = strip_tags($htmlContent);
            
            $this->mail->send();
            return true;
        } catch (Exception $e) {
            throw new \Exception("PHPMailer Error: " . $this->mail->ErrorInfo);
        }
    }

    private function sendViaBrevo($toEmail, $subject, $htmlContent) {
        $apiKey = $this->config['brevo_api_key'] ?? '';
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
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false); 

        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $error = curl_error($ch);
        curl_close($ch);

        if ($httpCode >= 200 && $httpCode < 300) {
            return true;
        } else {
            throw new \Exception("Brevo API Error: " . $response . " | CURL ERROR: " . $error);
        }
    }
}
