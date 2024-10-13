import aprobacion.*
import carrera.*
import estudiante.*
import gestores.*

class Materia {
    const property carrera = null
    const property maximoEstudiantes = 2
    const property alumnosCursando = #{}
    const property listaDeEspera = [] //queue (es lista porque nos interesa el orden)
    var property tipoPrerrequisitos = correlativas
    //atributos relativos a prerrequisitos
    const property materiasCorrelativas = #{}
    const property creditosQueOtorga = 40
    const property creditosRequeridos = 200
    const property anhoMateria = 2
    const property anhoDeLasDePrerrequisitos = 1
    var property tipoListaDeEspera = porOrdenDeLlegada

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
    //cambiaría solo el como organizamos a los que se mandan a la lista de espera. tendría que quedar adelante el de mayor prioridad!
    //así va a seguir funcionando todo lo otro como liberarCupoDe()

    method liberarCupoDe(estudiante) {
        alumnosCursando.remove(estudiante)
        tipoListaDeEspera.otorgarCupoSiCorrespondeEn(self)
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

    //solo se contabilizan los créditos que otorgan las materias de la misma carrera que la de la materia en cuestión.
    method cumplePrerrequisitosEstudiantePara(estudiante, materia) {
        return estudiante.totalDeCreditosDeCarrera(materia.carrera()) >= materia.creditosRequeridos()
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

//tipos de lista de espera

object porOrdenDeLlegada {

    method otorgarCupoSiCorrespondeEn(materia) {
        if(materia.alumnosCursando().size()==materia.maximoEstudiantes()-1 && materia.listaDeEspera().size()>0) {
            materia.alumnosCursando().add(materia.listaDeEspera().head()) //inscribe efectivamente al que llevaba más tiempo esperando
            materia.listaDeEspera().remove(materia.listaDeEspera().head()) //lo borra de la lista de espera
        }
    }

}

object elitista {

    method otorgarCupoSiCorrespondeEn(materia) {
        if(materia.alumnosCursando().size()==materia.maximoEstudiantes()-1 && materia.listaDeEspera().size()>0) {
            const alumnoPrioritario = materia.listaDeEspera().max({alumno => alumno.promedio()}) 
            materia.alumnosCursando().add(alumnoPrioritario) //inscribe efectivamente al de mayor promedio
            materia.listaDeEspera().remove(alumnoPrioritario) //lo borra de la lista de espera
        }
        
    }

}

object porGradoDeAvance {

    method otorgarCupoSiCorrespondeEn(materia) {
        if(materia.alumnosCursando().size()==materia.maximoEstudiantes()-1 && materia.listaDeEspera().size()>0) {
            const alumnoPrioritario = materia.listaDeEspera().max({alumno => alumno.materiasAprobadasDeCarrera(materia.carrera()).size()}) 
            materia.alumnosCursando().add(alumnoPrioritario) //inscribe efectivamente al que tiene más materias de la carrera aprobadas
            materia.listaDeEspera().remove(alumnoPrioritario) //lo borra de la lista de espera
        }
    }

}
