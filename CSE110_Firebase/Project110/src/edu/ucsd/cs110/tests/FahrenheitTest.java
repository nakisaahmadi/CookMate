package edu.ucsd.cs110.tests;
import edu.ucsd.cs110.temperature.Fahrenheit;
import edu.ucsd.cs110.temperature.Temperature;
import junit.framework.TestCase;

public class FahrenheitTest extends TestCase{
    private float delta = 0.001f;

    public void testFahrenheit(){
        float value = 12.34f;
        Fahrenheit temp = new Fahrenheit(value);

        assertEquals(value, temp.getValue(), delta);
    }

    public void testFahrenheitToString(){
        float value = 12.34f;

        Fahrenheit temp = new Fahrenheit(value);
        String string = temp.toString();

        String beginning = "" + value;
        String ending = " F";

        // Verify the suffix of the formatted string
        assertTrue(string.startsWith(beginning));

        // Verify the prefix of the formatted string
        assertTrue(string.endsWith(ending));

        // Verify the middle of the formatted string
        int endIndex = string.indexOf(ending);

        // (Hint: what is the length of the middle of the string?)
        assertTrue(string.substring(0, endIndex).equals(beginning));
    }

    public void testFahrenheitToFahrenheit()
    {
        Fahrenheit temp = new Fahrenheit(32);

        Temperature convert = temp.toFahrenheit();
        assertEquals(32, convert.getValue(), delta);
    }

    public void testFahrenheitToCelsius(){
        Fahrenheit temp = new Fahrenheit(32);

        Temperature convert = temp.toCelsius();
        assertEquals(0, convert.getValue(), delta);

        temp = new Fahrenheit(212);
        convert = temp.toCelsius();

        assertEquals(100, convert.getValue(), delta);
    }
}