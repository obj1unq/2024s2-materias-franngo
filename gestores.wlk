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
        //validar que estaba inscrito en la materia
        estudiante.validarNoEstaAprobada(materia)
        self.validarNotaAprobatoria(nota)
        const materiaAprobada = new Aprobacion (estudiante = estudiante, materia = materia, nota = nota)
        estudiante.materiasAprobadas().add(materiaAprobada)
    }

    method validarNotaAprobatoria(nota) {
        if(nota<4 || nota>10) {
            self.error("No se puede registrar porque la nota no es una nota aprobatoria")
        }
    }

}

object gestorInscripcion {

    method puedeInscribirseA(estudiante, materia) {
        return materia.existeCoincidenciaCarreraEstudiante(estudiante) && !estudiante.tieneAprobada(materia) &&
               !estudiante.estaCursando(materia) && estudiante.tieneAprobadosRequisitos(materia)
    }

    method inscribirEstudianteEn(estudiante, materia) {
        self.validarPuedeInscribirseA(estudiante, materia)
        estudiante.materiasCursando().add(materia)
        //falta ver tema cupos (no se añade que está cursando así nomas)
    }

    method validarPuedeInscribirseA(estudiante, materia) {
        if(!self.puedeInscribirseA(estudiante, materia)) {
            self.error("No se puede realizar la inscripción porque el estudiante no está habilitado a inscribirse a esa materia")
        }
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
*/

/*1. Determinar si un estudiante puede inscribirse a una materia. Para esto se deben cumplir cuatro condiciones: 
    - la materia debe corresponder a alguna de las carreras que esté cursando el estudiante, 
    - el estudiante no puede haber aprobado la materia previamente, 
    - el estudiante no debe estar estar ya inscripto en esa materia,
    - el estudiante debe tener aprobadas todas las materias que se declaran como _requisitos_ de la materia a la que se quiere inscribir.  
    P.ej., para que un estudiante pueda inscribirse a Objetos 2, es necesario tener aprobadas Objetos 1 y Matemática 1.
*/