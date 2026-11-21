<?php
use Acd\View\Icon;
use Acd\View\Badge;
?>
<main id="manageStructure">
	<form action="do_process_structure.php" method="post">
		<div class="ehead">
			<div class="etitle">
				<div class="etitleRow"><h2><?=htmlspecialchars($structureName)?></h2></div>
				<div class="meta">Estructura · arrastra los campos para ordenarlos</div>
			</div>
			<div class="acts actions">
				<input type="hidden" name="a" value="<?=$actionValue?>"/>
				<button type="submit" name="accion" value="save" class="btn pri publish"><?=Icon::svg('check')?> Guardar</button>
			</div>
		</div>
		<p class="result <?=$resultCode?>"><?=$resultDesc?></p>
		<div class="ebody">
			<div class="lcol">
			<?php
			$structure_fields = '';
			$n = 0;
			foreach ($fields as $field) {
				$lockId = ($field->getId() === '' || $field->getId() === $field::EMPTY_ID) ? '' : ' readonly="readonly"';
				// For enumerated field, select with sources
				$selectEnumeratedSource = '';
				if ($field->getType() === $field::TYPE_LIST_MULTIPLE || $field->getType() === $field::TYPE_LIST_OPTIONS) {
					$enumeratedSelected = $field->getOptions()->getId();
					$optionEnumerateSource = '';
					foreach ($enumeratedList as $item) {
						$key = $item['id'];
						$value = $item['id'];
						$selected = $key === $enumeratedSelected ? ' selected="selected"' : '';
						$optionEnumerateSource .= '<option value="'.htmlspecialchars($key).'"'.$selected.'>'.htmlspecialchars($value).'</option>';
					}
					$selectEnumeratedSource = '<div class="fgrp"><label for="field_'.$n.'_source">Origen de las opciones</label> <select  name="field['.$n.'][source]" id="field_'.$n.'_source" class="source select">'.$optionEnumerateSource.'</select></div>';
				}
				// Related contents can restrict structures asociated
				$restrictedStructures = '';
				if ($field->getType() === $field::TYPE_CONTENT || $field->getType() === $field::TYPE_COLLECTION) {

					$optionsRestristedStructures = '';
					foreach ($structures as $structure) {
						$key = $structure->getId();
						$value = $structure->getName();
						$selected = $field->getRestrictedStructures()->hasKey($key)
							? ' selected="selected"'
							: '';
						$optionsRestristedStructures .= '<option value="'.htmlspecialchars($key).'"'.$selected.'>'.htmlspecialchars($value).'</option>';
					}
					$restrictedStructures = '
						<div class="fgrp restricted-structures-wrap">
							<label for="field_'.$n.'_restrictedStructures">Restringir a las estructuras</label>
							<select name="field['.$n.'][restrictedStructures][]" id="field_'.$n.'_restrictedStructures" multiple="multiple" class="field select">'.
										$optionsRestristedStructures.'
									</select>
						</div>';
				}

				$structure_fields .= '<li class="field">
					<div class="fieldDef">
						<div class="fieldHead">
							<span class="chip acc">'.htmlspecialchars(Badge::fieldTypeName($field->getType())).'</span>
							<span class="delete">
								<input type="checkbox" name="field['.$n.'][delete]" value="1" id="delete_field_'.$n.'"/>
								<label for="delete_field_'.$n.'" class="inlineLabel">Eliminar</label>
							</span>
						</div>
						<div class="two">
							<div class="fgrp">
								<label for="field_'.$n.'_id">Id</label>
								<input type="text" name="field['.$n.'][id]" id="field_'.$n.'_id" value="'.htmlspecialchars($field->getId()).'"'.$lockId.' required="required" placeholder="Id del campo" class="mono"/>
							</div>
							<div class="fgrp">
								<label for="field_'.$n.'_name">Descripción</label>
								<input type="text" name="field['.$n.'][name]" id="field_'.$n.'_name" value="'.htmlspecialchars($field->getName()).'"/>
								<input type="hidden" name="field['.$n.'][type]" value="'.htmlspecialchars($field->getType()).'"/>
							</div>
						</div>
						'.$restrictedStructures
						.$selectEnumeratedSource.'
					</div>
					</li>';
				$n++;
			}
			?>
			<fieldset class="card ecard fields">
				<legend><span class="bx"><?=Icon::svg('list')?></span>Campos<small><?=$n?> <?=$n === 1 ? 'campo' : 'campos'?></small></legend>
				<ul class="items"><?=$structure_fields?></ul>
				<?php if ($n === 0) { ?><p class="empty">Esta estructura todavía no tiene campos.</p><?php } ?>
			</fieldset>
			<fieldset class="card ecard fields newField">
				<legend><span class="bx"><?=Icon::svg('plus')?></span>Añadir campo</legend>
				<?php
				$field_types = '';
				foreach ($fieldTypes as $key => $value) {
					if ($key === \Acd\Model\FieldDo::TYPE_LIST_MULTIPLE_STICKY) {
						$typeName = $value;
					}
					else {
						$typeName = ucfirst(Badge::fieldTypeName($key));
					}
					$field_types .= '<li>
						<input type="radio" name="new_field" value="'.htmlspecialchars($key).'" id="field_'.$key.'"/>
						<label for="field_'.$key.'">'.htmlspecialchars($typeName).'</label>
						</li>';
				}
				?>
				<ul class="typeChoices"><?=$field_types?></ul>
				<div class="formActions"><button type="submit" name="accion" value="add" class="btn add"><?=Icon::svg('plus')?> Añadir</button></div>
			</fieldset>
			</div>
			<div class="rcol">
				<fieldset class="card ecard common">
					<legend><span class="bx"><?=Icon::svg('info')?></span>Datos comunes</legend>
					<div class="fgrp">
						<label for="idStructure">Id</label><input type="text" name="id" id="idStructure" value="<?=htmlspecialchars($structureId)?>" readonly="readonly" class="mono"/>
					</div>
					<div class="fgrp">
						<label for="name">Nombre</label><input type="text" name="name" id="name" value="<?=htmlspecialchars($structureName)?>" required="required"/>
					</div>
					<div class="fgrp">
						<?php
						$options = '';
						foreach ($storageTypes as $key => $value) {
							$selected = $storage === $key ? ' selected="selected"' : '';
							$disabled = $value['disabled'] ? ' disabled="disabled"' : '';
							$options .= '<option value="'.htmlspecialchars($key).'"'.$selected.$disabled.'>'.htmlspecialchars($value['name']).'</option>';
						}
						?>
						<label for="storage">Tipo de almacenamiento</label><select name="storage" id="storage" required="required"><?=$options?></select>
					</div>
				</fieldset>
			</div>
		</div>
	</form>

	<details class="card ecard dev_sample">
		<summary>Ejemplos para desarrolladores</summary>
		<pre class="mono">
			// Can use contentLoader->loadContents(...) to return ContentsDo collection with the 0:n ContentDo matching elements
			// Can use contentLoader->loadContent(...) to return ContentDo object,  discret content ie. number in count query or null if matching is not done

			// Sample #1 by id, only content without related content
			$contentLoader = new \Acd\Model\ContentLoader();
			$contentLoader->setId('<?=htmlspecialchars($structureId)?>');
			$plainContent = $contentLoader->loadContent('id', $idContent);

			// Sample #2 by id, with n related levels
			$contentLoader = new \Acd\Model\ContentLoader();
			$contentLoader->setId('<?=htmlspecialchars($structureId)?>');
			$contentWithLevelOfDepth = $contentLoader->loadContent('id-deep', ['id' => $idContent, 'depth' => 5]);

			// Sample #3 by any match tag, with n related levels
			$contentLoader = new \Acd\Model\ContentLoader();
			$contentLoader->setId('<?=htmlspecialchars($structureId)?>');
			$contentsByTagWithLevelOfDepth = $contentLoader->loadContent('tag-deep', ['tags' => ['portadacine', 'otros'], 'depth' => 2]);

			// Sample #4 only one content by any match tag, with n related levels
			$contentLoader = new \Acd\Model\ContentLoader();
			$contentLoader->setId('<?=htmlspecialchars($structureId)?>');
			$contentByTagWithLevelOfDepth = $contentLoader->loadContent('tag-one-deep', ['tags' => ['portadacine', 'otros'], 'depth' => 2]);

			// Sample #5 by any match tag, with n related levels and only content in date
			$contentLoader = new \Acd\Model\ContentLoader();
			$contentLoader->setId('<?=htmlspecialchars($structureId)?>');
			$contentByTagWithLevelOfDepth = $contentLoader->loadContent('tag-one-deep', ['tags' => ['portadacine', 'otros'], 'depth' => 2, 'validity-date' => time()]);

			// Sample #6 by alias-id, with n related leveles and only content in date
			$contentLoader = new \Acd\Model\ContentLoader();
			$contentLoader->setId('<?=htmlspecialchars($structureId)?>');
			$content = $contentLoader->loadContent('alias-id-deep', ['id' => $aliasIdContent, 'depth' => 5, 'validity-date' => time()]);

			// Sample #7 by id, with n related levels and only content in date and profile JAZZ
			$contentLoader = new \Acd\Model\ContentLoader();
			$contentLoader->setId('<?=htmlspecialchars($structureId)?>');
			$content = $contentLoader->loadContent('id-deep', ['id' => $idContent, 'depth' => 5, 'validity-date' => time(), 'profile' => 'JAZZ']);

			// Sample #8 difuse search by alias-id, e.g. one/two/three match by one/two/three &amp; one/two &amp; one
			$aliasId='one/two/three';
			$contentLoader = new \Acd\Model\ContentLoader();
			$contentLoader->setId('<?=htmlspecialchars($structureId)?>'); // Optional
			$matchContents = $contentLoader->loadContent('difuse-alias-id', ['id' => $aliasId]);

			// Sample #9 difuse search by alias-id, e.g. one/two/three match by one/two/three &amp; one/two &amp; one and only content in date
			$aliasId='one/two/three';
			$contentLoader = new \Acd\Model\ContentLoader();
			$contentLoader->setId('<?=htmlspecialchars($structureId)?>'); // Optional
			$matchContents = $contentLoader->loadContent('difuse-alias-id', ['id' => $aliasId, 'validity-date' => time()]);

			// And get values of fields
<?php
				foreach ($fields as $field) {
?>
			echo $plainContent->getFields()->getValue('<?=htmlspecialchars($field->getId())?>');
<?php
				}
?>

			// Manage pure data
			var_dump($contentWithLevelOfDepth->tokenizeData());
		</pre>
	</details>
</main>
