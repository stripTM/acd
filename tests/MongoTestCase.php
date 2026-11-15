<?php

namespace Acd\Tests;

use MongoDB\Client;
use MongoDB\Database;
use PHPUnit\Framework\TestCase;

/**
 * Base para tests que usan persistencia: antes de cada test deja la base de
 * datos de pruebas con los datos de tests/data.
 */
abstract class MongoTestCase extends TestCase
{
    public const TEST_USER = 'test_user';
    public const TEST_USER_PASSWORD = 'fer';
    public const TEST_USER_TOKEN = '940e9aac0d740736b18be249a04e518343855a5a';

    protected Database $db;

    protected function setUp(): void
    {
        $this->db = (new Client($_ENV['ACD_MONGODB_SERVER']))->selectDatabase($_ENV['ACD_MONGODB_DB']);
        $this->db->drop();
        $this->loadStructures();
        $this->loadUsers();
    }

    private function loadStructures(): void
    {
        $fixture = json_decode(file_get_contents(__DIR__ . '/data/structures_demo.json'), true);
        foreach ($fixture[0] as $id => $structure) {
            $this->db->structure->insertOne(['_id' => $id] + $structure);
        }
    }

    private function loadUsers(): void
    {
        $users = json_decode(file_get_contents(__DIR__ . '/data/auth.json'), true);
        foreach ($users as $id => $user) {
            $this->db->user->insertOne(['_id' => $id] + $user);
        }
        $session = json_decode(file_get_contents(__DIR__ . '/data/auth_permanent_login/31676025316fb555e0bfa12f0bcfd0ea43c4c20e'), true);
        $this->db->authPermanent->insertOne([
            '_id' => $session['token'],
            'login' => $session['login'],
            'rol' => $session['rol'],
            'timestamp' => $session['timestamp'],
        ]);
    }
}
