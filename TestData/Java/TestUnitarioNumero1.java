package ar.com.stomalab.metricastesis.tests;

import org.junit.Test;

public class TestUnitarioNumero1{
    @Test
    public void testSimple(){
        int a = 1;
        String cadena = "prueba cadena";
        assertEquals(a, 1);
    }

    @Test
    public void testSimple2(){
        int a = 2;
        int b = 3;
        String cadena = "prueba cadena";
        assertEquals(a, 2);
    }

    @Test
    public void testSimple3(){
        int b = 3;
        String cadena1 = "prueba cadena";
        String cadena2 = "prueba cadena";
        String cadena3 = "prueba cadena";
        assertEquals(b, 3);
    }

    @Test
    public void testSimple4(){
        int a = 1;
        int b = 2 - 1;
        assertEquals(a, b);
    }

    @Test
    public void testSimple5(){
        int a = 1;
        assertEquals(a, 1); 
    }

}
