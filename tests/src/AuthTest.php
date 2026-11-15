<?php
namespace Acd;

use Acd\Model\Auth;
use Acd\Tests\MongoTestCase;

class AuthTest extends MongoTestCase
{
	public function testLoginByCredentials()
	{
		$this->assertTrue(Auth::loginByCredentials(self::TEST_USER, self::TEST_USER_PASSWORD, false));
		$this->assertSame(self::TEST_USER, $_SESSION['login']);
		$this->assertSame('developer', $_SESSION['rol']);

		$this->assertFalse(Auth::loginByCredentials(self::TEST_USER, 'bad password', false));
		$this->assertFalse(Auth::loginByCredentials('bad_test_user', self::TEST_USER_PASSWORD, false));
	}

	public function testLoginByPersistence()
	{
		$this->assertTrue(Auth::loginByPersintence(self::TEST_USER, self::TEST_USER_TOKEN));
		$this->assertSame('editor', $_SESSION['rol']);

		$this->assertFalse(Auth::loginByPersintence(self::TEST_USER, 'bad token'));
		$this->assertFalse(Auth::loginByPersintence('other_user', self::TEST_USER_TOKEN));
	}
}
