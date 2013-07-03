# Restful Printing
---------------

This is a small webservice that layers a light REST interface over the Cups printing system.

My purpose in writing this is was because I needed a way to print barcode
labels from LedgerBuddy.

To do so is typically fairly
simple and involves sending plain text which conforms to the ZPLII printing language directly to the printer port.

The problem arose when I needed to do so from a web application.
Since browsers (understandably) don't support ZPL, they don't know
what to do with it, and there's not a javascript api for native
printing (thankfully, that would be a mess).

To use this, you'll need to

 * Setup a ZPL compatible (Tested with Zebra S4m) printer using a the raw (textonly) Cups driver on a local server.
 * Install Restful Printing service on the server.
   * At the moment there's no fancy installer and such, just:
   * For Ubuntu you'll need the following:
     * ``` sudo apt-get install build-essential checkinstall ruby1.9.1 ruby1.9.1-dev libcups2-dev libcurl4-openssl-dev```
   * Checkout the source from github and run ```bundle install```
   * Point your favorite rack webserver at the directory.  Tested with Puma and Passenger, but anything *should* work.
 * Send ZPL formatted text such as:
 ```
 ^XA
 ^LH30,30
 ^F020,10^AD^FDZEBRA^FS
 ^F020,60,B3^FDAAAAA01^FS
 ^X2
 ```


The endpoints currently defined are:
 * All available printers:
   * GET /printers(.:format)

 * All jobs for printer :name:
   * GET /printers/:name/jobs(.:format)

 * Create new print job for printer :name.  Must have either a :url, or :data parameter specified:
   * POST /printers/:name/jobs(.:format)

 * return data associated with a job (currently only it's status is reported):
   * GET /printers/:name/jobs/:job_id(.:format)


The listing is also printed to STDOUT when the server is started up.
