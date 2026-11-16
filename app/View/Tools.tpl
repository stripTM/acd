<?php
use Acd\View\Icon;
use Acd\View\Badge;

$isDeveloper = $rol == 'developer';
$isEditor = $isDeveloper || $rol == 'editor';
$isContentSection = in_array($currentScript, ['content.php', 'content_rel.php', 'relation.php', 'alias_id.php']);
$navItems = [];
if ($isEditor) {
	$navItems[] = ['content.php', 'grid', 'Contenidos', $isContentSection && $currentIdStructure === ''];
}
if ($isDeveloper) {
	$navItems[] = ['index.php', 'layers', 'Estructuras', $currentScript === 'index.php'];
	$navItems[] = ['enumerated.php', 'list', 'Enumerados', $currentScript === 'enumerated.php'];
	$navItems[] = ['user.php', 'users', 'Usuarios', $currentScript === 'user.php'];
	$navItems[] = ['install.php', 'db', 'Instalación', $currentScript === 'install.php'];
}
$rolNames = ['developer' => 'Desarrollador', 'editor' => 'Editor'];
?>
<aside id="tools" class="side rol-<?=htmlspecialchars($rol)?>">
	<a href="content.php" class="logo"><span class="mk">ACD</span><span class="nm">ACD<small>Contenidos dinámicos</small></span></a>
	<nav>
		<?php
		foreach ($navItems as [$url, $icon, $label, $isCurrent]) {
		?>
			<a href="<?=$url?>" class="nav<?=$isCurrent ? ' on' : ''?>"><?=Icon::svg($icon)?> <?=$label?></a>
		<?php
		}
		if ($isEditor && $structures->length() > 0) {
		?>
			<div class="sect">Tipos de contenido</div>
			<div class="navStructures">
			<?php
			foreach ($structures as $structure) {
				$isCurrent = $isContentSection && $currentIdStructure === (string) $structure->getId();
			?>
				<a href="content.php?a=list_contents&amp;id=<?=urlencode($structure->getId())?>" class="nav<?=$isCurrent ? ' on' : ''?>"><span class="dot" style="background:<?=Badge::structureColor($structure->getId())?>"></span><span class="navLabel"><?=htmlspecialchars($structure->getName())?></span></a>
			<?php
			}
			?>
			</div>
		<?php
		}
		?>
	</nav>
	<div class="me">
		<span class="av"><?=htmlspecialchars(Badge::initials($login))?></span>
		<span class="who"><?=htmlspecialchars($login)?><small><?=htmlspecialchars($rolNames[$rol] ?? $rol)?></small></span>
		<a href="do_logout.php" class="iconbtn logout" rel="nofollow" title="Cerrar sesión (<?=htmlspecialchars($login)?>)" aria-label="Cerrar sesión"><?=Icon::svg('logout')?></a>
	</div>
</aside>
<div id="sideBackdrop"></div>
