#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define ADD 0
#define MUL 1
#define SUB 2
#define DIV 3

#define MOV 4

#define SET 5
#define GET 6

#define PRT 7
#define RED 8
#define JMZ 9

#define DAT 10

void print_system(char *command) {
	system(command);
}

void execute(long int instructions[][3], int sz) {
	long int data[128];
	int ip = 0;
	while (ip >= 0 && ip < sz) {
		//printf("exec: %d %02lx %016lx %016lx\n", ip, instructions[ip][0], instructions[ip][1], instructions[ip][2]);
		if (instructions[ip][0] == ADD) {
			data[instructions[ip][1]] += data[instructions[ip][2]];
			ip++;
		} else if (instructions[ip][0] == MUL) {
			data[instructions[ip][1]] *= data[instructions[ip][2]];
			ip++;
		} else if (instructions[ip][0] == SUB) {
			data[instructions[ip][1]] -= data[instructions[ip][2]];
			ip++;
		} else if (instructions[ip][0] == DIV) {
			data[instructions[ip][1]] /= data[instructions[ip][2]];
			ip++;
		} else if (instructions[ip][0] == MOV) {
			data[instructions[ip][1]] = instructions[ip][2];
			ip++;
		} else if (instructions[ip][0] == GET) {
			data[instructions[ip][1]] = data[data[instructions[ip][2]]];
			ip++;
		} else if (instructions[ip][0] == SET) {
			data[data[instructions[ip][1]]] = data[instructions[ip][2]];
			ip++;
		} else if (instructions[ip][0] == PRT) {
			printf("@%02lx: %016lx\n", instructions[ip][1], data[instructions[ip][1]]);
			ip++;
		} else if (instructions[ip][0] == RED) {
			scanf("%ld", &data[instructions[ip][1]]);
			ip++;
		} else if (instructions[ip][0] == DAT) {
			print_system("/bin/date");
			ip++;
		} else if (instructions[ip][0] == JMZ) {
			if (data[instructions[ip][1]]) {
				ip++;
			} else {
				ip = instructions[ip][2];
			}
		}
	}
}

int main(int argc, char **argv) {
	long int instructions[256][3];
	char line[128];
	if (argc != 2) {
		fprintf(stderr, "usage: %s file\n", argv[0]);
		exit(1);
	}
	FILE *f = fopen(argv[1], "r");
	if (f == NULL) {
		fprintf(stderr, "invalid file\n");
		exit(1);
	}
	/* Lecture de tout le fichier. */
	int ip = 0;
	while (!feof(f) && ip < 256) {
		if (fgets(line, sizeof(line) - 1, f) == NULL) {
			break;
		}
		if (line[0] != '#') {
			//printf("read: %s\n", line);
			sscanf(line, "%ld %ld %ld", &instructions[ip][0], &instructions[ip][1], &instructions[ip][2]);
			ip++;
		}
	}

	execute(instructions, ip);

	return 0;
}
