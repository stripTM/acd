<?php
namespace Acd;

use Acd\Tests\MongoTestCase;



class StructureTest extends MongoTestCase
{
	// ...

	public function testSetData()
	{
		/* Id */
		// Arrange
		$a = new Model\StructureDo();

		// Act
		$a->setId('foo id');

		// Assert
		$this->assertEquals('foo id', $a->getId());

		/* Name */
		// Arrange
		$a = new Model\StructureDo();

		// Act
		$a->setName('foo name');

		// Assert
		$this->assertEquals('foo name', $a->getName());

		/* Storage */
		// Arrange
		$a = new Model\StructureDo();

		// Act
		$a->setStorage('mongodb');

		// Assert
		$this->assertEquals('mongodb', $a->getStorage());

	}

	public function testFields() {
		/* Add */
		$a = new Model\StructureDo();
		$f = new Model\FieldDo();
		$f->setId('foo');
		$f->setName('var');
		$f->setType('text_simple');
		$this->assertEquals('foo', $f->getId());
		$this->assertEquals('var', $f->getName());
		$this->assertEquals('text_simple', $f->getType());

		$a->addField($f);
		$field = $a->getFields()->get('foo');
		$this->assertEquals('foo', $field->getId());
		$this->assertEquals('var', $field->getName());
		$this->assertEquals('text_simple', $field->getType());
	}

	public function testLoadFromFile() {
		$a = new Model\StructureDo();
		$a->setId('chat_tienda');
		$a->loadFromFile();
		$this->assertEquals('chat_tienda', $a->getId());
		$this->assertEquals('Chat de tienda online', $a->getName());
		$this->assertEquals('mongodb', $a->getStorage());

		$field = $a->getFields()->get('foo');
		$this->assertEquals('foo', $field->getId());
		$this->assertEquals('pretty', $field->getName());
		$this->assertEquals('text_simple', $field->getType());

		$field = $a->getFields()->get('abierta');
		$this->assertEquals('abierta', $field->getId());
		$this->assertEquals('Abierta', $field->getName());
		$this->assertEquals('boolean', $field->getType());

		$this->expectException(Model\KeyInvalidException::class);
		$a->getFields()->get('no_exists');
	}
}
