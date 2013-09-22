package ar.com.stomalab.metricastesis.tests;

import org.junit.Test;

public class TestUnitarioNumero1{
    @Test
    public void testSimple(){
        double a = 1;
        String cadena = "modifico prueba cadena";
        assertEquals(a, 1);
    }

    @Test
    public void testSimple2(){
        int c = 4;
        String cadena = "prueba cadena";
        assertEquals(c, 2);
    }

    @Test
    public void testSimple3(){
        int b = 3;
        String cadena4 = "modifico prueba cadena";
        String cadena5 = "modifico prueba cadena";
        assertEquals(b, 3);
    }

    @Test
    public void testSimple4(){
        int a = 1;
        int b = 2 - 1;
        assertEquals(a, b);
    }

    @Test
    public void testSimple6(){
        int a = 1;
        assertEquals(a, 1);
    }
}
