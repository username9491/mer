#define DELKA_NAZVU 15

#include <stdlib.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>


typedef struct {
	char nazev[DELKA_NAZVU];
	float cena;
	int mnozstvi;
} produkt;



produkt* nactiProdukty(char* fileName, int* numOfProducts) {
	FILE* file = fopen(fileName, "r");

	*numOfProducts = 0;
	
	if (file == NULL) {
		printf("Error while reading file\n");
		return NULL;
	}

	char currentLine[DELKA_NAZVU];
	

	while (fgets(currentLine, DELKA_NAZVU, file) != NULL) {
		(*numOfProducts)++;
	}
	
	rewind(file);

	produkt* produkty = (produkt*) malloc(*numOfProducts * sizeof(produkt));

	int currentIndex = 0;

	while (fgets(currentLine, DELKA_NAZVU, file) != NULL) {
		strcpy(produkty[currentIndex].nazev, currentLine);
		float cenaGen = (double)((double)rand() / (double)(RAND_MAX / 390)) + 10.0;
		int mnozstviGen = ((int)rand() / (int)(RAND_MAX / 150));

		produkty[currentIndex].cena = cenaGen;
		produkty[currentIndex++].mnozstvi = mnozstviGen;
	}

	fclose(file);

	return produkty;
}

produkt* podPrumerCena(produkt* oldArray, int* numOfProducts) {
	
	float prumerCena = 0;

	for (int i = 0; i < *numOfProducts; i++) {
		prumerCena += oldArray[i].cena;
	}

	prumerCena /= *numOfProducts;
	printf("Prumerna cena: %f\n", prumerCena);

	produkt* noveProdukty = (produkt*)malloc(*numOfProducts * sizeof(produkt));

	for (int i = 0; i < *numOfProducts; i++) {
		noveProdukty[i].cena = 0;
	}

	for (int i = 0, j = 0; i < *numOfProducts; i++) {
		float currentCena = oldArray[i].cena;
		if (currentCena < prumerCena) {
			noveProdukty[j].cena = oldArray[i].cena;
			noveProdukty[j].mnozstvi = oldArray[i].mnozstvi;
			strcpy(noveProdukty[j++].nazev, oldArray[i].nazev);
		}
	}

	return noveProdukty;
}

void vypisProdukty(produkt* produkty, int* numOfProducts) {

	for (int i = 0; i < *numOfProducts; i++) {
		if (produkty[i].cena == 0) {
			break;
		}
		printf("Nazev: %s", produkty[i].nazev);
		printf("Cena: %f \n", produkty[i].cena);
		printf("Mnozstvi: %d\n\n", produkty[i].mnozstvi);
	}
}

int main() {

	int numOfProducts = 0;

	char* fileName = "data.txt";

	produkt* originalProdukty = nactiProdukty(fileName, &numOfProducts);

	vypisProdukty(originalProdukty, &numOfProducts);

	produkt* podPrumerProdukty = podPrumerCena(originalProdukty, &numOfProducts);

	vypisProdukty(podPrumerProdukty, &numOfProducts);

	return 0;
}
