<?php

declare(strict_types=1);

require_once __DIR__.'/../vendor/autoload.php';

use App\Application;
use Symfony\Component\Dotenv\Dotenv;

$dotenv = new Dotenv();
$dotenv->loadEnv(__DIR__.'/../.env');

new Application()->run();
