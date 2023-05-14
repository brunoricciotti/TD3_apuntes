#include <stdbool.h>
int enviarAPantalla(char *cadena);

int cuadrado(int valor)
{
  char cadena[20];
  char *ptrCadena = cadena;
  int cuadrado = valor * valor;
  bool ceroSignificativo = false;
  for (int divisor = 1000000000; divisor >= 10; divisor /= 10)
  {
    int digito = cuadrado / divisor;
    if (digito != 0 || ceroSignificativo)
    {
      *ptrCadena++ = digito + '0';
      ceroSignificativo = true;
    }
    cuadrado %= divisor;
  }
  *ptrCadena++ = cuadrado + '0';
  *ptrCadena = 0;
  return enviarAPantalla(cadena);
}

