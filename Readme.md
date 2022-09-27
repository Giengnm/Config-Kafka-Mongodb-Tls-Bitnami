# Migración de MongoDB y Kafka de OCP3 a OCP4

Dentro del proceso de migración en la parte del dato se ha incluido MongoDB, Kafka y todo su entorno de herramientas necesarias para el desarrollo del proyecto

## MongoDB
En un principio se iba a pasar de MongoDB 4.4.8 a MongoDB 5, pero el hecho de requerir TLS y ciertos problemas, se tomó la decisión de ir a una versión superior. La versión 6.0.1. Esto también nos facilitará bastante actualizaciones futuras de la BD's.
Y como hemos comentado, la inclusión de TLS en el clúster

[MongoDB 4.4.8 to MongoDB 6.0.1 migration](MongoDB Sharded Cluster/Readme.md)

## Kafka

En el apartado de Kafka, estos son los elementos clave en la migración:
- [Kafka (Brokers y Zookeepers)](./Kafka Cluster/Readme.md)
- [Schema registry](./Kafka Cluster/Schema-registry/Readme.md)
- [Kafka Connect](./Kafka Cluster/Kafka-connect/Readme.md)

Para poder gestionarlos, hemos añadido un nuevisimo sistema de control y monitorización:
- [UI for Kafka](./Kafka Cluster/UI-for-kafka/Readme.md)

El siguiente punto importante es la parte de la activación del TLS para las comunicaciones

## Proceso de migración

Aunque no es obligatorio seguir un orden prestablecido, nuestra recomendación es que se siga el siguiente orden en el proceso de despliegue de todos los elementos, ya que existen ciertas dependencias entre elementos, que, si no lo hacemos así, nos obligará a volver atrás en algunos casos

>**NOTA:** No es obligatorio seguir este orden ya que siempre se pueden hacer los cambios que se necesiten en la parametrización del elemento correspondiente y volver a desplegar

### Orden de instalación de las cosas

1. [MongoDB](./MongoDB%20Sharded%20Cluster/Readme.md)
Si desde Kafka Connect pensamos conectarnos a MongoDB, es importante hacer el despliegue con anterioridad, ya que Kafka Connect necesita para dicha conexión:

   1. El nombre de los Pods donde están los frontales</br>
   2. Certificados de conexión al clúster

2. [Kafka](./Kafka%20Cluster/Readme.md)
Schema registry y Kafka Connect necesitan que el clúster de Kafka esté listo con antelación
3. [Schema registry](./Kafka%20Cluster/Schema-registry/Readme.md)
Kafka Connect necesita que le indiquemos donde tenemos nuestro sistema de registro de esquemas, por lo que lo ideal es tenerlo antes
4. [Kafka Connect](./Kafka%20Cluster/Kafka-connect/Readme.md)
5. [UI for Kafka](./Kafka%20Cluster/UI-for-kafka/Readme.md)
Lo dejamos para el final ya que al ser un sistema de panel de control general desde donde podemos verificar el estado de Kafka, Kafka Connect y Schema registry, los necesita a todos