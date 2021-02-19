NR > 2{ 
        if ($3 > maxSalario[$2]){
          maxSalario[$2] = $3;
	  maxProfessor[$2] = $1;
       	}
}
END {
	for (curso in maxSalario)
	   printf "Professor: %s, Curso: %s,  Salário: %d\n", maxProfessor[curso], curso, maxSalario[curso]
}
