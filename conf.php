<?php
namespace Acd;
//Ficheros
define(__NAMESPACE__ .'\DIR_BASE', dirname(__FILE__));

class conf {
	public static $DIR_TEMPLATES;
	public static $DATA_PATH;
	public static $DATA_DIR_PATH;
	public static $STORAGE_TYPES;
	public static $STORAGE_TYPE_TEXTPLAIN;
	public static $STORAGE_TYPE_MONGODB;
	public static $STORAGE_TYPE_MYSQL;
	public static $DEFAULT_STORAGE;
	public static $FIELD_TYPES;
	public static $PERMISSION_PATH;
	public static $USE_AUTHENTICATION;
	public static $AUTH_PERSITENT_EXPIRATION_TIME;
	public static $PATH_AUTH_CREDENTIALS_FILE;
	public static $PATH_AUTH_PREMANENT_LOGIN_DIR;
	public static $ROL_DEVELOPER;
	public static $ROL_EDITOR;
	public static $MYSQL_SERVER;
	public static $MYSQL_USER;
	public static $MYSQL_PASSWORD;
	public static $MYSQL_SCHEMA;
	public static $MONGODB_SERVER;
}
conf::$DIR_TEMPLATES = DIR_BASE.'/app/view';
conf::$DATA_PATH = DIR_BASE.'/data/structures.json';
conf::$DATA_DIR_PATH = DIR_BASE.'/data/structures';
conf::$STORAGE_TYPE_TEXTPLAIN  = 'text/plain';
conf::$STORAGE_TYPE_MONGODB  = 'mongodb';
conf::$STORAGE_TYPE_MYSQL  = 'mysql';
conf::$STORAGE_TYPES = [
		conf::$STORAGE_TYPE_TEXTPLAIN => 
			[
				'name' => 'text/plain',
				'disabled' => true
			],
		conf::$STORAGE_TYPE_MONGODB =>
			[
				'name' => 'Mongo DB',
				'disabled' => false
			],
		conf::$STORAGE_TYPE_MYSQL =>
			[
				'name' => 'MySql',
				'disabled' => true
			]
	];
conf::$DEFAULT_STORAGE = conf::$STORAGE_TYPE_MONGODB;

conf::$PERMISSION_PATH = DIR_BASE.'/data/permission.json';
conf::$USE_AUTHENTICATION = true;
conf::$AUTH_PERSITENT_EXPIRATION_TIME = 31536000; // 1 year
conf::$PATH_AUTH_CREDENTIALS_FILE = DIR_BASE.'/data/auth.json';
conf::$PATH_AUTH_PREMANENT_LOGIN_DIR = DIR_BASE.'/data/auth_permanent_login';

conf::$ROL_DEVELOPER = 'developer';
conf::$ROL_EDITOR = 'editor';

conf::$MYSQL_SERVER = 'localhost';
conf::$MYSQL_USER = 'usuarioweb';
conf::$MYSQL_PASSWORD = 'strip';
conf::$MYSQL_SCHEMA = 'acd';

conf::$MONGODB_SERVER = 'mongodb://plusdbspol01.prisadigital.int:27017,plusdbspol02.prisadigital.int:27017,plusdbspol03.prisadigital.int:27017/?replicaSet=ReplicaPlusProduccion';

// Developer / local / personal  configuration
if (file_exists(DIR_BASE.'/conf.devel.php')) {
	require DIR_BASE.'/conf.devel.php';
}
/* Debug */
if (file_exists(DIR_BASE.'/../tools/kint/Kint.class.php')) {
	require DIR_BASE.'/../tools/kint/Kint.class.php';
}