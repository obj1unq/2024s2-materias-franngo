class Estudiante {
    const property carrerasCursando = []
    const property materiasAprobadas = #{} //lista de instancias de Aprobacion

    method registrarMateriaAprobada(materia, nota) {
        gestorAprobacion.registrarMateriaAprobada(self, materia, nota)
    }

}

object gestorAprobacion {

    method registrarMateriaAprobada(estudiante, materia, nota) {
        const materiaAprobada = new Aprobacion (estudiante = self, materia = materia, nota = nota)
        materiasAprobadas.add(materiaAprobada)
    }

}

class Materia {
    const carrera = null
}

class Aprobacion {
    const estudiante = null
    const materia = null
    const nota = null
}

class Carrera{
    const property materias = []
}

class Universidad {

}