// Inicialización de la BBDD de ACD (solo se ejecuta con el volumen de datos vacío)
const acd = db.getSiblingDB(process.env.MONGO_INITDB_DATABASE || 'acd');

['content', 'relation', 'structure', 'enumerated', 'user', 'authPermanent'].forEach((name) => {
  if (!acd.getCollectionNames().includes(name)) acd.createCollection(name);
});

acd.relation.createIndex({ parent: 1, child: 1 });
acd.content.createIndex({ id_structure: 1, tags: 1 });
acd.content.createIndex({ id_structure: 1, alias_id: 1 });
acd.authPermanent.createIndex({ login: 1 });

// Usuario de desarrollo admin / admin (rol developer). Cambiar en cualquier entorno no local.
acd.user.updateOne(
  { _id: 'admin' },
  { $setOnInsert: { password: '$2y$11$RKF6R.pPS7s2yHS27vfaD.qT0Jbu8HfxvBBOPi9cALOMq2sKStrFq', rol: 'developer', save_ts: Math.floor(Date.now() / 1000) } },
  { upsert: true }
);
