<?php

declare(strict_types=1);

use Symfony\Component\Dotenv\Dotenv;

require_once __DIR__.'/../vendor/autoload.php';

$testEnvPath = __DIR__.'/../.env.test';
if (file_exists($testEnvPath)) {
	$dotenv = new Dotenv();
	$dotenv->load($testEnvPath);
}

$_ENV['APP_ENV'] = 'test';
$_ENV['APP_DEBUG'] = 'true';

$directories = [
	__DIR__.'/../var/cache',
	__DIR__.'/../var/logs',
	__DIR__.'/../var/coverage',
];

foreach ($directories as $directory) {
	if (!is_dir($directory)) {
		mkdir($directory, 0o755, true);
	}
}
