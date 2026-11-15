<?php
namespace Acd;

use Acd\Model\ContentDo;
use Acd\Model\ContentLoader;
use Acd\Model\StructureDo;
use Acd\Tests\MongoTestCase;

class ContentTest extends MongoTestCase
{
	private const STRUCTURE = 'chat_tienda';

	private function newContent(string $title): ContentDo
	{
		$structure = new StructureDo();
		$structure->setId(self::STRUCTURE);
		$structure->loadFromFile();

		$content = new ContentDo();
		$content->buildSkeleton($structure);
		$content->setTitle($title);
		$content->setFieldValue('foo', 'valor de foo');
		$content->setFieldValue('abierta', true);
		return $content;
	}

	private function loader(): ContentLoader
	{
		$loader = new ContentLoader();
		$loader->setId(self::STRUCTURE);
		return $loader;
	}

	public function testSetData()
	{
		$content = new ContentDo();
		$content->setId('foo');
		$content->setIdStructure('structure foo');

		$this->assertSame('foo', $content->getId());
		$this->assertSame('structure foo', $content->getIdStructure());
	}

	public function testSaveNewContent()
	{
		$saved = $this->loader()->saveContent($this->newContent('Contenido nuevo'));

		$this->assertNotEmpty($saved->getId());
		$this->assertSame(1, $this->db->content->countDocuments(['id_structure' => self::STRUCTURE]));

		$loaded = $this->loader()->loadContent('id', $saved->getId());
		$this->assertSame('Contenido nuevo', $loaded->getTitle());
		$this->assertSame('valor de foo', $loaded->getFieldValue('foo'));
		$this->assertTrue($loaded->getFieldValue('abierta'));
	}

	public function testUpdateContent()
	{
		$saved = $this->loader()->saveContent($this->newContent('Título inicial'));

		$content = $this->loader()->loadContent('id', $saved->getId());
		$content->setTitle('Título modificado');
		$content->setFieldValue('foo', 'otro valor');
		$this->loader()->saveContent($content);

		$loaded = $this->loader()->loadContent('id', $saved->getId());
		$this->assertSame('Título modificado', $loaded->getTitle());
		$this->assertSame('otro valor', $loaded->getFieldValue('foo'));
		$this->assertSame(1, $this->db->content->countDocuments());
	}

	public function testDeleteContent()
	{
		$saved = $this->loader()->saveContent($this->newContent('Para borrar'));

		$this->loader()->deleteContent($saved->getId());

		$this->assertNull($this->loader()->loadContent('id', $saved->getId()));
		$this->assertSame(0, $this->db->content->countDocuments());
	}
}
