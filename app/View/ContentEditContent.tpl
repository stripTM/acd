<?php
	use Acd\View\Icon;
	use Acd\View\Badge;

	$idHtml = htmlspecialchars($idContent);
	$isNew = isset($bNew) && $bNew === true;
	$relationCount = $content->getCountParents();
	$aliasIdCount = $content->getCountAliasId();
	$deleteDisabled = $relationCount > 0 ? ' disabled="disabled" title="No se puede eliminar: está en uso en otros contenidos"' : '';
	$urlEdit = '?a=edit&amp;id='.urlencode((string) $content->getId()).'&amp;idt='.urlencode($content->getIdStructure());
	$urlList = '?a=list_contents&amp;id='.urlencode($content->getIdStructure());
	$headTitle = $contentTitle !== '' && $contentTitle !== null ? htmlspecialchars($contentTitle) : 'Nuevo contenido';
	$savedAgo = $content->getId() ? Badge::elapsed($content->getSaveTime()) : '';
?>
<main class="editor">
	<?php
		if(isset($jsonSummary)) {
	?>
		<a href="<?=$urlEdit?>" class="dr-bg" aria-label="Cerrar resumen"></a>
		<section class="contentSummary drawer">
			<div class="dh">
				<span class="bx"><?=Icon::svg('code')?></span>
				<h2>Resumen</h2>
				<a href="<?=$urlEdit?>" class="iconbtn close" title="Cerrar" aria-label="Cerrar"><?=Icon::svg('close')?></a>
			</div>
			<pre class="mono"><?=htmlspecialchars($jsonSummary)?></pre>
		</section>
	<?php
		}
	?>
	<form action="do_process_content.php" method="post" enctype="multipart/form-data">
		<div class="ehead">
			<div class="etitle">
				<div class="etitleRow">
					<h2><?=$headTitle?></h2>
					<?=$content->getId() ? Badge::validity($content) : '<span class="pill p-gray">Sin guardar</span>'?>
				</div>
				<div class="meta">
					<a href="<?=$urlList?>" class="structure_name"><?=htmlspecialchars($structure->getName())?></a>
					<?=$savedAgo ? ' · Guardado '.$savedAgo : ''?>
				</div>
			</div>
			<div class="acts actions">
				<button type="submit" name="a" value="save" class="btn pri publish"><?=Icon::svg('check')?> Guardar</button>
				<button type="submit" name="a" value="summary" class="btn summary"><?=Icon::svg('code')?> Resumen</button>
				<?php
					if($content->getId()) {
				?>
					<button type="submit" name="a" value="clone" class="btn clone"><?=Icon::svg('copy')?> Clonar</button>
					<button type="submit" name="a" value="delete" class="btn ghost-bad delete"<?=$deleteDisabled?>><?=Icon::svg('trash')?> Eliminar</button>
				<?php
					}
				?>
			</div>
		</div>
		<p class="result <?=$resultCode?>"><?=$resultDesc?></p>
		<div class="inner-form ebody">
			<div class="lcol">
				<?php
				// TODO: ¡¡bastante enrevesado para estar dentro de un tpl!!
				$fieldOU = new Acd\View\Field();
				$fields = $structure->getFields();
				$sections = []; // Consecutive fields of the same family share a card, the order of the structure is preserved
				$n = 0;
				foreach ($fields as $field) {
					$idField = $field->getId();
					try {
						$fieldFromContent = $content->getFields()->get($idField);
						$field->loadData($idField, $fieldFromContent->tokenizeData()[$idField], false); // TODO: ¡¡bastante enrevesado para estar dentro de un tpl!!
					}
					catch( \Exception $e ) {
						$field->loadData($idField, '', true);
					}
					$fieldOU->setField($field);
					$fieldOU->setId($n);
					$fieldOU->setParent($content);

					$section = Badge::fieldSection($field->getType());
					$last = count($sections) - 1;
					if ($last < 0 || $sections[$last]['id'] !== $section['id']) {
						$section['items'] = [];
						$sections[] = $section;
						$last++;
					}
					$sections[$last]['items'][] = '<li class="fgrp type-'.htmlspecialchars($field->getType()).'">'.Badge::labelHint($fieldOU->render(), Badge::fieldTypeName($field->getType())).'</li>';

					$n++;
				}
				?>
				<div class="card ecard titleCard">
					<input type="hidden" name="id[]" value="<?=$idHtml?>"/>
					<input type="hidden" name="ids[<?=$idHtml?>]" value="<?=htmlspecialchars($content->getIdStructure())?>"/>
					<div class="fgrp">
						<label for="title_<?=$idHtml?>">Título <em class="hint">· obligatorio</em></label>
						<input type="text" name="title[<?=$idHtml?>]" id="title_<?=$idHtml?>" value="<?=htmlspecialchars($contentTitle)?>" required="required" class="field text" maxlength="256"/>
					</div>
				</div>
				<?php
				foreach ($sections as $section) {
					$numFields = count($section['items']);
				?>
				<fieldset class="card ecard fields">
					<legend><span class="bx"><?=Icon::svg($section['icon'])?></span><?=$section['title']?><small><?=$numFields?> <?=$numFields === 1 ? 'campo' : 'campos'?></small></legend>
					<ul class="fields"><?=implode('', $section['items'])?></ul>
				</fieldset>
				<?php
				}
				?>
			</div>
			<div class="rcol">
				<fieldset class="card ecard internal">
					<legend><span class="bx"><?=Icon::svg('info')?></span>Datos internos</legend>
					<ul>
						<li class="fgrp item">
						<?php
							$periodOfValidity = \Acd\Model\ValueFormater::encode($content->getPeriodOfValidity(), \Acd\Model\ValueFormater::TYPE_DATE_TIME_RANGE, \Acd\Model\ValueFormater::FORMAT_EDITOR );
						?>
							<label for="validityPeriodStart_<?=$idHtml?>">Vigencia</label>
							<div class="two">
								<input type="datetime" name="validityPeriod[<?=$idHtml?>][start]" id="validityPeriodStart_<?=$idHtml?>" value="<?=htmlspecialchars($periodOfValidity[\Acd\Model\contentDO::PERIOD_OF_VALIDITY_START])?>" class="range start" placeholder="Inicio" aria-label="Inicio de vigencia"/>
								<input type="datetime" name="validityPeriod[<?=$idHtml?>][end]" id="validityPeriodEnd_<?=$idHtml?>" value="<?=htmlspecialchars($periodOfValidity[\Acd\Model\contentDO::PERIOD_OF_VALIDITY_END])?>" class="range end" placeholder="Fin" aria-label="Fin de vigencia"/>
							</div>
						</li>
						<li class="fgrp item">
							<label for="aliasId_<?=$idHtml?>">Alias-id</label>
							<input type="text" name="aliasId[<?=$idHtml?>]" id="aliasId_<?=$idHtml?>" value="<?=htmlspecialchars($aliasId)?>" class="field aliasId mono" maxlength="256"/>
							<?php
								if($aliasIdCount > 1) {
							?>
								<p class="result info">El alias-id está repetido <a href="alias_id.php?id=<?=urlencode($aliasId)?>"><?=$aliasIdCount?></a> veces.</p>
							<?php
								}
							?>
						</li>
						<li class="fgrp item">
							<label for="tags_<?=$idHtml?>" class="for-tag">Etiquetas</label>
							<input type="text" name="tags[<?=$idHtml?>]" id="tags_<?=$idHtml?>" value="<?=htmlspecialchars($contentTags)?>" class="field tags"<?=$tagsReadonly?>/>
						</li>
						<li class="fgrp item">
							<?=$profileOU->render()?>
						</li>
					</ul>
				</fieldset>
				<?php
					if($content->getCountParents() !== null && $relationCount > 0) {
				?>
					<div class="card ecard usedIn">
						<h4><span class="bx"><?=Icon::svg('link')?></span>Usado en<small><?=$relationCount?> <?=$relationCount == 1 ? 'contenido' : 'contenidos'?></small></h4>
						<a href="relation.php?id=<?=urlencode($content->getId())?>&amp;idt=<?=urlencode($content->getIdStructure())?>" class="btn"><?=Icon::svg('link')?> Ver relaciones</a>
					</div>
				<?php
					}
				?>
			</div>
		</div>
	</form>
</main>
