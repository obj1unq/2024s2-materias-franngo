import aprobacion.*
import carrera.*
import gestores.*
import materia.*

class Estudiante {
    const property carrerasCursando = #{} //set de instancias de Carrera
    const property materiasAprobadas = #{} //set de instancias de Aprobacion

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

    /*
    method cumplePrerrequisitos(materia) {
        return materia.prerrequisitos().all({prerreq => self.tieneAprobada(prerreq)}) //si no hay prerreq, devuelve true
    }
    */

    method estaCursandoOEnEspera(materia) {
        return self.estaEfectivamenteCursando(materia) || self.estaEnListaDeEspera(materia)
    }

    method inscribirseA(materia) {
        gestorInscripcion.inscribirEstudianteEn(self, materia)
    }

    method validarEstaEfectivamenteInscrito(materia) {
        if(!self.estaEfectivamenteCursando(materia)) {
            self.error("No se puede registrar la nota porque el estudiante no está cursando como tal esta materia")
        }
    }

    method estaEfectivamenteCursando(materia) {
        return materia.alumnosCursando().any({alumno => alumno==self})
    }

    method materiasEfectivamenteCursando() {
        return self.todasLasMateriasDeSusCarreras().filter({materia => self.estaEfectivamenteCursando(materia)})
    }

    method estaEnListaDeEspera(materia) {
        return materia.listaDeEspera().any({alumno => alumno==self})
    }

    method materiasEnListaDeEspera() {
        return self.todasLasMateriasDeSusCarreras().filter({materia => self.estaEnListaDeEspera(materia)})
    }

    method darseDeBajaEn(materia) {
        gestorInscripcion.darDeBajaEstudianteEn(self, materia)
    }

    method materiasCursablesDeCarrera(carrera) {
        return carrera.materias().filter({materia => self.puedeInscribirseA(materia)})
    }

    method totalDeCreditosDeCarrera(carrera) {
        const materiasContabilizables = materiasAprobadas.filter({instanciaAprob => instanciaAprob.materia().carrera()==carrera})
        return materiasContabilizables.sum({instanciaAprobacion => instanciaAprobacion.materia().creditosQueOtorga()})
    }

}