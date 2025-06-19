# **Docker Big Data Stack: Hadoop, Spark, Kafka, Hive & JupyterLab**

## **📌 Introducción al Big Data**
Este proyecto implementa un **entorno completo de Big Data** usando Docker, ideal para:
- Pruebas locales de procesamiento distribuido
- Desarrollo de pipelines ETL/ELT
- Experimentación con herramientas de análisis de datos
- Aprendizaje de ecosistemas Hadoop/Spark

### **Servicios Incluidos**
| Herramienta | Versión | Rol |
|-------------|---------|-----|
| **Hadoop** | 3.3.6 | Almacenamiento distribuido (HDFS) + YARN |
| **Spark** | 3.5.0 | Procesamiento distribuido |
| **Kafka** | 3.6.1 | Stream processing |
| **Hive** | 4.0.0 | Data warehouse SQL |
| **JupyterLab** | 4.x | Entorno de notebooks con Python |

---

## **🐳 Beneficios de esta Configuración Docker**
✅ **Aislamiento completo**: Sin conflictos con instalaciones locales  
✅ **Optimización de recursos**: Uso eficiente de CPU/RAM  
✅ **Preconfigurado**: Todos los servicios integrados y comunicados  
✅ **Entorno reproducible**: Funciona igual en cualquier sistema  

### **Características Clave**
- Usuario no-root (`bigdata`) por seguridad
- JupyterLab con **21 librerías** preinstaladas (TensorFlow, PySpark, Pandas, etc.)
- Configuración automática de redes entre contenedores
- Volúmenes persistentes para datos

---

## **🌐 URLs de los Servicios**
Accede desde tu navegador en `http://localhost:PUERTO`:

| Servicio | Puerto | URL | Credenciales |
|----------|--------|-----|-------------|
| **HDFS NameNode** | 9870 | `http://localhost:9870` | - |
| **YARN ResourceManager** | 8088 | `http://localhost:8088` | - |
| **Spark History Server** | 18080 | `http://localhost:18080` | - |
| **JupyterLab** | 8888 | `http://localhost:8888` | Sin contraseña |
| **Hive Server2** | 10002 | `jdbc:hive2://localhost:10002` | - |

---
## 🧩 Estructura del Proyecto

```
.
├── Dockerfile.apoyo       # Imagen base para workers
├── Dockerfile.inicio      # Imagen para nodo maestro
├── docker-compose.yml     # Configuración de contenedores
├── build-images.sh        # Script para construir imágenes
├── entrypoint-apoyo.sh    # Script de inicio para workers
├── entrypoint-inicio.sh   # Script de inicio para master
└── config/                # Archivos de configuración
    ├── hadoop/            #   - Configuración Hadoop
    ├── hive/              #   - Configuración Hive
    └── spark/             #   - Configuración Spark
```
## 🛠️ Requisitos Previos

- Docker Engine 20.10+
- Docker Compose 2.5+
- 8GB+ RAM recomendado
- 20GB+ espacio en disco
- Sistema operativo Linux/macOS/WSL2 (Windows)

## 🚀 Instalación Paso a Paso

1. **Clonar el repositorio**:
   ```bash
   git clone https://github.com/samuro74/bigdata-docker
   cd bigdata-docker
   ```

2. **Dar permisos de ejecución**:
   ```bash
   chmod +x build-images.sh entrypoint-*.sh
   ```

3. **Construir las imágenes Docker**:
   ```bash
   ./build-images.sh
   ```
   *Este proceso puede tardar varios minutos*

4. **Iniciar los contenedores**:
   ```bash
   docker-compose up -d
   ```

5. **Verificar el estado**:
   ```bash
   docker ps
   ```
---

## **🔍 Comprobaciones Básicas**
### **1. Verifica servicios activos**
```bash
docker exec namenode jps
# Deberías ver: NameNode, ResourceManager, etc.
```

### **2. Prueba HDFS**
```bash
docker exec namenode hdfs dfs -ls /
# Debería mostrar el directorio root vacío
```

### **3. Ejemplo en JupyterLab**
Crea un notebook y ejecuta:
```python
from pyspark.sql import SparkSession
spark = SparkSession.builder.getOrCreate()
df = spark.createDataFrame([(1, "demo")], ["id", "text"])
df.show()
```

---

## **🚀 Demostraciones Prácticas**
### **1. WordCount con Spark**
```python
text_file = spark.sparkContext.textFile("hdfs://namenode:9000/README.md")
counts = text_file.flatMap(lambda line: line.split(" ")) \
                 .map(lambda word: (word, 1)) \
                 .reduceByKey(lambda a, b: a + b)
counts.saveAsTextFile("hdfs://namenode:9000/output")
```

### **2. Kafka Producer/Consumer**
```bash
# Terminal 1 (Producer)
docker exec namenode bash -c "echo 'test-message' | kafka-console-producer.sh --broker-list localhost:9092 --topic demo"

# Terminal 2 (Consumer)
docker exec namenode kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic demo --from-beginning
```

### **3. Consultas Hive**
```bash
docker exec namenode hive -e "CREATE TABLE demo (id INT, name STRING);"
```

---

## **⚙️ Comandos Útiles**
| Acción | Comando |
|--------|---------|
| Iniciar cluster | `docker-compose up -d` |
| Detener cluster | `docker-compose down` |
| Ver logs | `docker logs namenode` |
| Acceder a shell | `docker exec -it namenode bash` |

---

## **📚 Recursos Adicionales**
- [Documentación Hadoop](https://hadoop.apache.org/docs/stable/)
- [Guía Spark en Python](https://spark.apache.org/docs/latest/api/python/)
- [Ejemplos de Kafka](https://kafka.apache.org/quickstart)

---

**🎉 ¡Tu entorno Big Data está listo!**  
Contribuciones y issues son bienvenidos en [bigdata-docker](https://github.com/samuro74/bigdata-docker).
Para reportar problemas o sugerencias, por favor abre un issue en el repositorio.
```
