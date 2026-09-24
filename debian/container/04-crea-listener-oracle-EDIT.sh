#!/bin/bash
# basado en el scrip del profesor
# editar
ASIGNATURA="bda"

#Crea un listener de Oracle en modo silencioso
echo "==> Creando listener de Oracle en modo silencioso"
echo "==> Verificando que el usuario actual sea 'oracle'..."
if [ "$(whoami)" != "oracle" ]; then
echo "Error: este script debe ejecutarse como usuario 'oracle'."
exit 1
fi

#Ajustar el valor de <asignatura> según corresponda (bd, bda o bdd)
rsp_file="${UNAM_HOME}/${ASIGNATURA}/practicas/03/debian/container/listener_silet.rsp"
echo "==> Verificando la existencia del archivo de respuestas $rsp_file..."
if [ ! -f "$rsp_file" ]; then
echo "Error: el archivo $rsp_file no se encuentra."
exit 1
fi
## verificando que no haya un listener ya, para que el script sea ..
echo "==> Verificando si el listener ya existe..."
lsnrctl status > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "==> El listener ya está creado y en ejecución. Omitiendo la creación."
    exit 0
fi


echo "==> Creando listener con archivo de respuestas $rsp_file"
netca -silent -responseFile $rsp_file

echo "==> Verificando el status del listener..."
lsnrctl status
if [ $? -eq 0 ]; then
echo "==> Listener creado y en ejecución correctamente."
else
echo "Error: no se pudo crear o iniciar el listener."
exit 1
fi
