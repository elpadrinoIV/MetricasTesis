package ar.com.stomalab.metricastesis.tests;

import org.junit.Test;

/* Comentario largo de una linea */
public class TestUnitarioNumero1{
    @Test
    public void testSimple(){
        // Modificando comentario de una linea
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
         Comentario largo de varias liena





         */
        int a = 2; // Modificando comentario de una linea al final
        assertEquals(a, 2);
    }
// Modificando comentario al principio
    @Test
    public void testSimple3(){
        int b = 3;
        assertEquals(b, 3);
    }

    @Test
    public void testSimple4(){
        /* 
         Comentario largo
         que tiene // dos barras
         y una apertura nueva /* que
         no hace nada
                        */
        int a = 1;
        int b = 2 - 1;
        assertEquals(a, b); /* Comentario largo al final de una linea */  
    }

    @Test
    public void testSimple5(){
        int a = 1;
        assertEquals(a, 1); /* Comentario largo al final de una linea 
                               que sigue por
                               varias lineas
                               */
    }

}
