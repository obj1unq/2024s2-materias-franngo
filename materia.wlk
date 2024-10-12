import aprobacion.*
import carrera.*
import estudiante.*
import gestores.*

class Materia {
    const property carrera = null
    const property maximoEstudiantes = 2
    const property alumnosCursando = #{}
    const property listaDeEspera = [] //queue (es lista porque nos interesa el orden)
    const property tipoPrerrequisitos = correlativas
    //atributos relativos a prerrequisitos
    const property materiasCorrelativas = #{}
    const property creditosQueOtorga = 40
    const property creditosRequeridos = 200
    const property anhoMateria = 2
    const property anhoDeLasDePrerrequisitos = 1

    method existeCoincidenciaCarreraEstudiante(estudiante) {
        return estudiante.carrerasCursando().any({carreraEst => carreraEst==carrera})
    }

    method inscribirEstudiante(estudiante) {
        if(alumnosCursando.size() < maximoEstudiantes) {
            alumnosCursando.add(estudiante)
        } else {
            listaDeEspera.add(estudiante)
        }
    }

    method liberarCupoDe(estudiante) {
        alumnosCursando.remove(estudiante)
        if(alumnosCursando.size()==maximoEstudiantes-1 && listaDeEspera.size()>0) {
            alumnosCursando.add(listaDeEspera.head()) //inscribe efectivamente al que llevaba más tiempo esperando
            listaDeEspera.remove(listaDeEspera.head()) //lo borra de la lista de espera
        }
    }

    method cumplePrerrequisitosEstudiante(estudiante) {
        return tipoPrerrequisitos.cumplePrerrequisitosEstudiantePara(estudiante, self)
    }

    method materiasPrerrequisitoPorAnho() {
        return carrera.materiasDeAnho(anhoDeLasDePrerrequisitos)
    }

}

//tipos de prerrequisitos

object correlativas {

    method cumplePrerrequisitosEstudiantePara(estudiante, materia) {
        return materia.materiasCorrelativas().all({correlat => estudiante.tieneAprobada(correlat)}) //si no hay correlat, devuelve true
    }

}

object creditos {

    method cumplePrerrequisitosEstudiantePara(estudiante, materia) {
        return estudiante.totalDeCreditos() >= materia.creditosRequeridos()
    }

}

object porAnho {

    method cumplePrerrequisitosEstudiantePara(estudiante, materia) {
        return materia.materiasPrerrequisitoPorAnho().all({materia => estudiante.tieneAprobada(materia)})
    }

}

object sinPrerrequisitos {

    method cumplePrerrequisitosEstudiantePara(estudiante, materia) {
        return true    
    }

}