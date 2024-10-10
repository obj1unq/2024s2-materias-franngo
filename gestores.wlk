import aprobacion.*
import carrera.*
import estudiante.*
import materia.*

object gestorAprobacion {

    method registrarMateriaAprobada(estudiante, materia, nota) {
        //validar que estaba inscrito en la materia?????
        //validar existeCoincidenciaCarreraEstudiante(estudiante) y estudiante.tieneAprobadosRequisitos(materia)
        estudiante.validarNoEstaAprobada(materia)
        self.validarNotaAprobatoria(nota)
        const materiaAprobada = new Aprobacion (estudiante = estudiante, materia = materia, nota = nota)
        estudiante.materiasAprobadas().add(materiaAprobada)
        estudiante.sumarCantMateriasAprobadas()
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

}

/*1. Determinar si un estudiante puede inscribirse a una materia. Para esto se deben cumplir cuatro condiciones: 
    - la materia debe corresponder a alguna de las carreras que esté cursando el estudiante, 
    - el estudiante no puede haber aprobado la materia previamente, 
    - el estudiante no debe estar estar ya inscripto en esa materia,
    - el estudiante debe tener aprobadas todas las materias que se declaran como _requisitos_ de la materia a la que se quiere inscribir.  
    P.ej., para que un estudiante pueda inscribirse a Objetos 2, es necesario tener aprobadas Objetos 1 y Matemática 1.
*/