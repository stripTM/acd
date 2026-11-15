<?php
namespace Acd;

use Acd\Model\KeyHasUseException;
use Acd\Model\KeyInvalidException;
use Acd\Model\StructureDo;
use Acd\Model\StructuresDo;
use Acd\Tests\MongoTestCase;

class StructuresTest extends MongoTestCase
{
    private function newStructure(string $id): StructureDo
    {
        $structure = new StructureDo();
        $structure->setId($id);
        $structure->setName("Name $id");
        $structure->setStorage('mongodb');
        return $structure;
    }

    public function testLoadList()
    {
        $structures = new StructuresDo();
        $structures->loadFromFile();

        $this->assertCount(3, $structures->getAllStructures());
    }

    public function testAdd()
    {
        $structures = new StructuresDo();
        for ($n = 0; $n < 5; $n++) {
            $structures->add($this->newStructure("foo $n"), "foo $n");
        }

        $this->assertCount(5, $structures->getAllStructures());
        $this->assertSame('foo 3', $structures->get('foo 3')->getId());

        $this->expectException(KeyHasUseException::class);
        $structures->add($this->newStructure('foo 3'), 'foo 3');
    }

    public function testGet()
    {
        $structures = new StructuresDo();
        $structures->loadFromFile();

        $chat = $structures->get('chat_tienda');
        $this->assertSame('chat_tienda', $chat->getId());
        $this->assertSame('Chat de tienda online', $chat->getName());
        $this->assertSame('mongodb', $chat->getStorage());

        $programa = $structures->get('programa_tv');
        $this->assertSame('Programas TV', $programa->getName());
        $this->assertSame('text/plain', $programa->getStorage());

        $this->expectException(KeyInvalidException::class);
        $structures->get('no product');
    }

    public function testRemove()
    {
        $structures = new StructuresDo();
        $structures->loadFromFile();
        $structures->remove('chat_tienda');

        $this->assertCount(2, $structures->getAllStructures());

        $this->expectException(KeyInvalidException::class);
        $structures->remove('no product');
    }

    public function testSavePersistsInMongoDB()
    {
        $structures = new StructuresDo();
        $structures->loadFromFile();
        $structures->remove('programa_tv');
        $structures->add($this->newStructure('nueva'), 'nueva');
        $structures->save();

        $reloaded = new StructuresDo();
        $reloaded->loadFromFile();
        $this->assertEqualsCanonicalizing(
            ['chat_tienda', 'estructura_texto', 'nueva'],
            $reloaded->keys()
        );
    }
}
