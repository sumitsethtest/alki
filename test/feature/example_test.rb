require 'alki/feature_test'

describe 'Example' do
  before do
    require 'example'

    @expected = [
      "1","2","Fizz!","4","Buzz!","Fizz!","7", "8", "Fizz!",
      "Buzz!", "11", "Fizz!", "13", "14", "Fizzbuzz!", "16",
      "17", "Fizz!", "19", "Buzz!"
    ]
    @handlers = [
      ['fizzbuzz', /Fizzbuzz!/],
      ['fizz', /Fizz!/],
      ['buzz', /Buzz!/],
      ['echo', /\d+/],
    ]
  end

  describe 'run' do
    before do
      @app = Example.new
      @app.run 1..20
    end

    it 'should set output to correct fizzbuzz results' do
      @app.output.to_a.must_equal @expected
    end

    it 'should log calls to handlers due to overlay' do
      log_lines = @app.log_io.string.split(/\n/)

      @expected.each.with_index do |val,i|
        @handlers.find do |(handler,re)|
          log_lines.shift.must_equal "Calling handlers.#{handler}#handle #{i+1}"
          val =~ re
        end
      end
    end
  end

  it 'should have config_dir value' do
    Example.new.config_dir.must_equal Alki::Test.fixture_path('example','config')
  end
end
