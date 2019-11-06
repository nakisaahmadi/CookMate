package edu.ucsd.cs110.temperature;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class TemperatureConverter {

    public static void main(String args[]) throws IOException
    {
        String input = null;
        Temperature inputTemp = null, outputTemp = null;
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));

        while(true)
        {
            System.out.println("\nAvailable units: C, F");

            System.out.print("Enter temperature to convert (i.e. 36.8 C, 451 F): ");
            if((input = reader.readLine()) == null) System.exit(0);
            String[] temp_in = input.split(" ");
            float temp_val = Float.parseFloat(temp_in[0]);

            switch(temp_in[1].toLowerCase().charAt(0))
            {
                case 'c':
                    inputTemp = new Celsius(temp_val);
                    break;
                case 'f':
                    inputTemp = new Fahrenheit(temp_val);
                    break;
                default:
                    System.out.println("Invalid entry!!\n\n");
                    continue;
            }

            System.out.print("Enter the unit to convert TO: ");
            if((input = reader.readLine()) == null) System.exit(0);

            switch(input.toLowerCase().charAt(0))
            {
                case 'c':
                    outputTemp = inputTemp.toCelsius();
                    break;
                case 'f':
                    outputTemp = inputTemp.toFahrenheit();
                    break;
                default:
                    System.out.println("Invalid entry!!\n\n");
                    continue;
            }

            System.out.println("\n The converted temperature is " + outputTemp.toString() +"\n\n");
        }
    }
}