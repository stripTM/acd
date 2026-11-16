<?php
namespace Acd\View;

use Acd\Model\ContentDo;
use Acd\Model\FieldDo;

// Small visual pieces shared by several templates
class Badge {
	private const STRUCTURE_COLORS = ['#2563eb', '#db2777', '#059669', '#d97706', '#7c3aed', '#0891b2'];
	private const SOON_SECONDS = 7 * 24 * 3600;
	private const TYPE_NAMES = [
		FieldDo::TYPE_TEXT_SIMPLE => 'texto simple',
		FieldDo::TYPE_TEXT_MULTILINE => 'texto multilínea',
		FieldDo::TYPE_RICH_TEXT => 'texto enriquecido',
		FieldDo::TYPE_TEXT_HANDMADE_HTML => 'HTML manual',
		FieldDo::TYPE_INTEGER => 'número entero',
		FieldDo::TYPE_FLOAT => 'número decimal',
		FieldDo::TYPE_RANGE => 'rango',
		FieldDo::TYPE_BOOLEAN => 'booleano',
		FieldDo::TYPE_DATE => 'fecha',
		FieldDo::TYPE_DATE_TIME => 'fecha y hora',
		FieldDo::TYPE_DATE_RANGE => 'rango de fechas',
		FieldDo::TYPE_DATE_TIME_RANGE => 'rango de fechas con hora',
		FieldDo::TYPE_CONTENT => 'referencia a contenido',
		FieldDo::TYPE_COLLECTION => 'colección de contenidos',
		FieldDo::TYPE_FILE => 'archivo',
		FieldDo::TYPE_LINK => 'enlace',
		FieldDo::TYPE_LIST_OPTIONS => 'selección',
		FieldDo::TYPE_LIST_MULTIPLE => 'selección múltiple',
		FieldDo::TYPE_COORDINATE => 'coordenada',
		FieldDo::TYPE_COLOR_RGB => 'color RGB',
		FieldDo::TYPE_COLOR_RGBA => 'color RGBA',
	];
	// Sections of the content editor, by field type
	private const SECTIONS = [
		'content' => ['Contenido', 'type', [FieldDo::TYPE_TEXT_SIMPLE, FieldDo::TYPE_TEXT_MULTILINE, FieldDo::TYPE_RICH_TEXT, FieldDo::TYPE_TEXT_HANDMADE_HTML]],
		'media' => ['Multimedia', 'img', [FieldDo::TYPE_FILE, FieldDo::TYPE_LINK]],
		'relations' => ['Clasificación y relaciones', 'tag', [FieldDo::TYPE_LIST_OPTIONS, FieldDo::TYPE_LIST_MULTIPLE, FieldDo::TYPE_CONTENT, FieldDo::TYPE_COLLECTION]],
		'data' => ['Datos', 'sliders', []],
	];

	public static function structureColor($idStructure) {
		return self::STRUCTURE_COLORS[abs(crc32((string) $idStructure)) % count(self::STRUCTURE_COLORS)];
	}

	public static function initials($name) {
		$words = preg_split('/[\s_\-]+/u', trim((string) $name), -1, PREG_SPLIT_NO_EMPTY);
		$initials = count($words) > 1
			? mb_substr($words[0], 0, 1).mb_substr($words[1], 0, 1)
			: mb_substr($words[0] ?? '?', 0, 2);
		return mb_strtoupper($initials);
	}

	public static function fieldTypeName($type) {
		return self::TYPE_NAMES[$type] ?? $type;
	}

	// ['id' => ..., 'title' => ..., 'icon' => ...]
	public static function fieldSection($type) {
		foreach (self::SECTIONS as $id => [$title, $icon, $types]) {
			if (in_array($type, $types, true)) {
				return ['id' => $id, 'title' => $title, 'icon' => $icon];
			}
		}
		return ['id' => 'data', 'title' => self::SECTIONS['data'][0], 'icon' => self::SECTIONS['data'][1]];
	}

	// Adds a muted hint to the first label of a rendered field
	public static function labelHint($fieldHtml, $hint) {
		$hintHtml = ' <em class="hint">· '.htmlspecialchars($hint).'</em></label>';
		$position = strpos($fieldHtml, '</label>');
		return $position === false ? $fieldHtml : substr_replace($fieldHtml, $hintHtml, $position, strlen('</label>'));
	}

	private static function finiteTimestamp($value) {
		return ($value && is_numeric($value) && is_finite((float) $value)) ? (int) $value : null;
	}

	// Status pill derived from the period of validity
	public static function validity(ContentDo $content) {
		$period = $content->getPeriodOfValidity();
		$start = self::finiteTimestamp($period[ContentDo::PERIOD_OF_VALIDITY_START] ?? null);
		$end = self::finiteTimestamp($period[ContentDo::PERIOD_OF_VALIDITY_END] ?? null);
		$now = time();
		if ($start !== null && $start > $now) {
			return '<span class="pill p-acc">Programado</span>';
		}
		if ($end !== null && $end < $now) {
			return '<span class="pill p-bad">Caducado</span>';
		}
		if ($end !== null && $end - $now < self::SOON_SECONDS) {
			return '<span class="pill p-warn">Caduca pronto</span>';
		}
		return '<span class="pill p-ok">Vigente</span>';
	}

	public static function validityRange(ContentDo $content) {
		$period = $content->getPeriodOfValidity();
		$start = self::finiteTimestamp($period[ContentDo::PERIOD_OF_VALIDITY_START] ?? null);
		$end = self::finiteTimestamp($period[ContentDo::PERIOD_OF_VALIDITY_END] ?? null);
		if ($start === null && $end === null) {
			return 'Sin fecha';
		}
		return ($start === null ? '∞' : date('d/m/Y', $start)).' – '.($end === null ? '∞' : date('d/m/Y', $end));
	}

	public static function elapsed($timestamp) {
		$timestamp = self::finiteTimestamp($timestamp);
		if ($timestamp === null) {
			return '';
		}
		$seconds = max(0, time() - $timestamp);
		$units = [[365 * 86400, 'a'], [30 * 86400, 'mes'], [7 * 86400, 'sem'], [86400, 'd'], [3600, 'h'], [60, 'min']];
		foreach ($units as [$size, $unit]) {
			if ($seconds >= $size) {
				$amount = intdiv($seconds, $size);
				if ($unit === 'mes' && $amount > 1) {
					$unit = 'meses';
				}
				return "hace $amount $unit";
			}
		}
		return 'ahora';
	}
}
