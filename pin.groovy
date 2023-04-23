#!groovy
node {
    
    stage('Image pull'){
        sh "docker pull httpd" //pull de la imagen a docker

    }
    stage('Run'){
        sh "docker run -d -p 8088:80 httpd" //ejecuta la imagen para crear el contenedor, de manera que se mantenga iniciado, en el puerto 8088 
       
        sh 'sleep 5' 
         
    }
    stage('Deploy'){
        def arrayContainer = sh(script:"docker ps | grep httpd", returnStdout:true) //traelos datos del container
        arrayContainer = arrayContainer.tokenize()[0]//convierte los datos en array, y guarda la posicion 0 en la variable
        println arrayContainer //print de variable para validar
        sh "docker exec -i ${arrayContainer} bash -c 'echo \"<html><body><h1>Hola mundo!</h1></body></html>\" > /usr/local/apache2/htdocs/index.html'" //se ingresa en el contenedor usando la variable para indicar cual es y se modifica el index
    
    }
  
    }