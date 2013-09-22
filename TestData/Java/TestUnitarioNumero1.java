package ar.com.stomalab.metricastesis.tests;

import org.junit.Test;

/* Modificando comentario largo de una linea */
public class TestUnitarioNumero1{
    @Test
    public void testSimple(){
        int a = 1;
        /*
         * Comentario largo de
         * varias lineas
         */
        assertEquals(a, 1);
    }

    @Test
    public void testSimple2(){
        /*
         Modificando comentario largo de varias liena

         */
        int a = 2;
        assertEquals(a, 2);
    }

    @Test
    public void testSimple3(){
        int b = 3;
        assertEquals(b, 3);
    }

    @Test
    public void testSimple4(){
        /* Modificando comentario largo
         que tiene // dos barras
         y una apertura nueva /* que
         no hace nada
                        */
        int a = 1;
        int b = 2 - 1;
        assertEquals(a, b); /* Modificando Comentario largo al final de una linea */  
    }

    @Test
    public void testSimple5(){
        int a = 1;
        assertEquals(a, 1); /* Modificando Comentario largo al final de una linea 
                               que sigue por varias lineas */
    }

}
