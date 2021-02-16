BEGIN {{print "Aluno:Situação:Média"}}

{
	if (NR > 1) {
		soma=($2+$3+$4+$5)
		media=soma/4
		aluno[$1]=media

		nota1 += $2
		nota2 += $3
		nota3 += $4
		nota4 += $5
	}
}

END {
	for (i in aluno) {
		if (aluno[i] >= 7) {
			print i ":Aprovado:" aluno[i]
		}
		else if (aluno[i] >= 4 && aluno[i] < 7) {
			print i ":Final:" aluno[i]
		}
		else {
			print i ":Reprovado:" aluno[i]
		}

	}
print "Média das provas: "nota1/(NR-1)" "nota2/(NR -1)" "nota3/(NR -1)" "nota4/(NR-1)" " 
}
