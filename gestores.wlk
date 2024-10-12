import aprobacion.*
import carrera.*
import estudiante.*
import materia.*

object gestorAprobacion {

    //Aclaración = Se implementa el sistema bajo la idea de que, para que se pueda registrar la aprobación de una materia, la misma debe
    //estar siendo cursada por dicho estudiante, por lo que se valida que este se encuentre cursando la misma. De no ser así, no se
    //registra dicha aprobación
    //(que la esté cursando implica que existeCoincidenciaCarreraEstudiante() y tieneAprobadosRequisitos() se cumplen, por lo que no
    //se vuelve a validar eso)
    method registrarMateriaAprobada(estudiante, materia, nota) {
        estudiante.validarEstaEfectivamenteInscrito(materia)
        estudiante.validarNoEstaAprobada(materia) //esto ya se chequea al inscribirse, así que es medio redundante
        self.validarNotaAprobatoria(nota)
        const materiaAprobada = new Aprobacion (estudiante = estudiante, materia = materia, nota = nota)
        estudiante.materiasAprobadas().add(materiaAprobada)
        materia.liberarCupoDe(estudiante)
    }

    method validarNotaAprobatoria(nota) {
        if(nota<4 || nota>10) {
            self.error("No se puede registrar la nota porque la nota no es una nota aprobatoria")
        }
    }

}

object gestorInscripcion {

    method puedeInscribirseA(estudiante, materia) {
        return materia.existeCoincidenciaCarreraEstudiante(estudiante) && !estudiante.tieneAprobada(materia) &&
               !estudiante.estaCursandoOEnEspera(materia) && estudiante.tieneAprobadosRequisitos(materia)
    }

    method inscribirEstudianteEn(estudiante, materia) {
        self.validarPuedeInscribirseA(estudiante, materia)
        materia.inscribirEstudiante(estudiante)
    }

    method validarPuedeInscribirseA(estudiante, materia) {
        if(!self.puedeInscribirseA(estudiante, materia)) {
            self.error("No se puede realizar la inscripción porque el estudiante no está habilitado a inscribirse a esa materia")
        }
    }

    method darDeBajaEstudianteEn(estudiante, materia) {
        estudiante.validarEstaEfectivamenteInscrito(materia)
        materia.liberarCupoDe(estudiante)
    }

}

/*
    1. Inscribir un estudiante a una materia, verificando las condiciones de inscripción de la materia. Si no se cumplen las 
    condiciones, lanzar un error.  
    Además, cada materia tiene un “cupo”, es decir, una cantidad máxima de estudiantes que se pueden inscribir. Para manejar el exceso
    en los cupos, las materias tienen una lista de espera, de estudiantes que quisieran cursar pero no tienen lugar 
    (ver punto 5).
    O sea, como resultado de la inscripción, el estudiante puede, o bien quedar confirmado, o bien quedar en lista de espera.  
    No se requiere que el sistema conteste nada con respecto al resultado de la inscripción. 
    LISTO

    1. Dar de baja un estudiante de una materia. En caso de haber estudiantes en lista de espera, el primer estudiante de la lista debe
     obtener su lugar en la materia.
     LISTO

1. Brindar resultados de inscripción, específicamente:
    * Los estudiantes inscriptos a una materia dada.
    * Los estudiantes en lista de espera para una materia dada.
    LISTO

1. Brindar información útil para une estudiante, específicamente: las materias en las que está inscripto, las materias en las que quedó
 en lista de espera. Para esto, usar la lista de todas las materias de las carreras que cursa, resuelto en un punto anterior.
    LISTO

1. Más información sobre une estudiante: dada una carrera, conocer todas las materias de esa carrera a las que se puede inscribir. Sólo
 vale si el estudiante está cursando esa carrera.  
*/

