#!/bin/sh
#para eliminar una pdb
#editar
PDB="mqrbda"

#verificar que sea oracle
if [ "$(whoami)" != "oracle" ]; then
echo "Error: este script debe ejecutarse como usuario 'oracle'."
exit 1
fi


#eliminar la BD
dbca -silent -deletePluggableDatabase \
  -sourceDB FREE \
  -pdbName ${PDB} 
