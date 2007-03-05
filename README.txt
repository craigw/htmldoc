= PDF::HTMLDoc

PDF::HTMLDoc is a wrapper around HTMLDOC, an open-source application
that converts HTML input files into formatted HTML, PDF or PostScript
output.

Home:: http://rubyforge.org/projects/pdf-htmldoc/
HTMLDOC Home: http://www.htmldoc.org/
Copyright:: 2007, Ronaldo M. Ferraz

This is a preview release, which means it had only limited testing. As
far as it's know, it will work on all platforms in which HTMLDOC is
available. Comments, suggestions, and further tests are welcome.

== LICENSE NOTES

Please read the LICENCE.txt file for licensing information on this
library.

== USAGE

Using PDF::HTMLDoc is trivial. The example below illustrates a simple
use with an output file:

  require "htmldoc"

  pdf = PDF::HTMLDoc.new

  pdf.set_option :outfile, "/tmp/outfile.pdf"
  pdf.set_option :bodycolor, :black
  pdf.set_option :links, true

  pdf.header ".t."

  pdf << "/var/doc/file1.html"
  pdf << "/var/doc/file2.html"

  pdf.footer ".1."

  if pdf.generate 
    puts "Successfully generated a PDF file"
  end
   
A similar approach can be used for inline generation:

  require "htmldoc"

  document = PDF::HTMLDoc.create(PDF::PS) do |p|

    p.set_option :bodycolor, :black
    p.set_option :links, true

    p.header ".t."

    p << "http://example.org/index.html"
    p << "http://localhost/test/data"

    p << "/var/doc/file1.html"
    p << "/var/doc/file2.html"

    p << @report.to_html
    p << "Some other text that will be incorporated to the report"

    p.footer ".1."

  end

In the example above, it's not necessary to call the <tt>generate</tt>
method since it will be automatically invoked by the block.

You can also configure the program path for HTMLDOC if it differs in
your system.

  require "htmldoc"

  PDF::HTMLDoc.program_path = "\"C:\Program Files\HTMLDOC\ghtmldoc.exe\""

See the notes below for usage considerations.

== NOTES

* PDF::HTMLDoc is both a Rails plugin and a gem, which means it can be
  installed system-wide, or just used on a Rails project without
  further dependencies.

* Under Windows, it's better to point the program path for the HTMLDOC
  executable to the GUI vesion. It will avoid a DOS command window from
  popping-up in your application,

* Keep in mind that HTMLDOC is not fast over large documents. If you
  need to generate very large documents, you be better off spawning an
  additional thread if your are in a traditional application or
  farming off the generation for a background deamon that will
  communicate with your application using some RPC
  mechanism. BackgrounDRb[http://backgroundrb.rubyforge.org] is a good
  choice for that.
