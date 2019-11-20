require 'integration_spec_helper'
require 'vorpal'

describe Vorpal::Driver::Postgresql do
  describe '#build_db_class' do
    let(:db_class) { subject.build_db_class(PostgresDriverSpec::Foo, 'example') }

    it 'generates a valid class name so that rails auto-reloading works' do
      expect { Vorpal.const_defined?(db_class.name) }.to_not raise_error
    end

    it 'does not let the user access the generated class' do
      expect { Vorpal.const_get(db_class.name) }.to raise_error(NameError)
    end

    it 'isolates two POROs that map to the same db table' do
      db_class1 = build_db_class(PostgresDriverSpec::Foo)
      db_class2 = build_db_class(PostgresDriverSpec::Bar)

      expect(db_class1).to_not eq(db_class2)
      expect(db_class1.name).to_not eq(db_class2.name)
    end

    it 'uses the model class name to make the generated AR::Base class name unique' do
      db_class = build_db_class(PostgresDriverSpec::Foo)

      expect(db_class.name).to match("PostgresDriverSpec__Foo")
    end
  end

  private

  module PostgresDriverSpec
    class Foo; end
    class Bar; end
  end

  def build_db_class(clazz)
    db_driver = Vorpal::Driver::Postgresql.new
    db_driver.build_db_class(clazz, 'example')
  end
end
