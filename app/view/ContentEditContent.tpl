<?php
	$title = (isset($bNew) && $bNew === true)
		? 'New content'
		: 'Edit content <spam class="structure_name">'.htmlspecialchars($structure->getName()).'</spam>';
	$relationCount = $content->getCountParents();
	$deleteDisabled = $relationCount > 0 ? ' disabled="disabled"' : '';
?>
<main>
	<h2><?=$title?></h2>
	<?php
		if($content->getCountParents() !== null) {
	?>
		<p>#Relations: <?=$relationCount?></p>
	<?php
		}
	?>
	<p class="result"><?=$resultDesc?></p>
	<form action="do_process_content.php" method="post">
		<fieldset class="internal">
			<legend>Internal data</legend>
			<input type="hidden" name="id" value="<?=htmlspecialchars($content->getId())?>"/>
			<input type="hidden" name="ids" value="<?=htmlspecialchars($content->getIdStructure())?>"/>
			<ul>
				<li>
					<label for="title">Title</label>: <input type="text" name="title" id="title" value="<?=htmlspecialchars($contentTitle)?>" required="required"/>
				</li>
				<li>
					<label for="tags">Tags</label>: <input type="text" name="tags" id="tags" value="<?=htmlspecialchars($contentTags)?>"<?=$userRol?>/>
				</li>
			</ul>
		</fieldset>
		<div>
			<?php
			$fieldOU = new Acd\View\Field();
			$fields = $structure->getFields();
			$structure_fields = '';
			$n = 0;
			foreach ($fields as $field) {
				$idField = $field->getName();
				try {
					$fieldFromContent = $content->getFields()->get($idField);
					//+d($fieldFromContent->tokenizeData()[$idField]);
					$field->loadData($idField, $fieldFromContent->tokenizeData()[$idField], false); // TODO: ¡¡bastante enrevesado para estar dentro de un tpl!!
				}
				catch( \Exception $e ) {
					$field->loadData($idField, '', true);
				}
				$fieldOU->setField($field);
				$fieldOU->setId($n);
				$fieldOU->setParent($content);
				$structure_fields .= '<li>'.$fieldOU->render().'</li>';

				$n++;
			}
			?>
			<fieldset class="fields">
				<legend>Fields</legend>
				<ul class="fields"><?=$structure_fields?></ul>
			</fieldset>
		</div>
		<input type="submit" name="a" value="save" class="button publish"/>
		<?php
			if($content->getId()) {
		?>
			<input type="submit" name="a" value="clone" class="button clone"/>
			<input type="submit" name="a" value="delete" class="button delete"<?=$deleteDisabled?>/>
		<?php
			}
		?>
	</form>
</main>