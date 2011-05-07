/*
 Consuela WebServer

 A simple webserver displaying the status and controlling the relays on consuela relay shield.
 
 Circuit:
 * Ethernet shield attached to pins 10, 11, 12, 13
 * Consuela shield attached to pins <to be added>
 * Analog inputs attached to pins A0 through A5 (optional)
 
 created 7th May 2011 
 */

#include <SPI.h>
#include <Ethernet.h>
//#include <WString.h>


int th_value;
int tempC;
int magnet;
int tempPin = 4;
int tempPin2 = 5;
int sensorValue;

// Enter a MAC address and IP address for your controller below.
// The IP address will be dependent on your local network:
byte mac[] = { 
  0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
byte ip[] = { 
  192,168,1, 6 };



int i=0;

char readString[21];


// Initialize the Ethernet server library
// with the IP address and port you want to use 
// (port 80 is default for HTTP):
Server server(80);

void setup()
{
  // start the Ethernet connection and the server:
  Ethernet.begin(mac, ip);
  server.begin();
  pinMode(6, OUTPUT);
  Serial.begin(9600);

}

void loop()
{ 
  magnet = analogRead(tempPin2);


  // listen for incoming clients
  Client client = server.available();
  if (client) {
    // an http request ends with a blank line
    while (client.connected()) {
      if (client.available()) {
        char c = client.read();
        // if you've gotten to the end of the line (received a newline
        // character) and the line is blank, the http request has ended,
        // so you can send a reply
        if (c == '\n' ) {
          tempC = analogRead(tempPin);           //read the value from the sensor
          th_value = (5 * tempC * 100)/1024;  //convert the analog data to temperature
          // send a standard http response header



          client.println("HTTP/1.1 200 OK");
          client.println("Content-Type: text/html");
          client.println();
          //client.println(readString[17]);
          //client.println(readString[18]);

          if ('T'==readString[17] && 'H'==readString[18]){
            client.println(th_value);
            //client.println(readString.substring(17,19));       
          }
          else{

            char * html = "<!DOCTYPE html><html><head><title>HTML Elements</title>";
            char * html_start = "</head><body>";
            char * RG_s1 = "<script src=\"http://animal.foss.ntua.gr/~nemo_ntua/arduino/RGraph.common.core.js\" ></script>";
            char * RG_s2 = "<script src=\"http://animal.foss.ntua.gr/~nemo_ntua/arduino/RGraph.common.context.js\" ></script>";
            char * RG_s3 = "<script src=\"http://animal.foss.ntua.gr/~nemo_ntua/arduino/RGraph.common.annotate.js\" ></script>";
            char * RG_s4 = "<script src=\"http://animal.foss.ntua.gr/~nemo_ntua/arduino/RGraph.common.tooltips.js\" ></script>";
            char * RG_s5 = "<script src=\"http://animal.foss.ntua.gr/~nemo_ntua/arduino/RGraph.common.zoom.js\" ></script>";
            char * RG_s6 = "<script src=\"http://animal.foss.ntua.gr/~nemo_ntua/arduino/RGraph.thermometer.js\" ></script>";
            char * html_end = "</body ></html>";
            char * form = "<form name=\"input\" action=\"myForm\" method=\"get\">";
            char * form1 = "<input type=\"radio\" name=\"turn\" value=\"ON\" /> ON<br/>";
            char * form2 = "<input type=\"radio\" name=\"turn\" value=\"OFF\" /> OFF<br/>";
            char * form3 = "<input type=\"submit\" value=\"Submit\"></form> ";
            char * canvas = "<canvas id=\"thermo1\" width=\"100\" height=\"350\">[No canvas support]</canvas><div id=\"test\"></div>";
            char * th_s0 = "<script>window.onload = function (){";
            char * th_s1 = "var thermometer = new RGraph.Thermometer('thermo1', 0,100,";
            char * th_s2 = ");";
            char * th_s3 = "thermometer.Set('chart.colors', ['green']);";
            char * th_s4 = "thermometer.Set('chart.title.side', 'This servers load');";
            char * th_s5 = "thermometer.Draw();";
            char * update = "function update (){var xmlHttp=new XMLHttpRequest();xmlHttp.open(\"GET\",\"myForm?turn=TH\",false);xmlHttp.send(); document.getElementById('test').innerHTML = parseInt(xmlHttp.responseText);}";
            char * update2 = "RGraph.Clear(document.getElementById(\"thermo1\"));var thermometer = new RGraph.Thermometer('thermo1', 0,100, 50);thermometer.Set('chart.colors', ['red']);thermometer.Draw()};";
            char * interval = "setInterval(update, 5000);";
            char * th_s6 = "}    </script>";   

            client.println(html);
            client.println(RG_s1);
            client.println(RG_s2);
            client.println(RG_s3);
            client.println(RG_s4);
            client.println(RG_s5);
            delay(100);
            client.println(RG_s6);
            client.println(html_start);
            client.println(form);

            if (i>19){
              //client.print(i);
              //client.print(readString[17]);
              if ('O'==readString[17] && 'N'==readString[18]){
                digitalWrite(6, HIGH);
                delay(150);
                //client.println(readString.substring(17,19));       
              }
              else if ('O'==readString[17] && 'F'==readString[18] && 'F'==readString[18]){
                digitalWrite(6, LOW);
                delay(150);
                //client.println(readString.substring(17,20));
              }
            }
            sensorValue = analogRead(A5);
            Serial.println(sensorValue);
            //if (sensorValue <= 900){
            client.println(form1);
            //}
            //else{
            client.println(form2);
            //}
            client.println(form3);
            //client.println(readString);
            client.println("<br /><br />");
            client.println(canvas);
            client.println(th_s0);
            client.println(th_s1);
            client.println(th_value);
            client.println(th_s2);
            client.println(th_s3);
            client.println(th_s4);
            client.println(th_s5);
            client.println(update);
            client.println(update2);
            client.println(interval);
            client.println(th_s6);
            client.print("<br />");
            delay(10);
            //client.println(ON==readString.substring(17,19));
            //client.println(OFF==readString.substring(17,20));
            client.print("<br />Temperature: ");
            client.print(th_value);
            client.print("<br />Magnet: ");
            client.print(magnet);
            client.println(html_end);
          }
          i=0;
          readString[17]='R';
          readString[18]='E';
          readString[19]='S';
          break;
        }
        else if (c != '\r') {
          // you've gotten a character on the current line

          if (i<20){
            readString[i]=c;
            i=i+1;
          }
          //client.println();}
          //client.print(c);
          //client.println();
        }

      }

    }
    // give the web browser time to receive the data
    //delay(1);
    // close the connection:
    client.stop();
  }
}

