require File.dirname(__FILE__) + '/test_helper.rb'

class GenerationTest < Test::Unit::TestCase

  def setup
    # If you are using a different program path, you should configure
    # it here.
    @program_path = PDF::HTMLDoc.program_path
  end

  def test_program_path
    data = IO.popen(@program_path + " --version 2>&1") { |s| s.read }
    assert_equal 0, $?.exitstatus
    assert_match(/^1.((8.2\d)|9-current)/, data)
  end

  def test_generation
    # Those tests are not exhaustive, but will ensure a reasonable
    # level of functionality. Output to directories is not tested for
    # now.
    basic_test(PDF::HTML)
    basic_test(PDF::PS)
    basic_test(PDF::PDF)
  end

  private

  def basic_test(format)
    path1, path2 = (1..2).collect { |i| Dir.tmpdir + "/#{i}.#{format}" }
    Tempfile.open("htmldoc.test") do |tempfile|
      page = "<h1>Page 1</h1><p>Test.</p><h1>Page 2</h1><p>Test.</p>"
      tempfile.binmode
      tempfile.write(page)
      tempfile.flush
      begin
        pdf = PDF::HTMLDoc.new(format)
        pdf.set_option :outfile, path1
        pdf.add_page tempfile.path
        assert_equal true, pdf.generate
        assert_equal pdf.result, execute_htmldoc(path2, tempfile.path, "--format #{format}")
      ensure
        File.delete(path1)
        File.delete(path2)
      end
      begin
        pdf = PDF::HTMLDoc.new(format)
        pdf.set_option :outfile, path1
        pdf.set_option :webpage, true
        pdf.add_page tempfile.path
        assert_equal true, pdf.generate
        assert_equal pdf.result, execute_htmldoc(path2, tempfile.path, "--webpage --format #{format}")
      ensure
        File.delete(path1)
        File.delete(path2)
      end
      begin
        pdf = PDF::HTMLDoc.new(format)
        pdf.set_option :outfile, path1
        pdf.set_option :bodycolor, :black
        pdf.add_page tempfile.path
        assert_equal true, pdf.generate
        assert_equal pdf.result, execute_htmldoc(path2, tempfile.path, "--bodycolor black --format #{format}")
      ensure
        File.delete(path1)
        File.delete(path2)
      end
      begin
        pdf = PDF::HTMLDoc.new(format)
        pdf.add_page page
        pdf.generate
        assert_equal pdf.result, execute_htmldoc(path2, tempfile.path, "--format #{format}")
      ensure
        File.delete(path2)
      end
      begin
        result = PDF::HTMLDoc.create(format) do |p|
          p.set_option :outfile, path1
          p.set_option :bodycolor, :black
          p.add_page tempfile.path
        end
        assert_equal true, result
      ensure
        File.delete(path1)
      end
    end
  end

  def execute_htmldoc(output, input, options)
    IO.popen("#{@program_path} #{options} -f #{output} #{input} 2>&1") { |s| s.read }
  end

end
