<?php
namespace Acd\View;

use Acd\Model\StructuresDo;
// Output
class Tools extends Template {
	public function setLogin($login) {
		$this->__set('login', $login);
	}
	public function setRol($rol) {
		$this->__set('rol', $rol);
	}
	private function loadStructures() {
		$structures = new StructuresDo();
		try {
			$structures->loadFromFile();
		}
		catch (\Exception $e) {
			// The navigation must not break the page if the storage is not available
		}
		return $structures;
	}
	public function render($tpl = '') {
		$this->__set('structures', $this->loadStructures());
		$this->__set('currentScript', basename($_SERVER['SCRIPT_NAME'] ?? ''));
		$this->__set('currentIdStructure', (string) ($_REQUEST['idt'] ?? (($_REQUEST['a'] ?? '') === 'list_contents' || ($_REQUEST['a'] ?? '') === 'delete' ? ($_REQUEST['id'] ?? '') : '')));
		return parent::render($_ENV['ACD_DIR_TEMPLATES'].'/Tools.tpl');
	}
}
