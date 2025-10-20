<?php

declare(strict_types=1);

namespace App;

final readonly class Application
{
	public function run(): void
	{
		$dir = __DIR__.'/../var';
		if (!is_dir($dir)) {
			mkdir($dir);
		}

		$logFile = "$dir/test.log";
		$logMessage = sprintf(
			"%s  - Test log entry from user %s\n",
			date('Y-m-d H:i:s'),
			get_current_user(),
		);

		false !== file_put_contents($logFile, $logMessage, FILE_APPEND);
	}
}
