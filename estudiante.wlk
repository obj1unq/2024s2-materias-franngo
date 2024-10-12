import aprobacion.*
import carrera.*
import gestores.*
import materia.*

class Estudiante {
    const property carrerasCursando = #{} //set de instancias de Carrera
    const property materiasAprobadas = #{} //set de instancias de Aprobacion
    //const property materiasCursando = #{} //set de instancias de Materia

    method registrarMateriaAprobada(materia, nota) {
        gestorAprobacion.registrarMateriaAprobada(self, materia, nota)
    }

    method validarNoEstaAprobada(materia) {
        if(self.tieneAprobada(materia)) {
            self.error("No se puede registrar la nota porque el estudiante ya aprobó la materia")
        }
    }

    method tieneAprobada(materia) {
        return materiasAprobadas.any({instanciaAprobacion => instanciaAprobacion.materia()==materia})
    }

    method cantMateriasAprobadas() {
        return materiasAprobadas.size()
    }

    method promedio() {
        const sumaNotas = materiasAprobadas.sum({instanciaAprobacion => instanciaAprobacion.nota()})
        return sumaNotas / self.cantMateriasAprobadas()
    }

    method todasLasMateriasDeSusCarreras() {
        const materias = #{}
        carrerasCursando.forEach({carrera => materias.addAll(carrera.materias())})
        return materias
    }

    //puede ejecutar inscribirseA(materia) exitosamente
    method puedeInscribirseA(materia) {
        return gestorInscripcion.puedeInscribirseA(self, materia)
    }

    method estaCursandoOEnEspera(materia) {
        //return materiasCursando.any({materiaCurs => materiaCurs==materia})
        return materia.alumnosCursando().any({alumno => alumno==self})
        || materia.listaDeEspera().any({alumno => alumno==self})
    }

    method tieneAprobadosRequisitos(materia) {
        return materia.prerrequisitos().all({prerreq => self.tieneAprobada(prerreq)}) //si no hay prerreq, devuelve true
    }

    method inscribirseA(materia) {
        gestorInscripcion.inscribirEstudianteEn(self, materia)
    }

    method validarEstaInscrito(materia) {
        if(!self.estaCursandoOEnEspera(materia)) {
            self.error("No se puede registrar la nota porque el estudiante no está cursando esta materia")
        }
    }

    //HACER: materias cursando y materias en lista de espera

    /*
    1. Inscribir un estudiante a una materia, verificando las condiciones de inscripción de la materia. Si no se cumplen las 
    condiciones, lanzar un error.  
    Además, cada materia tiene un “cupo”, es decir, una cantidad máxima de estudiantes que se pueden inscribir. Para manejar el exceso
    en los cupos, las materias tienen una lista de espera, de estudiantes que quisieran cursar pero no tienen lugar 
    (ver punto 5).
    O sea, como resultado de la inscripción, el estudiante puede, o bien quedar confirmado, o bien quedar en lista de espera.  
    No se requiere que el sistema conteste nada con respecto al resultado de la inscripción. 
    */

}