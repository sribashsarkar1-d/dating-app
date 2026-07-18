<?php
namespace Api\Mail;

require_once __DIR__ . '/../../vendor/autoload.php';

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

class Mailer {
    private $mail;

    public function __construct() {
        $config = require __DIR__ . '/../../config/smtp.php';

        $this->mail = new PHPMailer(true);
        $this->mail->isSMTP();
        $this->mail->Host       = $config['host'];
        $this->mail->SMTPAuth   = true;
        $this->mail->Username   = $config['username'];
        $this->mail->Password   = $config['password'];
        $this->mail->SMTPSecure = $config['encryption'];
        $this->mail->Port       = $config['port'];
        $this->mail->setFrom($config['from_email'], $config['from_name']);
        $this->mail->isHTML(true);
    }

    public function sendOTP($toEmail, $otp) {
        try {
            $this->mail->clearAddresses();
            $this->mail->addAddress($toEmail);
            $time = date('H:i:s');
            $this->mail->Subject = "Your Registration OTP - Dating App ({$time})";
            $this->mail->Body    = "Hello,<br><br>Your OTP for registration is: <b>{$otp}</b><br>It will expire in 5 minutes.<br><br>Thanks,<br>Dating App Team";
            $this->mail->AltBody = "Hello, Your OTP for registration is: {$otp}. It will expire in 5 minutes.";
            
            $this->mail->send();
            return true;
        } catch (Exception $e) {
            return false;
        }
    }

    public function sendMail($toEmail, $subject, $body) {
        try {
            $this->mail->clearAddresses();
            $this->mail->addAddress($toEmail);
            $this->mail->Subject = $subject;
            $this->mail->Body    = $body;
            $this->mail->AltBody = strip_tags($body);
            
            $this->mail->send();
            return true;
        } catch (Exception $e) {
            return false;
        }
    }
}
