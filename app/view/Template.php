<?php
namespace Acd\View;
// http://chadminick.com/articles/simple-php-template-engine.html
class TemplateException extends \Exception {}
class Template {
	private $vars = array();

	public function __get($name) {
		return $this->vars[$name];
	}

	public function __set($name, $value) {
		if($name == 'view_template_file') {
			throw new Exception("Cannot bind variable named 'view_template_file'");
		}
		$this->vars[$name] = $value;
	}

	public function render($view_template_file) {
		if (!file_exists($view_template_file)) {
			throw new TemplateException("Unknown template [$view_template_file]", 1);
			
		}
		if(array_key_exists('view_template_file', $this->vars)) {
			throw new TemplateException("Cannot bind variable called 'view_template_file'");
		}
		extract($this->vars);
		ob_start();
		include($view_template_file);
		return ob_get_clean();
	}
}