<?php
// Bootstrap de PHPUnit. Los tests usan MongoDB (como la aplicación) con una
// base de datos propia, ACD_MONGODB_DB=acd_test, que MongoTestCase vacía y
// rellena con los datos de tests/data antes de cada test.

require __DIR__ . '/../vendor/autoload.php';

$env = [
    'ACD_DIR_TEMPLATES' => __DIR__ . '/data/tools/',
    'ACD_DATA_CONTENT_PATH' => sys_get_temp_dir() . '/acd-tests-contents',
    'ACD_DATA_CONTENT_BINARY_ORIGIN_FORM_UPLOAD' => 'FORM_UPLOAD',
    'ACD_DATA_CONTENT_BINARY_ORIGIN_FORM_PATH' => 'PATH',
    'ACD_STORAGE_TYPE_TEXTPLAIN' => 'text/plain',
    'ACD_STORAGE_TYPE_MONGODB' => 'mongodb',
    'ACD_STORAGE_TYPE_MYSQL' => 'mysql',
    'ACD_STORAGE_TYPE_MONGODB_LEGACY' => 'mongodb-legacy',
    'ACD_DEFAULT_STORAGE' => 'mongodb',
    'ACD_USE_AUTHENTICATION' => true,
    'ACD_AUTH_PERSITENT_EXPIRATION_TIME' => 31536000,
    'ACD_ROL_DEVELOPER' => 'developer',
    'ACD_ROL_EDITOR' => 'editor',
    'ACD_MONGODB_SERVER' => getenv('ACD_TEST_MONGODB_SERVER') ?: 'mongodb://mongo:27017',
    'ACD_MONGODB_DB' => 'acd_test',
    'ACD_SESSION_GC_MAXLIFETIME' => 14400,
    'ACD_COOKIE_PREFIX' => 'acd_',
];
foreach ($env as $key => $value) {
    $_ENV[$key] = $value;
}
$_ENV['ACD_STORAGE_TYPES'] = [
    'text/plain' => ['name' => 'text/plain', 'disabled' => true],
    'mongodb' => ['name' => 'Mongo DB', 'disabled' => false],
    'mysql' => ['name' => 'MySql', 'disabled' => true],
    'mongodb-legacy' => ['name' => 'Mongo DB Legacy', 'disabled' => true],
];
