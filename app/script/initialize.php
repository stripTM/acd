<?php
namespace Acd;

require ('../../autoload.php');
$mongo = new \MongoClient();
$db = $mongo->acd;

$aCollections = [
	'content',
	'relation',
	'structure'
	];
$aCollectionsInDB = [];
$aCollectionsInDB = $db->getCollectionNames();
foreach ($aCollections as $collectionName) {
	if (in_array($collectionName, $aCollectionsInDB)) {
		echo "$collectionName is ok\n";
	}
	else {
		echo "Creating $collectionName\n";
		$db->createCollection($collectionName, false);
	}
}

// Relation
echo "Creating indexed in relation collection\n";
$mongoCollection = $db->selectCollection('relation');
$mongoCollection->createIndex (['parent' => 1, 'child' => 1]);
var_dump($mongoCollection->getIndexInfo());

// Content
echo "Creating indexed in content collection\n";
$mongoCollection = $db->selectCollection('content');
$mongoCollection->createIndex (['id_structure' => 1, 'tags' => 1]);
var_dump($mongoCollection->getIndexInfo());