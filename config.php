<?php

// Lookup-Server Config

$CONFIG = [
	'DB' => [
		'host' => getenv('MYSQL_HOST'),
		'db' => getenv('MYSQL_DATABASE'),
		'user' => getenv('MYSQL_USER'),
		'pass' => getenv('MYSQL_PASSWORD'),
	],

	'GLOBAL_SCALE' => true,

	'AUTH_KEY' => getenv('GSS_JWT_KEY'),
];

