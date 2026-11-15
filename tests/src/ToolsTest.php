<?php
namespace Acd;

class ToolsTest extends \PHPUnit\Framework\TestCase
{
	// ...

	public function testSetData()
	{
		$tools = new View\Tools();
		$this->assertEquals('<strong>Tools</strong>', $tools->render());
	}
}
