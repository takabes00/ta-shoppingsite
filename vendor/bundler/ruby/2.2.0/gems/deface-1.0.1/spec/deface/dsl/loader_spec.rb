require 'spec_helper'

require 'deface/dsl/loader'

describe Deface::DSL::Loader do
  context '.load' do
    context 'extension check' do
      it 'should succeed if file ends with .deface' do
        file = double('deface file')
        filename = 'app/overrides/example_name.deface'

        lambda { Deface::DSL::Loader.load(filename) }.should_not raise_error(
          "Deface::DSL does not know how to read 'app/overrides/example_name.deface'. Override files should end with just .deface, .html.erb.deface, .html.haml.deface or .html.slim.deface")
      end

      it 'should succeed if file ends with .html.erb.deface' do
        file = double('deface file')
        filename = 'app/overrides/example_name.html.erb.deface'

        lambda { Deface::DSL::Loader.load(filename) }.should_not raise_error(
          "Deface::DSL does not know how to read 'app/overrides/example_name.html.erb.deface'. Override files should end with just .deface, .html.erb.deface, .html.haml.deface or .html.slim.deface")
      end

      it 'should succeed if file ends with .html.haml.deface' do
        file = double('deface file')
        filename = 'app/overrides/example_name.html.haml.deface'

        lambda { Deface::DSL::Loader.load(filename) }.should_not raise_error(
          "Deface::DSL does not know how to read 'app/overrides/example_name.html.haml.deface'. Override files should end with just .deface, .html.erb.deface, .html.haml.deface or .html.slim.deface")
      end

      it 'should succeed if file ends with .html.slim.deface' do
        file = double('deface file')
        filename = 'app/overrides/example_name.html.slim.deface'

        lambda { Deface::DSL::Loader.load(filename) }.should_not raise_error(
          "Deface::DSL does not know how to read 'app/overrides/example_name.html.slim.deface'. Override files should end with just .deface, .html.erb.deface, .html.haml.deface or .html.slim.deface")
      end

      it 'should fail if file ends with .blargh.deface' do
        file = double('deface file')
        filename = 'app/overrides/example_name.blargh.deface'

        lambda { Deface::DSL::Loader.load(filename) }.should raise_error(
          "Deface::DSL does not know how to read 'app/overrides/example_name.blargh.deface'. Override files should end with just .deface, .html.erb.deface, .html.haml.deface or .html.slim.deface")
      end

      it "should suceed if parent directory has a dot(.) in it's name" do
        file = double('deface file')
        filename = 'app/overrides/parent.dir.with.dot/example_name.html.haml.deface'

        lambda { Deface::DSL::Loader.load(filename) }.should_not raise_error(
          "Deface::DSL does not know how to read 'app/overrides/parent.dir.with.dot/example_name.html.haml.deface'. Override files should end with just .deface, .html.erb.deface, .html.haml.deface or .html.slim.deface")
      end
    end

    it 'should fail if .html.erb.deface file is in the root of app/overrides' do
      file = double('html/erb/deface file')
      filename = 'app/overrides/example_name.html.erb.deface'

      lambda { Deface::DSL::Loader.load(filename) }.should raise_error(
        "Deface::DSL overrides must be in a sub-directory that matches the views virtual path. Move 'app/overrides/example_name.html.erb.deface' into a sub-directory.")
    end

    it 'should set the virtual_path for a .deface file in a directory below overrides' do
      file = double('deface file')
      filename = 'app/overrides/path/to/view/example_name.deface'
      File.should_receive(:open).with(filename).and_yield(file)

      override_name = 'example_name'
      context = double('dsl context')
      Deface::DSL::Context.should_receive(:new).with(override_name).
        and_return(context)

      file_contents = double('file contents')
      file.should_receive(:read).and_return(file_contents)

      context.should_receive(:virtual_path).with('path/to/view').ordered
      context.should_receive(:instance_eval).with(file_contents).ordered
      context.should_receive(:create_override).ordered

      Deface::DSL::Loader.load(filename)
    end

    it 'should set the virtual_path for a .html.erb.deface file in a directory below overrides' do
      file = double('html/erb/deface file')
      filename = 'app/overrides/path/to/view/example_name.html.erb.deface'
      File.should_receive(:open).with(filename).and_yield(file)

      override_name = 'example_name'
      context = double('dsl context')
      Deface::DSL::Context.should_receive(:new).with(override_name).
        and_return(context)

      file_contents = double('file contents')
      file.should_receive(:read).and_return(file_contents)

      Deface::DSL::Loader.should_receive(:extract_dsl_commands_from_erb).
        with(file_contents).
        and_return(['dsl commands', 'erb'])

      context.should_receive(:virtual_path).with('path/to/view').ordered
      context.should_receive(:instance_eval).with('dsl commands').ordered
      context.should_receive(:erb).with('erb').ordered
      context.should_receive(:create_override).ordered

      Deface::DSL::Loader.load(filename)
    end

    it 'should set the virtual_path for a .html.haml.deface file in a directory below overrides' do
      file = double('html/haml/deface file')
      filename = 'app/overrides/path/to/view/example_name.html.haml.deface'
      File.should_receive(:open).with(filename).and_yield(file)

      override_name = 'example_name'
      context = double('dsl context')
      Deface::DSL::Context.should_receive(:new).with(override_name).
        and_return(context)

      file_contents = double('file contents')
      file.should_receive(:read).and_return(file_contents)

      Deface::DSL::Loader.should_receive(:extract_dsl_commands_from_haml).
        with(file_contents).
        and_return(['dsl commands', 'haml'])

      context.should_receive(:virtual_path).with('path/to/view').ordered
      context.should_receive(:instance_eval).with('dsl commands').ordered
      context.should_receive(:haml).with('haml').ordered
      context.should_receive(:create_override).ordered

      Deface::DSL::Loader.load(filename)
    end

    it 'should set the virtual_path for a .html.slim.deface file in a directory below overrides' do
      file = double('html/slim/deface file')
      filename = 'app/overrides/path/to/view/example_name.html.slim.deface'
      File.should_receive(:open).with(filename).and_yield(file)

      override_name = 'example_name'
      context = double('dsl context')
      Deface::DSL::Context.should_receive(:new).with(override_name).
        and_return(context)

      file_contents = double('file contents')
      file.should_receive(:read).and_return(file_contents)

      Deface::DSL::Loader.should_receive(:extract_dsl_commands_from_slim).
        with(file_contents).
        and_return(['dsl commands', 'slim'])

      context.should_receive(:virtual_path).with('path/to/view').ordered
      context.should_receive(:instance_eval).with('dsl commands').ordered
      context.should_receive(:slim).with('slim').ordered
      context.should_receive(:create_override).ordered

      Deface::DSL::Loader.load(filename)
    end

  end

  context '.register' do
    it 'should register the deface extension with the polyglot library' do
      Polyglot.should_receive(:register).with('deface', Deface::DSL::Loader)

      Deface::DSL::Loader.register
    end
  end

  context '.extract_dsl_commands_from_erb' do
    it 'should work in the simplest case' do
      example = "<!-- test 'command' --><h1>Wow!</h1>"
      dsl_commands, the_rest = Deface::DSL::Loader.extract_dsl_commands_from_erb(example)
      dsl_commands.should == "\ntest 'command'"
      the_rest.should == "<h1>Wow!</h1>"
    end

    it 'should combine multiple comments' do
      example = "<!-- test 'command' --><!-- another 'command' --><h1>Wow!</h1>"
      dsl_commands, the_rest = Deface::DSL::Loader.extract_dsl_commands_from_erb(example)
      dsl_commands.should == "\ntest 'command'\nanother 'command'"
      the_rest.should == "<h1>Wow!</h1>"
    end

    it 'should leave internal comments alone' do
      example = "<br/><!-- test 'command' --><!-- another 'command' --><h1>Wow!</h1>"
      dsl_commands, the_rest = Deface::DSL::Loader.extract_dsl_commands_from_erb(example)
      dsl_commands.should == ""
      the_rest.should == example
    end

    it 'should work with comments on own lines' do
      example = "<!-- test 'command' -->\n<!-- another 'command' -->\n<h1>Wow!</h1>"
      dsl_commands, the_rest = Deface::DSL::Loader.extract_dsl_commands_from_erb(example)
      dsl_commands.should == "\ntest 'command'\nanother 'command'"
      the_rest.should == "\n<h1>Wow!</h1>"
    end

    it 'should work with newlines inside the comment' do
      example = "<!--\n test 'command'\nanother 'command'\n -->\n<h1>Wow!</h1>"
      dsl_commands, the_rest = Deface::DSL::Loader.extract_dsl_commands_from_erb(example)
      dsl_commands.should == "\ntest 'command'\nanother 'command'"
      the_rest.should == "\n<h1>Wow!</h1>"
    end

    it 'should work with multiple commands on one line' do
      example = %q{<!-- replace_contents 'h1 .title' closing_selector "div#intro" disabled namespaced --><h1>Wow!</h1>}
      dsl_commands, the_rest = Deface::DSL::Loader.extract_dsl_commands_from_erb(example)
      dsl_commands.should == "\nreplace_contents 'h1 .title'\nclosing_selector \"div#intro\"\ndisabled\nnamespaced"
      the_rest.should == "<h1>Wow!</h1>"
    end

    it 'should work with multiple commands on one line when command argument is not a normal string' do
      example = %q{<!-- replace_contents 'h1 .title' closing_selector %q{div#intro} disabled namespaced --><h1>Wow!</h1>}
      dsl_commands, the_rest = Deface::DSL::Loader.extract_dsl_commands_from_erb(example)
      dsl_commands.should == "\nreplace_contents 'h1 .title'\nclosing_selector %q{div#intro}\ndisabled\nnamespaced"
      the_rest.should == "<h1>Wow!</h1>"
    end

    it 'should work with multiple commands on one line when command argument is an integer' do
      example = %q{<!-- replace_contents 'h1 .title' disabled sequence 2 namespaced --><h1>Wow!</h1>}
      dsl_commands, the_rest = Deface::DSL::Loader.extract_dsl_commands_from_erb(example)
      dsl_commands.should == "\nreplace_contents 'h1 .title'\ndisabled\nsequence 2\nnamespaced"
      the_rest.should == "<h1>Wow!</h1>"
    end

    it 'should work with multiple commands on one line when command argument is a hash' do
      example = %q{<!-- add_to_attributes 'h1 .title' attributes :class => 'pretty'--><h1>Wow!</h1>}
      dsl_commands, the_rest = Deface::DSL::Loader.extract_dsl_commands_from_erb(example)
      dsl_commands.should == "\nadd_to_attributes 'h1 .title'\nattributes :class => 'pretty'"
      the_rest.should == "<h1>Wow!</h1>"
    end
  end

  context '.extract_dsl_commands_from_haml' do
    it 'should work in the simplest case' do
      example = "/ test 'command'\n/ another 'command'\n%h1 Wow!"
      dsl_commands, the_rest = Deface::DSL::Loader.extract_dsl_commands_from_haml(example)
      dsl_commands.should == "test 'command'\nanother 'command'\n"
      the_rest.should == "%h1 Wow!"
    end

    it 'should work with a block style comment using spaces' do
      example = "/\n  test 'command'\n  another 'command'\n%h1 Wow!"
      dsl_commands, the_rest = Deface::DSL::Loader.extract_dsl_commands_from_haml(example)
      dsl_commands.should == "\ntest 'command'\nanother 'command'\n"
      the_rest.should == "%h1 Wow!"
    end

    it 'should leave internal comments alone' do
      example = "%br\n/ test 'command'\n/ another 'command'\n%h1 Wow!"
      dsl_commands, the_rest = Deface::DSL::Loader.extract_dsl_commands_from_erb(example)
      dsl_commands.should == ""
      the_rest.should == example
    end
  end

  context '.extract_dsl_commands_from_slim' do
    it 'should work in the simplest case' do
      example = "/ test 'command'\n/ another 'command'\nh1 Wow!"
      dsl_commands, the_rest = Deface::DSL::Loader.extract_dsl_commands_from_slim(example)
      dsl_commands.should == "test 'command'\nanother 'command'\n"
      the_rest.should == "h1 Wow!"
    end

    it 'should work with a block style comment using spaces' do
      example = "/\n  test 'command'\n  another 'command'\nh1 Wow!"
      dsl_commands, the_rest = Deface::DSL::Loader.extract_dsl_commands_from_slim(example)
      dsl_commands.should == "\ntest 'command'\nanother 'command'\n"
      the_rest.should == "h1 Wow!"
    end

    it 'should leave internal comments alone' do
      example = "br\n/ test 'command'\n/ another 'command'\nh1 Wow!"
      dsl_commands, the_rest = Deface::DSL::Loader.extract_dsl_commands_from_erb(example)
      dsl_commands.should == ""
      the_rest.should == example
    end
  end
end
