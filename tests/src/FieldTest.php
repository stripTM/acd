<?php
namespace Acd;


class FieldTest extends \PHPUnit\Framework\TestCase
{
	// ...

	public function testSetData()
	{
		/* Type */
		// Arrange
		$a = new Model\FieldDo();

		// Act
		$a->setId('foo');

		// Assert
		$this->assertEquals('foo', $a->getId());

		// Act
		$a->setType('text_simple');

		// Assert
		$this->assertEquals('text_simple', $a->getType());

		/* Name */
		// Arrange
		$a = new Model\StructureDo();

		// Act
		$a->setName('foo name');

		// Assert
		$this->assertEquals('foo name', $a->getName());

	}
}
